module Main where

import Prelude

import Control.Monad.Except.Trans (runExceptT)
import Control.Monad.Trans.Class (lift)
import Data.TraversableWithIndex (forWithIndex)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import GitHub.Actions.Exec as Exec
import GitHub.Actions.IO as IO
import Marked (getCodeBlocks)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as Sync

main :: Effect Unit
main = do
  readme <- Sync.readTextFile UTF8 "./README.md"
  let
    readmeCodeBlocks = getCodeBlocks readme
  launchAff_ $ runExceptT do
    IO.mkdirP { fsPath: "doc-test" }
    _ <- forWithIndex readmeCodeBlocks \ix code -> do
      let
        path = "doc-test/test" <> show ix <> ".purs"
      lift $ liftEffect $ Sync.writeTextFile UTF8 path code
    _ <- Exec.exec' "ls"
    Exec.exec' "spago build --path 'doc-test/*.purs'"
