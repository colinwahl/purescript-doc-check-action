let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200831/packages.dhall sha256:cdb3529cac2cd8dd780f07c80fd907d5faceae7decfcaa11a12037df68812c83

in  upstream
  with purescript-github-actions-toolkit =
    { dependencies =
      [ "aff"
      , "aff-promise"
      , "effect"
      , "foreign-object"
      , "node-buffer"
      , "node-path"
      , "node-streams"
      , "nullable"
      , "transformers"
      ]
    , repo = "https://github.com/colinwahl/purescript-github-actions-toolkit.git"
    , version = "main"
    }