module Main where

import Prelude

import Control.Monad.Except (runExceptT)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (message)
import GitHub.Actions.Core as Core

main :: Effect Unit
main = do
  result <- runExceptT do
    name <- Core.getInput { name: "who-to-greet", options: Just { required: true } }
    liftEffect $ Core.info $ "Hello, " <> name <> "!"
  case result of
    Right _ -> do
      Core.setOutput { name: "what-is-purescript", value: "A small strongly typed programming language with expressive types that compiles to JavaScript, written in and inspired by Haskell." }
    Left err -> do
      Core.setFailed $ message err
