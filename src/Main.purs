module Main where

import Prelude

import Control.Monad.Except.Trans (runExceptT)
import Control.Monad.Trans.Class (lift)
import Data.Array as Array
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
    IO.rmRF { inputPath: "output" }
    IO.mkdirP { fsPath: "doc-test" }
    res <- lift $ liftEffect $ forWithIndex readmeCodeBlocks \ix code -> do
      let
        path = "doc-test/test" <> show ix <> ".purs"
      Sync.writeTextFile UTF8 path (moduleTemplate ix code)
    let
      compile = \_ -> do
        _ <- Exec.exec' "ls"
        _ <- Exec.exec' "ls doc-test"
        _ <- Exec.exec' "cat doc-test/test0.purs"
        Exec.exec' "spago build --path 'doc-test/test0.purs'"
    compile res

moduleTemplate :: Int -> String -> String
moduleTemplate ix code =
  Array.intercalate "\n"
    [ "module Test" <> show ix <> " where"
    , ""
    , "import Prelude"
    , ""
    , code
    ]
