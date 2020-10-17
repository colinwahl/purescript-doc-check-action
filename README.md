# Hello world PureScript action

```purescript
x :: Int
x = "hello"
```

This action prints "Hello" + the name of a person to greet to the log. This is a [PureScript](https://github.com/purescript/purescript) port of "[Creating a JavaScript action](https://help.github.com/en/articles/creating-a-javascript-action)" in the GitHub Help documentation.  

# Usage

This repository serves as a template for creating more advanced Actions in [PureScript](https://github.com/purescript/purescript).  

To create your own [Action](https://github.com/features/actions) via PureScript, expand this template by defining your Action in PureScript in the `src` directory. Once that is defined, you can update `action.yml` to specify usage. Then you just need to run `npm run-script build` to bundle your PureScript Action into the `dist/index.js` file before publishing!

See [GitHub's docs on Actions](https://docs.github.com/en/actions) for in-depth information on Actions.
See [purescript-github-actions-toolkit](https://github.com/colinwahl/purescript-github-actions-toolkit) for documentation on the PureScript bindings to Github's Actions Toolkit.

## Inputs

### `who-to-greet`

**Required** The name of the person to greet. Default `"PureScript User"`.

## Outputs

### `what-is-purescript`

A description of the PureScript language.

## Example usage

```yaml
uses: hello-world-purescript-action@main
with:
  who-to-greet: 'PureScript User'
```
