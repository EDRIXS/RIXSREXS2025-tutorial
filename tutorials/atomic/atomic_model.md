---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.17.2
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

# RIXS calculations for an atomic model
Here we show how to compute RIXS for Sr₂YIrO₆ based on Ref. [^1]. 

![Sr₂YIrO₆](./Sr2YIrO6.png)

## Imports

```{code-cell} ipython3
:tags: [remove_output]

import edrixs
import numpy as np
import matplotlib.pyplot as plt

%matplotlib widget
```

```{code-cell} ipython3
:tags: [hide_input, hide_output]
# Secretly make figures look nice!
plt.rcParams.update({
    'figure.dpi': 200,
    'savefig.dpi': 300})
```

## Specify active core and valence orbitals

```{code-cell} ipython3
shell_name = ('t2g', 'p32')
v_noccu = 4
```

## Slater parameters
The paper specifies the interactions in terms of the Hund's interaction
`JH`, Coulomb repulsion `Ud`, and spin orbit coupling `lam`. Other interaction parameters can be loaded from a database containing Hartree-Fock predictions.

```{code-cell} ipython3
Ud = 2
JH = 0.25
lam = 0.42
F0_d, F2_d, F4_d = edrixs.UdJH_to_F0F2F4(Ud, JH)
info = edrixs.utils.get_atom_data('Ir', '5d', v_noccu, edge='L3')
G1_dp = info['slater_n'][5][1]
G3_dp = info['slater_n'][6][1]
F0_dp = edrixs.get_F0('dp', G1_dp, G3_dp)
F2_dp = info['slater_n'][4][1]

slater = [[F0_d, F2_d, F4_d],
          [F0_d, F2_d, F4_d, F0_dp, F2_dp, G1_dp, G3_dp]]
v_soc = (lam, lam)
```

## Diagonalization
Since we have already specified a $t_{2g}$ subshell only, we do not need to pass an additional `v_cfmat` matrix.

Note that we need to tune the energy of the intermediate state via `off`.

```{code-cell} ipython3
:tags: [hide-output]

off = 11209
out = edrixs.ed_1v1c_py(shell_name, shell_level=(0, -off), v_soc=v_soc,
                        c_soc=info['c_soc'], v_noccu=v_noccu, slater=slater)
eval_i, eval_n, trans_op = out
```

## Compute XAS

```{code-cell} ipython3
eval_i[0]- eval_i[1]
```

```{code-cell} ipython3
:tags: [hide-output]

ominc = np.arange(11200, 11230, 0.1)
temperature = 300  # in K

thin = np.deg2rad(30)
pol_type = [('linear', 0)]

xas = edrixs.xas_1v1c_py(
    eval_i, eval_n, trans_op, ominc, gamma_c=info['gamma_c'],
    thin=thin, pol_type=pol_type)
```

## Compute RIXS

```{code-cell} ipython3
:tags: [hide-output]

eloss = np.linspace(-.5, 6, 400)
pol_type_rixs = [('linear', 0, 'linear', 0), ('linear', 0, 'linear', np.pi/2)]
gs_list = [0, 1, 2]
thout = np.deg2rad(60)
gamma_f = 0.02

rixs = edrixs.rixs_1v1c_py(
    eval_i, eval_n, trans_op, ominc, eloss,
    gamma_c=info['gamma_c'], gamma_f=gamma_f,
    thin=thin, thout=thout,
    pol_type=pol_type_rixs, gs_list=gs_list,
    temperature=temperature
)
```

The array :code:`xas` will have shape
:code:`(len(ominc_xas), len(pol_type))`



## Plot XAS and RIXS

```{code-cell} ipython3
fig, axs = plt.subplots(2, 2, figsize=(7, 7))

def plot_it(axs, ominc, xas, eloss, rixscut, rixsmap=None, label=None):
    axs[0].plot(ominc, xas[:, 0], label=label)
    axs[0].set_xlabel('Energy (eV)')
    axs[0].set_ylabel('Intensity')
    axs[0].set_title('XAS')

    axs[1].plot(eloss, rixscut, label=f"{label}")
    axs[1].set_xlabel('Energy loss (eV)')
    axs[1].set_ylabel('Intensity')
    axs[1].set_title(f'RIXS at resonance')

    if rixsmap is not None:
        art = axs[2].pcolormesh(ominc, eloss, rixsmap.T, shading='auto')
        plt.colorbar(art, ax=axs[2], label='Intensity')
        axs[2].set_xlabel('Incident energy (eV)')
        axs[2].set_ylabel('Energy loss')
        axs[2].set_title('RIXS map')


rixs_pol_sum = rixs.sum(-1)
cut_index = np.argmax(rixs_pol_sum[:, eloss < 2].sum(1))
rixscut = rixs_pol_sum[cut_index]

plot_it(axs.ravel(), ominc, xas, eloss, rixscut, rixsmap=rixs_pol_sum)
axs[0, 1].set_xlim(right=3)
axs[1, 0].set_ylim(top=3)
axs[1, 1].remove()
plt.tight_layout()
```

## Full d shell calculation
Does it make sense to consider only the $t_{2g}$ subshell?

```{code-cell} ipython3
:tags: [hide-output]

ten_dq = 3.5
v_cfmat = edrixs.cf_cubic_d(ten_dq)
off += ten_dq*2/5
out = edrixs.ed_1v1c_py(('d', 'p32'), shell_level=(0, -off), v_soc=v_soc,
                        v_cfmat=v_cfmat,
                        c_soc=info['c_soc'], v_noccu=v_noccu, slater=slater)
eval_i, eval_n, trans_op = out

xas_full_d_shell = edrixs.xas_1v1c_py(
    eval_i, eval_n, trans_op, ominc, gamma_c=info['gamma_c'],
    thin=thin, pol_type=pol_type,
    gs_list=gs_list)

rixs_full_d_shell = edrixs.rixs_1v1c_py(
    eval_i, eval_n, trans_op, np.array([11215]), eloss,
    gamma_c=info['gamma_c'], gamma_f=gamma_f,
    thin=thin, thout=thout,
    pol_type=pol_type_rixs,
    temperature=temperature)
```

```{code-cell} ipython3
:tags: [hide-output]

fig, axs = plt.subplots(1, 2, figsize=(7, 3.5))
plot_it(axs, ominc, xas, eloss, rixscut, label='$t_{2g}$ subshell')
rixscut = rixs_full_d_shell.sum((0, -1))
plot_it(axs, ominc, xas_full_d_shell, eloss, rixscut, label='$d$ shell')

axs[0].legend()
axs[1].legend()
plt.tight_layout()
```

## References
[^1]: Bo Yuan et al.,
       [Phys. Rev. B 95, 235114 (2017)](https://doi.org/10.1103/PhysRevB.95.235114).

[^2]: Georgios L. Stamokostas and Gregory A. Fiete,
       [Phys. Rev. B 97, 085150 (2018)](https://doi.org/10.1103/PhysRevB.97.085150).
