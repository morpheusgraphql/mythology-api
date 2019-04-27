{-# LANGUAGE OverloadedStrings #-}

module Handler
    ( handler
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

toResponce :: Text -> APIGatewayProxyResponse Text
toResponce obj = responseOK & responseBody ?~ obj

toQuery :: APIGatewayProxyRequest Text -> Text
toQuery request = fromMaybe "" (request ^. requestBody)

handler :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
handler inputString = toResponce <$> (mythologyApi $ toQuery inputString)
