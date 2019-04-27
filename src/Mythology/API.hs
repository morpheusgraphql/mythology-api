{-# LANGUAGE DeriveGeneric , DeriveAnyClass , DeriveDataTypeable, TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses , OverloadedStrings  #-}

module Mythology.API
    (mythologyApi)
where

import           Data.Text                      ( Text
                                                , concat
                                                , pack
                                                , unpack
                                                )
import           Data.ByteString.Lazy           ( ByteString )
import           Data.Morpheus                  ( interpreter )
import           Data.Morpheus.Kind             ( GQLQuery
                                                , GQLArgs
                                                , GQLObject
                                                , GQLKind
                                                )
import           Data.Morpheus.Wrapper          (GQLRoot(..))
import qualified Data.ByteString.Lazy.Char8    as C
import           Mythology.Schema.Query         ( resolveQuery )


mythologyApiByteString :: ByteString -> IO ByteString
mythologyApiByteString = interpreter GQLRoot {query = resolveQuery , mutation = ()}
    
mythologyApi :: Text -> IO Text
mythologyApi text = (pack . C.unpack) <$> mythologyApiByteString ((C.pack . unpack) text)
