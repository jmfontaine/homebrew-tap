# jmfontaine/tap

Personal Homebrew tap.

## Install

```sh
brew install jmfontaine/tap/<formula>
```

Or `brew tap jmfontaine/tap` and then `brew install <formula>`.

Or, in a `Brewfile`:

```ruby
tap "jmfontaine/tap"
brew "<formula>"
```

## Maintenance

- `.github/workflows/autobump.yml` opens a PR daily when a new upstream release appears.
- `.github/workflows/tests.yml` runs `brew test-bot` on PRs; `publish.yml` publishes bottles via `brew pr-pull`.
