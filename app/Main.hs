module Main
    ( main
    )
where

import           Handler                        ( client )
import           AWSLambda.Events.APIGateway    ( apiGatewayMain )

main = apiGatewayMain client
