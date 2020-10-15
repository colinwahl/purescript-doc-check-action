module Main where

import Prelude

import Data.Traversable (fold)
import Effect (Effect)
import GitHub.Actions.Core as Core
import Marked (getCodeBlocks)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as Sync

main :: Effect Unit
main = do
  readme <- Sync.readTextFile UTF8 "./README.md"
  let
    readmeCodeBlocks = getCodeBlocks readme
  Core.info (fold readmeCodeBlocks)
