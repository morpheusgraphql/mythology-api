{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Mythology.Schema
  ( resolveQuery
  , Query
  )
where

import           Data.Morpheus.Document         ( importGQLDocument )
import           Data.Morpheus.Types            ( IORes
                                                , constRes
                                                , liftEither
                                                , ResolveQ
                                                )
import           Data.Text                      ( Text )
import           Files.Files                    ( allDBEntry
                                                , lookupDBEntry
                                                )
import qualified Files.Files                   as DB
                                                ( Deity(..) )

importGQLDocument "src/Mythology/schema.gql"


transform :: DB.Deity -> Deity (IORes ())
transform dbDeity = Deity { fullName = constRes (DB.name dbDeity)
                          , power    = constRes (DB.power dbDeity)
                          , role     = constRes (DB.role dbDeity)
                          , governs  = constRes (DB.governs dbDeity)
                          }

resolveQuery :: Query (IORes ())
resolveQuery = Query { deity, deities }
 where
  deity :: DeityArgs -> ResolveQ () IO Deity
  deity DeityArgs { name } = transform <$> liftEither (lookupDBEntry name)
  ----------------------------------
  deities :: () -> IORes () [Deity (IORes ())]
  deities _ = map transform <$> liftEither allDBEntry
