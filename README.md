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
- Upstream tags builds as `bNNN`; the formula version is `NNN` (e.g. `b753` → `753`). `redumper --version` still reports `build: b753`.
- If redumper fails with `failed to create service plugin interface ... resource shortage`, macOS privacy controls blocked IOKit access; run it from a directory outside Desktop, Documents and Downloads (see upstream's [macOS notes](https://github.com/superg/redumper#macos)).

## Maintenance

- `.github/workflows/autobump.yml` opens a PR daily when a new upstream `bNNN` release appears.
- `.github/workflows/tests.yml` runs `brew test-bot` on PRs; `publish.yml` publishes bottles via `brew pr-pull`.
- Local check: `brew install --build-from-source jmfontaine/tap/redumper && brew test redumper && brew audit --strict --online jmfontaine/tap/redumper`.
