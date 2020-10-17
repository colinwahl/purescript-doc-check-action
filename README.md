# PureScript Doc Check

This action checks that the docs in your PureScript repository compile.

The action will find the markdown files in your repository (files with the `.md` extension) and pull out all code fences with the language "purescript" or "purs". It will then make a module for each code block in a directory called `doc-test`. Lastly it runs `spago build` to install dependencies and compile the code in your documentation. If the docs don't compile, then the build fails!

# Usage

Make sure to add "doc-test/*.purs" to the `sources` entry in your `spago.dhall` in order to run the compiler on the generated modules.
- This won't change your normal compilation workflows as these files will not exist locally.

## Example usage (in your github workflow yaml file)

```yaml
jobs:
  ...
  doc-check-job:
    runs-on: ubuntu-latest
    name: Job to check PureScript Docs
    steps:
      - name: Set up PureScript toolchain
        uses: purescript-contrib/setup-purescript@main
      - name: Check PureScript Docs
        uses: purescript-doc-check@main
```
