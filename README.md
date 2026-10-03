# jmfontaine/tap

Personal Homebrew tap.

## Formulae

| Formula | Description |
| --- | --- |
| [`redumper`](Formula/redumper.rb) | [redumper](https://github.com/superg/redumper), low-level optical disc dumper (macOS only) |

## Install

```sh
brew install jmfontaine/tap/redumper
```

Or `brew tap jmfontaine/tap` and then `brew install redumper`.

Or, in a `Brewfile`:

```ruby
tap "jmfontaine/tap"
brew "redumper"
```

## Redumper Notes

- Built from source with LLVM 18 (`llvm@18`, build-only), matching upstream's toolchain. The binary links against the system libc++.
- Upstream tags builds as `bNNN`; the formula version is `NNN` (e.g. `b753` → `753`). `redumper --version` reports the upstream build plus any local patch suffix (e.g. `build: b753+d8fix`).
- Carries a patch for PLEXTOR lead-in reads through USB-ATAPI bridges that pad D8 transfers (JMicron `0x152D:0x2338`), a regression from upstream [#447](https://github.com/superg/redumper/pull/447) in `b751`. The `+d8fix` build suffix marks patched binaries, so it also shows up in dump logs and MPF's Redump submission info. The patch and suffix are removed together once upstream ships a fix.
- If redumper fails with `failed to create service plugin interface ... resource shortage`, macOS privacy controls blocked IOKit access; run it from a directory outside Desktop, Documents and Downloads (see upstream's [macOS notes](https://github.com/superg/redumper#macos)).

## Maintenance

- `.github/workflows/autobump.yml` opens a PR daily when a new upstream `bNNN` release appears. It needs a `BUMP_GITHUB_TOKEN` repository secret: a fine-grained token for this repository with Contents and Pull requests read/write (`GITHUB_TOKEN` cannot open PRs that trigger `tests.yml`).
- `.github/workflows/tests.yml` runs `brew test-bot` on PRs; `publish.yml` publishes bottles via `brew pr-pull`.
- Local check: `brew install --build-from-source jmfontaine/tap/redumper && brew test redumper && brew audit --strict --online jmfontaine/tap/redumper`.
