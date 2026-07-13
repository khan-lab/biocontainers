# Dig / DIGDriver

[DIGDriver](https://github.com/maxwellsh/DIGDriver) detects coding and noncoding cancer
driver elements using a deep-learning model of the genome-wide neutral mutation rate to
derive element-level expected mutation counts, then tests for significant excess.

- **Upstream:** https://github.com/maxwellsh/DIGDriver (conda package `digdriver` 0.1)
- **License:** BSD-3-Clause
- **Image:** `ghcr.io/khan-lab/digdriver`
- **Platform:** `linux/amd64` only (installed from the `mutation_density` conda channel,
  which has no arm64 build; pinned Python 3.7 / R 3.5 stack).

> **Draft image.** This is the most fragile recipe in the batch (legacy pins on a personal
> conda channel plus an R `dndscv` install). It may need a CI iteration or two to go green.

## Pull

```bash
docker pull ghcr.io/khan-lab/digdriver:latest
```

## Reference data (required at runtime)

DIGDriver needs `hg19.fasta` plus pretrained mutation-map `.h5` files (**~3.6 GB+**) from
http://cb.csail.mit.edu/DIG/downloads/. These are **not** baked into the image — download
and mount them at `/data`.

## Usage

```bash
docker run --rm -v "$PWD:/data" -v "$PWD/out:/out" ghcr.io/khan-lab/digdriver \
    element_test --help
```

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
- The `dndscv` R annotation step is best-effort at build time; install it in a derived
  image if the coding dNdScv path fails.
