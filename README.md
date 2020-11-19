# Danger Systems GitHub Action

Run [danger]([https://](https://danger.systems/)) as a GitHub Action.

## Configuration

1. Create [a workflow](https://docs.github.com/en/free-pro-team@latest/actions/quickstart#creating-your-first-workflow)
   in your repository somewhere like `.github/workflows/danger.yml` with the following:

```yml
name: Danger Systems
on:
  pull_request:
    types: [assigned, unassigned, labeled, unlabeled, opened, edited, reopened, synchronize]

jobs:
  danger:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Danger
        uses: cultureamp/danger-systems-github-action@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          language: js
          language-version: 14
```

2. Create your preferred flavour of danger in a `.danger` directory at the root
   of your repository. There’s currently support for either
   JavaScript/TypeScript or Ruby versions of danger.

3. Push your changes to GitHub and open a new pull request.

### Language

The plugin supports different implementations of danger by specifying a
`language` option. The available options are:

- `js` — JavaScript (and TypeScript)
- `ruby` — Ruby

Each implementation can specify a `language_version` option to ensure the
danger process runs in the environment you’re expecting. The version is fed
directly to the docker build process, so it should work for any of the following
images available on Docker Hub:

- `js` will run in any [node docker image](https://hub.docker.com/_/node/)
  matching `node:#{language_version}-alpine`
- `ruby` will run in any [node docker image](https://hub.docker.com/_/ruby/)
  matching `ruby:#{language_version}-slim-buster`

If for some reason you desire, you can run both the JavaScript and Ruby versions
side-by-side. You’ll just need to set up multiple actions in your workflow.

## Usage

You’ll need to create `.danger` directory at the root of your repository with
either a JavaScript or Ruby implementation. You can see example implementations
of both languages within the [./danger](./danger) directory in this repository.

Note: The reason for using a separate `.danger` directory is to keep the running
of danger separate from the complications of project dependencies (it’s no fun
trying get a generic runner to install Postgres-related gems when you’re not
going to use them).

### JavaScript and TypeScript

If you’ve chosen `js` as the configured language, the plugin will:

* Install any npm dependencies specified within the `.danger` directory using
  `yarn`.
* Copy your app source into its runtime.
* Look for either a `dangerfile.ts` or `dangerfile.js` in the `.danger`
  directory and run it.

Here’s a simple example from the danger documentation:

```ts
import { message, danger } from "danger"

const modifiedMD = danger.git.modified_files.join("- ")
message("Changed Files in this PR: \n - " + modifiedMD)
```

You can read more in the [danger JavaScript
documentation](https://danger.systems/ruby/).

### Ruby

If you’ve chosen `ruby` as the configured language, the plugin will:

* Install any dependencies specified by a `Gemfile` within the `.danger`
  directory using bundler.
* Copy your app source into its runtime.
* Look for the `Dangerfile` in the `.danger` directory and run it

Here’s a simple example from the danger documentation:

```ruby
message("Hello, I am message from danger.")
```

You can read more in the [danger ruby
documentation](https://danger.systems/ruby/).

### Testing locally

It can be a bit of a slow feedback loop pushing to GitHub to test your
`Dangerfile` is working as you’d like. You can get around this by running danger
locally, though as danger _requires_ a PR as a context to run at all, you need
to do two things:

* Supply a valid GitHub pull request URL.
* Have a valid `DANGER_GITHUB_API_TOKEN` available in your local environment.
  Where valid means a token for a user with permission to the GitHub repository
  in question. You can [create personal GitHub API tokens on your account
  settings page](https://github.com/settings/tokens).

Here’s an example of how you might run danger locally through yarn:

```bash
cd .danger
DANGER_GITHUB_API_TOKEN=your_token \
  yarn run danger pr https://github.com/org/report/pull/123
```

Note that this assumes you’ve installed danger locally as per the instructions
above.

### Secrets

There is intentionally no mechanism for passing custom secrets into this action
to ensure that secrets can’t be exposed through GitHub Actions. The main effect
of this is that any dependencies installed through your danger configuration
(either through `bundler` or `yarn`) _must_ be publicly available.

## Common issues

* Danger *requires* a pull request as a context for it to run, and so it will
  only execute correctly for `pull_request` events on GitHub. If you configure
  your danger workflow to run on other events (`push` for example) it will fail.
