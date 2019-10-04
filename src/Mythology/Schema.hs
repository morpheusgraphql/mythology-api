{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Mythology.Schema
  ( resolveQuery
  , Query
  ) where

import           Data.Morpheus.Document (gqlDocument)
import           Data.Morpheus.Types    (IORes, resolver)
import           Data.Text              (Text)
import           Files.Files            (allDBEntry, lookupDBEntry)

[gqlDocument|

type Query
  { deity (name: String!, mythology: String ): Deity
    deities : [Deity!]!
  }

type Deity
  { fullName : String!
  , power    :  String
  , role     : String!
  , governs  :  String
  }
|]

resolveQuery :: IORes (Query IORes)
resolveQuery = pure $ Query {deity, deities}
  where
    deity args = resolver $ lookupDBEntry (name args)
    deities _ = resolver allDBEntry
