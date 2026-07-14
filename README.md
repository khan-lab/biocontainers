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
| [MutEnricher](tools/mutenricher/) | Somatic coding/noncoding mutation enrichment | `ghcr.io/khan-lab/mutenricher` |
| [LARVA](tools/larva/) | Recurrent-variant analysis in noncoding annotations | `ghcr.io/khan-lab/larva` |
| [ActiveDriverWGS](tools/activedriverwgs/) | Coding/noncoding cancer driver discovery | `ghcr.io/khan-lab/activedriverwgs` |
| [fishHook](tools/fishhook/) | Mutation enrichment in genomic intervals | `ghcr.io/khan-lab/fishhook` |
| [ncdDetect2](tools/ncddetect/) | Noncoding cancer driver detection | `ghcr.io/khan-lab/ncddetect` |
| [MutSpot](tools/mutspot/) | Recurrent noncoding mutation hotspot detection | `ghcr.io/khan-lab/mutspot` |
| [DriverPower](tools/driverpower/) | Coding/noncoding driver detection (burden + impact) | `ghcr.io/khan-lab/driverpower` |
| [DIGDriver](tools/digdriver/) | Mutation-rate model for cancer driver detection | `ghcr.io/khan-lab/digdriver` |
| [FunSeq2](tools/funseq2/) | Functional annotation of noncoding somatic variants | `ghcr.io/khan-lab/funseq2` |

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
docker pull ghcr.io/khan-lab/mutenricher:latest
docker pull ghcr.io/khan-lab/larva:latest
docker pull ghcr.io/khan-lab/activedriverwgs:latest
docker pull ghcr.io/khan-lab/fishhook:latest
docker pull ghcr.io/khan-lab/ncddetect:latest
docker pull ghcr.io/khan-lab/mutspot:latest
docker pull ghcr.io/khan-lab/driverpower:latest
docker pull ghcr.io/khan-lab/digdriver:latest
docker pull ghcr.io/khan-lab/funseq2:latest
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

## Local Development

Use `scripts/build-test.sh` to build and smoke-test images locally before pushing.

### Build changed tools (auto-detect via git)

```bash
bash scripts/build-test.sh
```

Detects tools with uncommitted changes or untracked new tool directories compared to
the last commit. To compare against a different base ref:

```bash
bash scripts/build-test.sh --base main
```

### Build and test a specific tool

```bash
bash scripts/build-test.sh -t fastqc
bash scripts/build-test.sh -t cnvkit -t strelka2   # multiple tools
```

### Build all tools

```bash
bash scripts/build-test.sh --all
```

### Build only (skip smoke test)

```bash
bash scripts/build-test.sh -t homer --no-test
```

### Options

| Flag | Description |
|------|-------------|
| `-t/--tool TOOL` | Build/test a specific tool (repeatable) |
| `-a/--all` | Build/test all tools |
| `--base REF` | Git ref for change detection (default: `HEAD`) |
| `--no-test` | Build only, skip smoke test |
| `--platform PLATFORM` | Docker platform (default: auto-detected from host) |

Built images are tagged `ghcr.io/khan-lab/<tool>:local`.

## Repository Layout

```
.
├── .github/workflows/build-images.yml   # CI/CD pipeline
├── scripts/
│   └── build-test.sh                    # Local build and smoke-test script
├── tools/
│   └── <tool>/                          # One directory per tool
│       ├── Dockerfile                   # Multi-stage container definition
│       ├── README.md                    # Usage and mount-point docs
│       ├── tool.yml                     # Metadata (name, version, license)
│       └── bin/                         # Wrapper scripts (run_<tool>.sh)
├── .editorconfig
├── .gitignore
├── LICENSE
└── README.md
```

## Adding a New Tool

1. Create `tools/<newtool>/` with `Dockerfile`, `README.md`, `tool.yml`, and `bin/`.
2. Add a paths-filter entry in `.github/workflows/build-images.yml` for the new tool.
3. Follow the release process above to tag and publish.
