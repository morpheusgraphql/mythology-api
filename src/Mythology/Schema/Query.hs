{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TypeOperators         #-}

module Mythology.Schema.Query
  ( resolveQuery
  )
where


import           Data.Morpheus.Kind             ( GQLArgs
                                                , GQLKind(..)
                                                , GQLObject
                                                , GQLQuery
                                                )
import           Data.Morpheus.Wrapper          ( (::->)(..) )
import           Data.Text                      ( Text )
import           Data.Typeable                  ( Typeable )
import           GHC.Generics                   ( Generic )

data Query = Query
  { deity :: DeityArgs ::-> Deity
  } deriving (Generic, GQLQuery)

data Deity = Deity
  { fullName :: Text -- Non-Nullable Field
  , power    :: Maybe Text -- Nullable Field
  , role     :: Text
  , governs  :: Maybe Text
  } deriving (Generic, GQLObject, Typeable)

instance GQLKind Deity where
  description _ = "A supernatural being considered divine and sacred"

data DeityArgs = DeityArgs
  { name      :: Text -- Required Argument
  , mythology :: Maybe Text -- Optional Argument
  } deriving (Generic, GQLArgs)


resolveDeity :: DeityArgs ::-> Deity
resolveDeity = Resolver $ \args -> dbDeity (name args) (mythology args)

dbDeity :: Text -> Maybe Text -> IO (Either String Deity)
dbDeity _ _ = return $ Right $ Deity
  { fullName = "Morpheus"
  , power    = Just "Shapeshifting"
  , role     = "god of Dreams"
  , governs  = Just "Dreams"
  }

resolveQuery :: Query
resolveQuery = Query { deity = resolveDeity }
