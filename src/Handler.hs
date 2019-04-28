{-# LANGUAGE OverloadedStrings #-}

module Handler
    ( graphql
    , client
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

--method :: APIGatewayProxyRequest Text -> ByteString


client :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
client request = case method of
    "GET" ->
        toHTML
            <$> (return $ T.concat
                    [ "<!DOCTYPE html>"
                    , "<html lang=\"en\">"
                    , "<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/></head>"
                    , "<body> <div id=\"app\"></div></body>"
                    , "<script crossorigin src=\"/client.js\"></script>"
                    , "</html>"
                    ]
                )
    "POST" -> toResponce <$> (mythologyApi $ toQuery request)
    _      -> toHTML <$> return "Not allowed Method"
    where method = request ^. agprqHttpMethod

