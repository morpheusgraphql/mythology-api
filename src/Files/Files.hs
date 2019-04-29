module Files.Files
    ( getJson
    )
where

import           Data.Aeson                     ( eitherDecode
                                                , FromJSON
                                                )
import           Data.ByteString.Lazy           ( readFile )
import           Prelude                 hiding ( readFile )

dbFolder :: String
dbFolder = "db/"

jsonPath :: String -> String
jsonPath name = (dbFolder ++ name ++ ".json")

getJson :: FromJSON a => FilePath -> IO (Either String a)
getJson path = eitherDecode <$> readFile (jsonPath path)


