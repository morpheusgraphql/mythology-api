{-# LANGUAGE OverloadedStrings #-}

module Handler
    ( graphql
    , client
    )
where

import           AWSLambda.Events.APIGateway    ( APIGatewayProxyRequest
                                                , APIGatewayProxyResponse
                                                , responseOK
                                                , responseBody
                                                , requestBody
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

toResponce :: Text -> APIGatewayProxyResponse Text
toResponce obj = responseOK & responseBody ?~ obj

toQuery :: APIGatewayProxyRequest Text -> Text
toQuery request = fromMaybe "" (request ^. requestBody)

graphql :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
graphql inputString = toResponce <$> (mythologyApi $ toQuery inputString)


client :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
client _ =
    toResponce
        <$> (return $ T.concat
                [ "<html lang=\"en\">"
                , "<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/></head>"
                , "<body> <div id=\"app\"></div></body>"
                , "<script crossorigin src=\"/client.js\"></script>"
                , "</html>"
                ]
            )
