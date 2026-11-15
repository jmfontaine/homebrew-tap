# AGENTS.md

Guidance for coding agents working in this repository.

## Project

`jmfontaine/tap`, a personal Homebrew tap. `Formula/` holds two formulae: `redumper`
(built from source; upstream tags builds as `bNNN`, the formula version is `NNN`) and
`agent-discogs` (the PyPI release in a virtualenv, every Python dependency a `resource`
block). Formulae are built and tested on `macos-26` only (`test-bot`); the other jobs
run on `ubuntu-latest`.

[README.md](README.md) is the manual. Its Maintenance section documents the workflows,
the secrets they need and the local check for a formula; read it before changing a
formula or a workflow.

## Layout

```text
Formula/                          # One .rb file per formula
.github/workflows/autobump.yml    # Daily brew bump: opens a bump-<formula>-<version> PR
.github/workflows/tests.yml       # brew test-bot, the bottles check and the `tests` summary
.github/workflows/publish.yml     # brew pr-pull: bottles, attestation, bottle commit, merge
.github/dependabot.yml            # Pins GitHub Actions by SHA
```

There is no repository-wide build or test command. The local check for a formula, a
source build, `brew test` and `brew audit`, is in the README.

## Gotchas

- Check live state, not the local checkout. Run `git fetch --prune` first: `main` here
  can lag `origin/main`, and the remote deletes a bump branch when its PR merges. Before
  concluding a bump branch or PR exists, run `git ls-remote origin 'bump-*'` and
  `gh pr list --state all --head <branch>`.
- A failed push of `bump-<formula>-<version>` in the autobump run (non-fast-forward)
  means a stale remote bump branch from an earlier attempt exists. Confirm it as above,
  close the stale PR and delete the branch, then rerun the autobump workflow.
- A formula with a `patch` block gets a "may be resolved upstream" warning from
  `brew bump`. When a bump of such a formula fails or warns, check whether upstream
  fixed the problem the patch addresses and remove the patch if it did.
- After publishing, GitHub shows one extra `brew test-bot` run on the PR branch,
  triggered by `github-actions[bot]`, with zero jobs and a failure status. It is
  expected: the bottle commit is pushed with `GITHUB_TOKEN`. Tell it apart from a real
  failure with
  `gh api repos/jmfontaine/homebrew-tap/actions/runs/<id> --jq .triggering_actor.login`
  and `.../jobs --jq .total_count` (`gh run list --json` has no triggering actor field).
- Dependabot's action-pin PRs are not formula PRs: `publish.yml` skips them, and they
  merge like any other PR once `tests` passes.

## Shared Workflow

This repository follows the shared workflow: the `github-workflow` skill describes
issues, branches, pull requests and reviews, and its repository setup describes the
GitHub settings, rulesets, labels and templates. It is a pull-request repository. Its
GitHub settings are managed as code outside this repository; change them there, never
with `gh api` or the GitHub web UI.

### Deviations From the Shared Workflow

- **Formula and bump PRs are published by `publish.yml`, never merged with GitHub's
  Merge button.** The Merge button lands the formula without its bottle commit, so the
  bottle URL returns 404. `publish.yml` runs `brew pr-pull`: it uploads the bottles to a
  GitHub release, attests them, pushes the `bottle do` commit to the PR branch and
  squash-merges the PR, so the PR shows as merged. Autobump PRs (`bump-*` branches)
  publish on their own once their `test-bot (macos-26)` job passes. Publish any other
  formula PR by hand with
  `gh workflow run publish.yml -f pull_request=<N> -f head_sha=<sha>`. Until then the
  `bottles` job fails the `tests` check on a PR whose formula has a new version or
  revision, because its `bottle do` block still names the old release. A formula edit
  that keeps the version and revision passes `bottles`, but is still a formula PR:
  never use the Merge button.
- **`publish.yml` merges with `--admin`.** The bottle commit is pushed with
  `GITHUB_TOKEN`, so it never gets the required `tests` check, and only an admin bypass
  of the ruleset can merge it. Only that workflow uses `--admin`; agents never pass it.
- **An autobump PR opened before `publish.yml` had its `workflow_run` trigger is
  published by rerunning its `brew test-bot` run:** `gh run rerun <id> --failed`. The
  run always fails on the `bottles` job; rerunning that job completes the run again and
  fires the trigger. Find the id with
  `gh run list --workflow 'brew test-bot' --branch <bump-branch>`.
- **The required check is `tests`, not `CI passed`.** `tests` in `tests.yml` summarizes
  `changes`, `test-bot` and `bottles`. Requiring the `test-bot (macos-26)` job itself
  would leave PRs that skip it waiting forever.
- **Autobump PR titles are `brew bump`'s own** (`redumper 773`, `agent-discogs 0.5.0`),
  not Conventional Commits. Titles of PRs you open follow the `github-workflow` skill.
- **Only `main` requires signed commits.** `brew bump` pushes the bump commit and
  `publish.yml` pushes the bottle commit with plain `git push`, and neither can sign
  them. The squash merge that lands them on `main` is signed by GitHub. Commits you make
  are still signed.
