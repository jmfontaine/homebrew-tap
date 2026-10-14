# jmfontaine/tap

Personal Homebrew tap.

## Formulae

| Formula | Description |
| --- | --- |
| [`agent-discogs`](Formula/agent-discogs.rb) | [agent-discogs](https://github.com/jmfontaine/agent-discogs), token-efficient Discogs CLI for AI agents |
| [`redumper`](Formula/redumper.rb) | [redumper](https://github.com/superg/redumper), low-level optical disc dumper (macOS only) |

## Install

```sh
brew install jmfontaine/tap/agent-discogs
brew install jmfontaine/tap/redumper
```

Or `brew tap jmfontaine/tap` and then `brew install <formula>`.

Or, in a `Brewfile`:

```ruby
tap "jmfontaine/tap"
brew "agent-discogs"
brew "redumper"
```

## agent-discogs Notes

- Installs the PyPI release into a virtualenv on `python@3.15`, the Python `homebrew/core` uses, with every Python dependency pinned as a `resource` block. Nothing bumps `depends_on "python@3.15"` automatically: update it when `homebrew/core` moves to a newer Python.
- Building from source needs Rust (`rust`, build-only) for `pydantic-core`. Bottles do not.
- The daily autobump opens a PR for the newest PyPI release once it is past Homebrew's one-day release cooldown (none while a bump PR is still open), and regenerates the `resource` blocks in the same PR.

## Redumper Notes

- Built from source with LLVM 18 (`llvm@18`, build-only), matching upstream's toolchain. The binary links against the system libc++.
- Upstream tags builds as `bNNN`; the formula version is `NNN` (e.g. `b753` → `753`). `redumper --version` reports the upstream build plus any local patch suffix (e.g. `build: b753+d8fix`).
- Carries a patch for PLEXTOR lead-in reads through USB-ATAPI bridges that pad D8 transfers (JMicron `0x152D:0x2338`), a regression from upstream [#447](https://github.com/superg/redumper/pull/447) in `b751`. The `+d8fix` build suffix marks patched binaries, so it also shows up in dump logs and MPF's Redump submission info. The patch and suffix are removed together once upstream ships a fix.
- If redumper fails with `failed to create service plugin interface ... resource shortage`, macOS privacy controls blocked IOKit access; run it from a directory outside Desktop, Documents and Downloads (see upstream's [macOS notes](https://github.com/superg/redumper#macos)).

## Maintenance

- `.github/workflows/autobump.yml` opens a PR daily when a new upstream release appears (a redumper `bNNN` tag, an agent-discogs PyPI release). It needs a `BUMP_GITHUB_TOKEN` repository secret: a fine-grained token for this repository with Contents and Pull requests read/write (`GITHUB_TOKEN` cannot open PRs that trigger `tests.yml`). `publish.yml` also merges with it, because only the repository admin can bypass the `main` ruleset.
- `.github/workflows/tests.yml` reports the `tests` check on every PR, which the `main` ruleset requires. It runs `brew test-bot` only when a PR touches `Formula/` or `.github/workflows/`; other PRs merge normally once `tests` passes. Publish formula PRs instead of clicking Merge: once `test-bot (macos-26)` passes, run `gh workflow run publish.yml -f pull_request=<N> -f head_sha=<sha>`. `brew pr-pull` uploads the bottles to a GitHub release, commits the `bottle do` block to the PR branch, and the workflow squash-merges the PR. Until then, the `bottles` job fails `tests` on any PR whose formula's `bottle do` block does not point at its `<formula>-<version>[_<revision>]` release, so a version or revision bump cannot be merged by mistake. Formula edits that keep the version and revision pass `bottles`.
- If a formula PR was merged without publishing, its bottle URL returns 404. Open a PR that removes the stale `bottle do` block, so test-bot builds bottles for the current version, and publish that PR.
- Local check, per formula: `brew install --build-from-source jmfontaine/tap/<formula> && brew test <formula> && brew audit --strict --online jmfontaine/tap/<formula>`.
