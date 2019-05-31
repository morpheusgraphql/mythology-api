{-# LANGUAGE DeriveGeneric , DeriveAnyClass , DeriveDataTypeable, TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses , OverloadedStrings  #-}

module Mythology.API
    ( mythologyApi
    )
where

import           Data.Text                      ( Text
                                                , pack
                                                , unpack
                                                )
import           Data.ByteString.Lazy           ( ByteString )
import           Data.Morpheus                  ( interpreter )
import           Data.Morpheus.Types            ( GQLRoot(..) )
import qualified Data.ByteString.Lazy.Char8    as C
import           Mythology.Schema.Query         ( resolveQuery )


mythologyApiByteString :: ByteString -> IO ByteString
mythologyApiByteString =
    interpreter GQLRoot { query = resolveQuery, mutation = (), subscription = () }

mythologyApi :: Text -> IO Text
mythologyApi text =
    (pack . C.unpack) <$> mythologyApiByteString ((C.pack . unpack) text)
