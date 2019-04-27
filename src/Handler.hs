{-# LANGUAGE OverloadedStrings #-}

module Handler
    ( handler
    )
where

import           AWSLambda.Events.APIGateway    ( APIGatewayProxyRequest
                                                , APIGatewayProxyResponse
                                                , responseOK
                                                , responseBodyEmbedded
                                                , requestBodyEmbedded
                                                , requestBodyBinary
                                                , responseBodyBinary
                                                , responseBody
                                                , requestBody
                                                )
import           Data.Aeson.Embedded            ( Embedded )
import           Control.Lens                   ( (^.)
                                                , (&)
                                                , (?~)
                                                )
import           Mythology.API                  ( mythologyApi )
import           Data.Maybe                     ( fromMaybe )



toResponce obj = responseOK & responseBody ?~ obj
toQuery request = fromMaybe "" (request ^. requestBody)
handler inputString = toResponce <$> (mythologyApi $ toQuery inputString)
