{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module Mythology.Schema.Query
  ( resolveQuery
  , Query
  )
where

import           Data.Morpheus.Kind             ( KIND
                                                , OBJECT
                                                )
import           Data.Morpheus.Types            ( GQLType(..)
                                                , ResM
                                                , gqlResolver
                                                )
import           Data.Text                      ( Text )
import           GHC.Generics                   ( Generic )
import           Files.Files                    ( allDBEntry
                                                , lookupDBEntry
                                                )
import           Data.Aeson                     ( FromJSON )

data Query = Query
  { deity :: DeityArgs -> ResM Deity,
    deities :: ()     -> ResM [Deity]
  } deriving (Generic)

data Deity = Deity
  { fullName :: Text -- Non-Nullable Field
  , power    :: Maybe Text -- Nullable Field
  , role     :: Text
  , governs  :: Maybe Text
  } deriving (Generic, GQLType, FromJSON)

type instance KIND Deity = OBJECT


data DeityArgs = DeityArgs
  { name      :: Text -- Required Argument
  , mythology :: Maybe Text -- Optional Argument
  } deriving (Generic)

resolveDeity :: DeityArgs -> ResM Deity
resolveDeity args = gqlResolver $ lookupDBEntry (name args)

resolveDeities :: () -> ResM [Deity]
resolveDeities _ = gqlResolver $ allDBEntry

resolveQuery :: Query
resolveQuery = Query { deity = resolveDeity, deities = resolveDeities }
