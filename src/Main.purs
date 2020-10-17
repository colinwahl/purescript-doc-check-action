module Main where

import Prelude

import Control.Monad.Except.Trans (runExceptT)
import Control.Monad.Trans.Class (lift)
import Data.Array as Array
import Data.Either (Either(..))
import Data.TraversableWithIndex (forWithIndex)
import Effect (Effect)
import Effect.Aff (runAff_)
import Effect.Class (liftEffect)
import Effect.Exception as Error
import GitHub.Actions.Core as Core
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

    completed = join >>> case _ of
      Left err -> Core.setFailed (Error.message err)
      Right returnCode
        | returnCode == 0.0 -> Core.info "Docs compiled."
        | otherwise -> Core.setFailed "Error in doc compilation."

  runAff_ completed $ runExceptT do
    IO.mkdirP { fsPath: "doc-test" }
    _ <- lift $ liftEffect $ forWithIndex readmeCodeBlocks \ix code -> do
      let
        path = "doc-test/test" <> show ix <> ".purs"
      Sync.writeTextFile UTF8 path (moduleTemplate ix code)
    Exec.exec' "spago build"

moduleTemplate :: Int -> String -> String
moduleTemplate ix code =
  Array.intercalate "\n"
    [ "module Test" <> show ix <> " where"
    , ""
    , "import Prelude"
    , ""
    , code
    ]
