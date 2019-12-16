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
                                                , agprqPath
                                                )
import           Control.Lens                   ( (^.)
                                                , (&)
                                                , (?~)
                                                )
import           Mythology.API                  ( mythologyApi )
import           Data.Maybe                     ( fromMaybe )
import           Data.Text                      ( Text )
import           Data.Aeson.TextValue
import qualified Data.Text.IO                  as TIO
                                                ( readFile )
import           Data.ByteString                ( ByteString )

toResponce :: Text -> APIGatewayProxyResponse Text
toResponce obj = responseOK & responseBody ?~ obj

toQuery :: APIGatewayProxyRequest Text -> Text
toQuery request = fromMaybe "" (request ^. requestBody)

graphql :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
graphql inputString = toResponce <$> mythologyApi (toQuery inputString)

customType :: ByteString -> Text -> APIGatewayProxyResponse Text
customType value body = APIGatewayProxyResponse
    { _agprsStatusCode = 200
    , _agprsHeaders    = mempty <> [("content-type", value)]
    , _agprsBody       = pure (TextValue body)
    }

htmlClient :: IO (APIGatewayProxyResponse Text)
htmlClient = customType "text/html" <$> TIO.readFile "assets/index.html"

api
    :: ByteString
    -> APIGatewayProxyRequest Text
    -> IO (APIGatewayProxyResponse Text)
api "GET"  _       = htmlClient
api "POST" request = graphql request
api _      _       = customType "text/html" <$> return "Not allowed Method"

route
    :: ByteString
    -> APIGatewayProxyRequest Text
    -> IO (APIGatewayProxyResponse Text)
route "/app.js" _ =
    customType "text/javascript" <$> TIO.readFile "assets/app.js"
route "/" x = api method x where method = x ^. agprqHttpMethod
route _   _ = customType "text/html" <$> return "error path"

handler :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
handler request = route path request where path = request ^. agprqPath

