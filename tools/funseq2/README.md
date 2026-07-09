# FunSeq2

[FunSeq2](https://github.com/gersteinlab/FunSeq2) annotates and prioritises noncoding
somatic variants by integrating large-scale functional genomics annotations
(conservation, TF motifs/binding, enhancer-gene links, network centrality) into a weighted
scoring scheme to flag candidate noncoding driver mutations.

- **Upstream:** https://github.com/gersteinlab/FunSeq2 (no release; built from `master`)
- **License:** the repository is contradictory — the `LICENSE` file is **CC0-1.0** while
  the README text says **CC BY-NC** (non-commercial). Treated cautiously; image published
  for internal/research use only pending clarification with upstream.
- **Image:** `ghcr.io/khan-lab/funseq2`
- **Platform:** `linux/amd64` + `linux/arm64` (bioconda deps have aarch64 builds).

> **Draft image.** FunSeq2 has hardcoded paths in `config.txt`/`funseq2.sh` and builds
> compiled helpers (TFMpvalue, optionally VAT) from source. It may need a CI iteration.

## Pull

```bash
docker pull ghcr.io/khan-lab/funseq2:latest
```

## Reference data (required at runtime)

FunSeq2 needs its external "data context" (**~40 GB**: conservation, TF motifs/binding,
enhancer-gene links, precomputed scores) from funseq2.gersteinlab.org, mounted at runtime
and referenced from `config.txt`. It is **not** baked into the image.

## Usage

```bash
docker run --rm -v "$PWD:/data" -v "$PWD/out:/out" ghcr.io/khan-lab/funseq2 \
    -f /data/input.vcf -maf 0 -m 1 -inf vcf -outf vcf -nc -o /out
```

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
