# pyJASPAR

Python interface to the [JASPAR](https://jaspar.elixir.no/) transcription factor binding
profile database. Provides programmatic access to query, retrieve, and analyze motifs from
all JASPAR releases.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/pyjaspar:latest
```

## Usage

pyJASPAR is a Python library. Use it by running Python scripts or interactive sessions.

### Interactive session

```bash
docker run --rm -it ghcr.io/khan-lab/pyjaspar:latest
```

Then in the Python shell:

```python
from pyjaspar import jaspardb

jdb = jaspardb(release="JASPAR2024")

# Fetch a motif by ID
motif = jdb.fetch_motif_by_id("MA0139.1")
print(motif.name)       # TP53
print(motif.matrix_id)  # MA0139.1

# Search motifs by name
motifs = jdb.fetch_motifs_by_name("CTCF")
for m in motifs:
    print(m.matrix_id, m.name)
```

### Run a script

```bash
docker run --rm \
    -v /path/to/scripts:/scripts \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/pyjaspar:latest \
    /scripts/my_analysis.py
```

### Using the wrapper script

```bash
docker run --rm \
    -v /path/to/scripts:/scripts \
    -v /path/to/output:/out \
    --entrypoint run_pyjaspar.sh \
    ghcr.io/khan-lab/pyjaspar:latest \
    /scripts/my_analysis.py
```

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Python scripts | `/scripts` | Analysis scripts using pyJASPAR |
| Output directory | `/out` | Results and exported motifs |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
