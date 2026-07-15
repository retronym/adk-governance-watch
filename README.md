# ADK + Regulus tracking workspace

A thin meta-repo that tracks a set of upstream **Google ADK** repositories and
the **Regulus** governance layer, for studying agent-runtime extension seams and
AI-governance features (see [REPOS.md](REPOS.md)).

The sub-repos themselves are **not** committed here — they are git-ignored and
reconstructed on demand from the manifest. This repo tracks only:

- [`REPOS.md`](REPOS.md) — the index + governance watch-list.
- [`repos.txt`](repos.txt) — the manifest (dir · branch · URL).
- [`clone.sh`](clone.sh) — clones/updates every sub-repo from the manifest.

## Get the sources

```bash
./clone.sh            # clone or fast-forward every repo in repos.txt
./clone.sh adk-java   # just one (or a few)
DEPTH=1 ./clone.sh    # shallow, faster, no full history
```

`clone.sh` is idempotent — an existing checkout is fetched and fast-forwarded
rather than re-cloned. Add or remove sources by editing `repos.txt` (and the
matching entry in `.gitignore`).
