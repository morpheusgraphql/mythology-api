module Mythology.API
  ( mythologyApi
  ) where

import           Data.ByteString.Lazy       (ByteString)
import qualified Data.ByteString.Lazy.Char8 as C
import           Data.Morpheus              (interpreter)
import           Data.Morpheus.Types        (GQLRootResolver (..))
import           Data.Text                  (Text, pack, unpack)
import           Mythology.Schema           (Query, resolveQuery)

rootResolver :: GQLRootResolver IO Query () ()
rootResolver =
  GQLRootResolver {queryResolver = return resolveQuery, mutationResolver = return (), subscriptionResolver = return ()}

mythologyApiByteString :: ByteString -> IO ByteString
mythologyApiByteString = interpreter rootResolver

mythologyApi :: Text -> IO Text
mythologyApi text = (pack . C.unpack) <$> mythologyApiByteString ((C.pack . unpack) text)
