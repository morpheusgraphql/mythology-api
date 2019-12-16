{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
module Files.Files
    ( getJson
    , allDBEntry
    , lookupDBEntry
    , Deity(..)
    )
where

import           Data.Aeson                     ( eitherDecode
                                                , FromJSON
                                                )
import           Data.ByteString.Lazy           ( readFile )
import           Prelude                 hiding ( readFile )
import           Data.Map                       ( Map )
import           Data.Text                      ( Text
                                                , unpack
                                                )
import qualified Data.Map                      as M
                                                ( lookup
                                                , elems
                                                )
import           GHC.Generics                   ( Generic )


dbFolder :: String
dbFolder = "db/"

jsonPath :: String -> String
jsonPath name = dbFolder ++ name ++ ".json"

getJson :: FromJSON a => FilePath -> IO (Either String a)
getJson path = eitherDecode <$> readFile (jsonPath path)


openDB :: FromJSON a => IO (Either String (Map Text a))
openDB = getJson "greekMythology"

allDBEntry :: FromJSON a => IO (Either String [a])
allDBEntry = openDB >>= \x -> pure $ M.elems <$> x

lookupNote :: Text -> Map Text a -> Either String a
lookupNote key' lib' = case M.lookup key' lib' of
    Nothing ->
        Left ("DB Error: could not find entry for ID \"" ++ unpack key' ++ "\"")
    Just x -> Right x

lookupDBEntry :: FromJSON a => Text -> IO (Either String a)
lookupDBEntry key' = do
    lib' <- openDB
    return (lib' >>= lookupNote key')

data Deity = Deity {
    name :: Text,
    mythology :: Text,
    power:: Maybe Text,
    role:: Text,
    governs:: Maybe Text
} deriving (Generic, FromJSON)
