{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module Mythology.Schema.Query
  ( resolveQuery
  , Query
  ) where

import           Data.Aeson             (FromJSON)
import           Data.Morpheus.Document (gqlDocumentWithNamespcace)
import           Data.Morpheus.Kind     (KIND, OBJECT)
import           Data.Morpheus.Types    (GQLType (..), ResM, gqlResolver)
import           Data.Text              (Text)
import           Files.Files            (allDBEntry, lookupDBEntry)
import           GHC.Generics           (Generic)

[gqlDocumentWithNamespace|

type Query
  { deity (name: String!, mythology: String ): Deity,
    deities :: ()     -> ResM [Deity]
  } deriving (Generic)

type Deity
  { fullName : String!
  , power    :  String
  , role     : String!
  , governs  :  String
  }
|]

type instance KIND Deity = OBJECT

resolveDeity :: DeityArgs -> ResM Deity
resolveDeity args = gqlResolver $ lookupDBEntry (name args)

resolveDeities :: () -> ResM [Deity]
resolveDeities _ = gqlResolver allDBEntry

resolveQuery :: Query
resolveQuery = Query {deity = resolveDeity, deities = resolveDeities}
