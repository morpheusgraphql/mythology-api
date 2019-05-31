{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module Mythology.Schema.Query
  ( resolveQuery
  )
where

import           Data.Morpheus.Kind             ( GQLArgs
                                                , GQLType(..)
                                                , GQLQuery
                                                , KIND
                                                , OBJECT
                                                )
import           Data.Morpheus.Types            ( (::->)
                                                , Resolver(..) )
import           Data.Text                      ( Text )
import           GHC.Generics                   ( Generic )
import           Files.Files                    ( allDBEntry
                                                , lookupDBEntry
                                                )
import           Data.Aeson                     ( FromJSON )

data Query = Query
  { deity :: DeityArgs ::-> Deity,
    deities :: ()      ::-> [Deity]
  } deriving (Generic, GQLQuery)

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
  } deriving (Generic, GQLArgs)

resolveDeity :: DeityArgs ::-> Deity
resolveDeity = Resolver $ \args -> lookupDBEntry (name args)

resolveDeities :: () ::-> [Deity]
resolveDeities = Resolver $ const allDBEntry

resolveQuery :: Query
resolveQuery = Query { deity = resolveDeity, deities = resolveDeities }
