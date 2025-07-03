# EDRIXS Tutorials

These tutorials introduce the use of EDRIXS.

## How to Run The Code

`````{tab-set}
````{tab-item} In Cloud with Binder (recommended)

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
`````

Or, instead of _running_ the code, you may view the code and results by
following the links below.

## Example Tutorials

```{toctree}
---
maxdepth: 1
glob:
caption: User tutorials
---

tutorials/**/*

```
[Open on Binder]: https://mybinder.org/v2/gh/EDRIXS/RIXSREXS2025-tutorial/main?urlpath=tree/tutorials/
[docker]: https://www.docker.com/products/docker-desktop/
[repository]: https://github.com/EDRIXS/RIXSREXS2025-tutorial/archive/refs/heads/main.zip
