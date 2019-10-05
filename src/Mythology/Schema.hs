{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Mythology.Schema
  ( resolveQuery
  , Query
  ) where

import           Data.Morpheus.Document (importGQLDocument)
import           Data.Morpheus.Types    (IORes, constRes, resolver)
import           Data.Text              (Text)
import           Files.Files            (allDBEntry, lookupDBEntry)

importGQLDocument "src/Mythology/schema.gql"

resolveQuery :: IORes (Query IORes)
resolveQuery = pure $ Query {deity, deities}
  where
    deity :: DeityArgs -> IORes (Deity IORes)
    deity DeityArgs {name} = do
      fullName <- resolver $ lookupDBEntry name
      pure
        Deity
          {fullName = constRes fullName, power = constRes (Just ""), role = constRes "", governs = constRes (Just "")}
    ----------------------------------
    deities :: () -> IORes [Deity IORes]
    deities _ = do
      (x :: [Int]) <- resolver allDBEntry
      pure []
