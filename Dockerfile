# ── build the Pixi environment ──────────────────────────────────────────────
FROM ghcr.io/prefix-dev/pixi:0.49.0 AS build
WORKDIR /app

# 1 ▪ Copy only env manifests first → keeps the heavy layer cache-able
COPY pixi.toml  ./
RUN pixi install       # writes env to .pixi/
EXPOSE 7878
# 2 ▪ Add the rest of your project
COPY . .
CMD ["jupyter", "lab", "--ip=0.0.0.0", " --port=7878 ", "--no-browser", "--allow-root"]



