# MutEnricher

[MutEnricher](https://github.com/asoltis/MutEnricher) identifies enrichment of somatic
mutations in coding genes and noncoding regions (promoters, enhancers, etc.) from
cohorts of whole-genome variant calls.

- **Upstream:** https://github.com/asoltis/MutEnricher (tag `v1.3.3`)
- **License:** MIT
- **Image:** `ghcr.io/khan-lab/mutenricher`
- **Platform:** `linux/amd64` only (pins a Python 3.7 / 2021-era stack with no arm64 wheels).

## Pull

```bash
docker pull ghcr.io/khan-lab/mutenricher:latest
```

## Usage

```bash
# Coding analysis
docker run --rm -v "$PWD:/data" -v "$PWD/out:/out" \
    ghcr.io/khan-lab/mutenricher \
    coding /data/genes.gtf.gz /data/vcf_files.txt -o /out --prefix run

# Noncoding analysis
docker run --rm -v "$PWD:/data" -v "$PWD/out:/out" \
    ghcr.io/khan-lab/mutenricher \
    noncoding /data/regions.bed /data/vcf_files.txt -o /out --prefix run
```

`vcf_files.txt` lists the per-sample VCF paths. For hotspot/background analyses a
reference-genome FASTA (`.fai` indexed) is also supplied via the relevant options.
The upstream repo's `example_data/` has a small end-to-end quickstart.

## Help

```bash
docker run --rm ghcr.io/khan-lab/mutenricher --help
```

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
