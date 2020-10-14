module Main where

import Prelude

import Effect (Effect)
import GitHub.Actions.Core as Core
import Node.Encoding (Encoding(..))
import Node.FS.Sync as Sync

main :: Effect Unit
main = do
  readme <- Sync.readTextFile UTF8 "./README.md"
  Core.info readme
