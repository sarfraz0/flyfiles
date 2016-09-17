module Handler.Repository where

import Import
import Control.Lens ((^.))

postRepositoryR :: Handler Value
postRepositoryR = do
    repo <- requireJsonBody :: Handler Repository
    isRepository <- runDB $ getBy . UniquePath $ repo ^. repositoryPath
    _ <- case isRepository of
        Nothing -> runDB $ insert repo
        Just _ -> sendResponseStatus status401 (toError alreadyExistKey)
    sendResponseStatus status201 toSuccess
