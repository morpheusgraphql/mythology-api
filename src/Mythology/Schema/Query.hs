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
import           Files.Files                    ( getJson )
import           Data.Map                       ( Map )
import qualified Data.Map                      as M
                                                ( lookup )
import           Data.Aeson                     ( FromJSON )
data Query = Query
  { deity :: DeityArgs ::-> Deity
  } deriving (Generic, GQLQuery)

data Deity = Deity
  { fullName :: Text -- Non-Nullable Field
  , power    :: Maybe Text -- Nullable Field
  , role     :: Text
  , governs  :: Maybe Text
  } deriving (Generic, GQLObject, Typeable,FromJSON)

instance GQLKind Deity where
  description _ = "A supernatural being considered divine and sacred"

data DeityArgs = DeityArgs
  { name      :: Text -- Required Argument
  , mythology :: Maybe Text -- Optional Argument
  } deriving (Generic, GQLArgs)


resolveDeity :: DeityArgs ::-> Deity
resolveDeity = Resolver $ \args -> dbDeity (name args) (mythology args)

lookupNote :: Text -> Map Text a -> Either String a
lookupNote key' lib' = case M.lookup key' lib' of
  Nothing -> Left "Deity Does Not Exists"
  Just x  -> Right x

openDB :: IO (Either String (Map Text Deity))
openDB = getJson "greekMythology"

lookupDB :: Text -> IO (Either String Deity)
lookupDB key' = do
  lib' <- openDB
  return (lib' >>= lookupNote key')


dbDeity :: Text -> Maybe Text -> IO (Either String Deity)
dbDeity key' _ = lookupDB key'
  --return $ Right $ Deity
  --{ fullName = "Morpheus"
  --, power    = Just "Shapeshifting"
  --, role     = "god of Dreams"
  --, governs  = Just "Dreams"
 -- }

resolveQuery :: Query
resolveQuery = Query { deity = resolveDeity }
