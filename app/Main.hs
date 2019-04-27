module Main
    ( main
    )
where

import           Handler                        ( handler )
import           AWSLambda.Events.APIGateway    ( apiGatewayMain )

main = apiGatewayMain handler
