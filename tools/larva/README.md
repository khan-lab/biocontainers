# LARVA

[LARVA](https://github.com/gersteinlab/LARVA) identifies noncoding regions with a
significant excess of somatic mutations across a cancer cohort, using a beta-binomial
model of mutation burden corrected for DNA replication timing.

- **Upstream:** https://github.com/gersteinlab/LARVA (untagged; built from `master`)
- **License:** none declared upstream (no LICENSE file). Treated as all-rights-reserved
  academic source — image is published for internal/research use only.
- **Image:** `ghcr.io/khan-lab/larva`
- **Platform:** `linux/amd64` only (bundles an amd64 `bigWigAverageOverBed` helper).

## Pull

```bash
docker pull ghcr.io/khan-lab/larva:latest
```

## Reference data (required at runtime)

LARVA needs its "data context" (`replication_timing.bw`, `blacklist_regions.bed`,
`genes.bed`, `pgenes.bed`, ~245 MB) from http://larva.gersteinlab.org. It is **not**
baked into the image; the binary looks for these under `code/annotations/` relative to the
working directory (`/data`), so mount them there:

```bash
docker run --rm \
    -v "$PWD/code/annotations:/data/code/annotations" \
    -v "$PWD:/data" -v "$PWD/out:/out" \
    ghcr.io/khan-lab/larva \
    -vf /data/mutations.bed -af /data/elements.bed -o /out/results.txt
```

## Help

```bash
docker run --rm ghcr.io/khan-lab/larva --help
```

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
