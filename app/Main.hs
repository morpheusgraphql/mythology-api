module Main
    ( main
    )
where

import           Handler                        ( graphql )
import           AWSLambda.Events.APIGateway    ( apiGatewayMain )

main = apiGatewayMain graphql
