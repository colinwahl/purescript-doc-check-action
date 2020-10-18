module Main where

import Prelude

import Control.Monad.Error.Class (catchError)
import Control.Monad.Except.Trans (runExceptT)
import Control.Monad.Trans.Class (lift)
import Data.Array as Array
import Data.Either (Either(..))
import Data.String.Regex (Regex)
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Traversable (traverse)
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
import Node.Path (FilePath)

main :: Effect Unit
main = do
  readme <- Sync.readTextFile UTF8 "./README.md"
  docs <- catchError (Sync.readdir "docs") mempty

  let
    docMarkdown = Array.filter (Regex.test markdownRegex) docs

  docsFiles <- traverse (Sync.readTextFile UTF8) docs

  let
    allMarkdown = [ readme ] <> docsFiles

    pursCodeBlocks = allMarkdown >>= getCodeBlocks

    completed = join >>> case _ of
      Left err -> Core.setFailed (Error.message err)
      Right returnCode
        | returnCode == 0.0 -> Core.info "Docs compiled."
        | otherwise -> Core.setFailed "Error in doc compilation."

  runAff_ completed $ runExceptT do
    IO.mkdirP { fsPath: "doc-test" }
    testPaths <- lift $ liftEffect $ forWithIndex pursCodeBlocks \ix code -> do
      let
        path = "doc-test/test" <> show ix <> ".purs"
      Sync.writeTextFile UTF8 path (moduleTemplate ix code)
      pure path
    Exec.exec' (compileCommand testPaths)

moduleTemplate :: Int -> String -> String
moduleTemplate ix code =
  Array.intercalate "\n"
    [ "module Test" <> show ix <> " where"
    , ""
    , "import Prelude"
    , ""
    , code
    ]

markdownRegex :: Regex
markdownRegex = unsafeRegex "\\.md$" noFlags

compileCommand :: Array FilePath -> String
compileCommand testPaths = "spago build --path 'doc-test/*.purs'"
