# CBCRG's biocontainers

>  Computational Biology & Cancer Regulatory Genomics Lab's monorepo of containerized wrappers for bioinformatics tools.

Each tool lives in `tools/<tool>/` with its own Dockerfile, wrapper scripts, and metadata.
Images are built via GitHub Actions and pushed to the GitHub Container Registry (GHCR).

## Available Tools

| Tool | Description | Image |
|------|-------------|-------|
| [FastQC](tools/fastqc/) | Quality control for sequencing data | `ghcr.io/khan-lab/fastqc` |
| [ROSE](tools/rose/) | Super-enhancer identification | `ghcr.io/khan-lab/rose` |
| [QDNAseq](tools/qdnaseq/) | Shallow WGS CNV calling / binning | `ghcr.io/khan-lab/qdnaseq` |
| [pyJASPAR](tools/pyjaspar/) | Python interface to JASPAR motif database | `ghcr.io/khan-lab/pyjaspar` |
| [deepTools](tools/deeptools/) | Tools for exploring deep-sequencing data | `ghcr.io/khan-lab/deeptools` |
| [MACS3](tools/macs3/) | Model-based Analysis of ChIP-Seq | `ghcr.io/khan-lab/macs3` |
| [TOBIAS](tools/tobias/) | TF occupancy prediction from ATAC-seq | `ghcr.io/khan-lab/tobias` |
| [rGREAT](tools/rgreat/) | Genomic region enrichment analysis | `ghcr.io/khan-lab/rgreat` |
| [HOMER](tools/homer/) | Motif discovery and ChIP-seq analysis | `ghcr.io/khan-lab/homer` |
| [TelomereHunter](tools/telomerehunter/) | Telomere content estimation from WGS | `ghcr.io/khan-lab/telomerehunter` |
| [TelSeq](tools/telseq/) | Telomere length estimation from WGS | `ghcr.io/khan-lab/telseq` |
| [OncodriveFML](tools/oncodrivefml/) | Positive selection in coding/noncoding somatic mutations | `ghcr.io/khan-lab/oncodrivefml` |

## Pulling Images

```bash
docker pull ghcr.io/khan-lab/fastqc:latest
docker pull ghcr.io/khan-lab/rose:latest
docker pull ghcr.io/khan-lab/qdnaseq:latest
docker pull ghcr.io/khan-lab/pyjaspar:latest
docker pull ghcr.io/khan-lab/deeptools:latest
docker pull ghcr.io/khan-lab/macs3:latest
docker pull ghcr.io/khan-lab/tobias:latest
docker pull ghcr.io/khan-lab/rgreat:latest
docker pull ghcr.io/khan-lab/homer:latest
docker pull ghcr.io/khan-lab/telomerehunter:latest
docker pull ghcr.io/khan-lab/telseq:latest
docker pull ghcr.io/khan-lab/oncodrivefml:latest
```

## Image Tags

| Tag | When Published |
|-----|---------------|
| `latest` | On release tag (e.g. `fastqc/v0.12.1`) |
| `X.Y.Z` | On release tag (the version extracted from the tag) |
| `edge` | On every push to `main` |
| `sha-<shortsha>` | On every push to `main` |

Pull requests build images but do **not** push them.

## Release Process

1. Update the `version` field in `tools/<tool>/tool.yml`.
2. Commit the change:
   ```bash
   git add tools/<tool>/tool.yml
   git commit -m "<tool>: bump to vX.Y.Z"
   ```
3. Create and push a git tag:
   ```bash
   git tag <tool>/vX.Y.Z
   git push origin <tool>/vX.Y.Z
   ```
4. GitHub Actions will build and push the image tagged as `X.Y.Z` and `latest`.

## Repository Layout

```
.
├── .github/workflows/build-images.yml   # CI/CD pipeline
├── tools/
│   ├── fastqc/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_fastqc.sh
│   ├── rose/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_rose.sh
│   ├── qdnaseq/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/
│   │       ├── run_qdnaseq.R
│   │       └── run_qdnaseq.sh
│   ├── pyjaspar/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_pyjaspar.sh
│   ├── deeptools/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_deeptools.sh
│   ├── macs3/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_macs3.sh
│   ├── tobias/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_tobias.sh
│   ├── rgreat/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/
│   │       ├── run_rgreat.R
│   │       └── run_rgreat.sh
│   ├── homer/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_homer.sh
│   ├── telomerehunter/
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── tool.yml
│   │   └── bin/run_telomerehunter.sh
│   └── telseq/
│       ├── Dockerfile
│       ├── README.md
│       ├── tool.yml
│       └── bin/run_telseq.sh
├── .editorconfig
├── .gitignore
├── LICENSE
└── README.md
```

## Adding a New Tool

1. Create `tools/<newtool>/` with `Dockerfile`, `README.md`, `tool.yml`, and `bin/`.
2. Add a paths-filter entry in `.github/workflows/build-images.yml` for the new tool.
3. Follow the release process above to tag and publish.
