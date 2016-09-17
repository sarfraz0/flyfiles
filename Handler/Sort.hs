{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Handler.Sort where

import Import
import Control.Lens ((^.))

getRules :: FilePath -> Key Repository -> Handler [FilePath]
getRules repoPath repoId = do
  rules :: [Entity Rule] <- runDB $ selectList [RuleRepo ==. repoId] []
  filepaths <- liftIO $ getFilesDirIfAbsoluteContents repoPath
  liftIO $ processRules (fmap convertRule rules) filepaths
    where
    convertRule :: Entity Rule -> (FilePath, Text)
    convertRule x = let val = entityVal x in (val ^. ruleDestination, val ^. ruleRegex)

getSortR :: Handler Value
getSortR = do
  repositories :: [Entity Repository] <- runDB $ selectList [] []
  _ <- mapM (\x -> getRules (entityVal x ^. repositoryPath) (entityKey x)) repositories
  sendResponseStatus status201 toSuccess
