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

# Executable Code

## Basics

```{code-cell} ipython3
import edrixs
umat = edrixs.get_umat_slater('p', 1, 2)
print(umat)
```

$$
    \begin{equation}
    \hat{H} = \sum_{\alpha,\beta,\gamma,\delta,\sigma,\sigma^\prime}
    U_{\alpha\sigma,\beta\sigma^\prime,\gamma\sigma^\prime,\delta\sigma}
    \hat{f}^{\dagger}_{\alpha\sigma}
    \hat{f}^{\dagger}_{\beta\sigma^\prime}
    \hat{f}_{\gamma\sigma^\prime}\hat{f}_{\delta\sigma},
    \end{equation}
$$

```{code-cell} ipython3
a = 8**2
```

```{code-cell} ipython3
a
```

This cell has an expected error:

```{code-cell} ipython3
:tags: [raises-exception]

1 / 0
```

## Exercises

Add one plus one.

```{code-cell} ipython3
# Write your solution here.
```

```{code-cell} ipython3
---
tags: [hide-cell]
jupyter:
  source_hidden: true
---
# Expand to reveal solution.

1 + 1
```
