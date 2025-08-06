# EDRIXS Course for RIXSREXS2025

These tutorials introduce the use of EDRIXS.

## How to Run The Code
For the tutorial, recommend running the code entirely online via the first option "In could via Binder".
`````{tab-set}
````{tab-item} In cloud via Binder

[Open on Binder][].

````

````{tab-item} Locally via Docker

Install the [docker] application on your computer.

Download and extract the [repository].

Open the Docker Desktop app and go to the Terminal tab in the bottom right corner.
Change directory via `cd` first into the download folder and then into the primary `RIXSREXS2025-tutorials-main` folder containing the `docker-compose.yml` file and execute

```console
docker compose up
```
````

````{tab-item} Locally on linux

If you don't already have git, install it and, if needed, install pixi via

```console
curl -fsSL https://pixi.sh/install.sh | bash
```
Then the tutorials can be run via
```console
git clone https://github.com/EDRIXS/RIXSREXS2025-tutorial.git
cd RIXSREXS2025-tutorial
pixi run start
```

````
`````

Or, instead of _running_ the code, you may view the code and results by
following the links below.

## Tutorials

```{toctree}
---
maxdepth: 1
glob:
---
tutorials/intro/intro.md
tutorials/atomic/atomic_model.md
tutorials/AIM/AIM.md
```
[Open on Binder]: https://mybinder.org/v2/gh/EDRIXS/RIXSREXS2025-tutorial/main?urlpath=tree/tutorials/
[docker]: https://www.docker.com/products/docker-desktop/
[repository]: https://github.com/EDRIXS/RIXSREXS2025-tutorial/archive/refs/heads/main.zip
