{-# LANGUAGE OverloadedStrings #-}

module Handler
    ( handler
    )
where

import           AWSLambda.Events.APIGateway    ( APIGatewayProxyRequest
                                                , responseOK
                                                , responseBody
                                                , requestBody
                                                , APIGatewayProxyResponse(..)
                                                , agprqHttpMethod
                                                )
import           Control.Lens                   ( (^.)
                                                , (&)
                                                , (?~)
                                                )
import           Mythology.API                  ( mythologyApi )
import           Data.Maybe                     ( fromMaybe )
import           Data.Text
import qualified Data.Text                     as T
                                                ( concat )
import           Data.Aeson.TextValue
import qualified Data.Text.IO                  as TIO
                                                ( readFile )

toResponce :: Text -> APIGatewayProxyResponse Text
toResponce obj = responseOK & responseBody ?~ obj

toQuery :: APIGatewayProxyRequest Text -> Text
toQuery request = fromMaybe "" (request ^. requestBody)

graphql :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
graphql inputString = toResponce <$> (mythologyApi $ toQuery inputString)


toHTML :: Text -> (APIGatewayProxyResponse Text)
toHTML body = APIGatewayProxyResponse
    { _agprsStatusCode = 200
    , _agprsHeaders    = mempty <> [("content-type", "text/html")]
    , _agprsBody       = (pure (TextValue body))
    }

htmlClient :: IO (APIGatewayProxyResponse Text)
htmlClient = toHTML <$> (TIO.readFile "assets/index.html")

handler :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
handler request = case method of
    "GET"  -> htmlClient
    "POST" -> graphql request
    _      -> toHTML <$> return "Not allowed Method"
    where method = request ^. agprqHttpMethod

