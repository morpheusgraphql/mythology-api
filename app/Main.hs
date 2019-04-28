module Main
    ( main
    )
where

import           Handler                        ( handler )
import           AWSLambda.Events.APIGateway    ( apiGatewayMain )

main :: IO ()
main = apiGatewayMain handler
