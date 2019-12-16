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

import           Data.Morpheus.Document         ( importGQLDocumentWithNamespace
                                                )
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

importGQLDocumentWithNamespace "src/Mythology/schema.gql"


transform :: DB.Deity -> Deity (IORes ())
transform dbDeity = Deity { deityName    = constRes (DB.name dbDeity)
                          , deityPower   = constRes (DB.power dbDeity)
                          , deityRole    = constRes (DB.role dbDeity)
                          , deityGoverns = constRes (DB.governs dbDeity)
                          }

resolveQuery :: Query (IORes ())
resolveQuery = Query { queryDeity, queryDeities }
 where
  queryDeity :: QueryDeityArgs -> ResolveQ () IO Deity
  queryDeity QueryDeityArgs { queryDeityArgsName } =
    transform <$> liftEither (lookupDBEntry queryDeityArgsName)
  ----------------------------------
  queryDeities :: () -> IORes () [Deity (IORes ())]
  queryDeities _ = map transform <$> liftEither allDBEntry
