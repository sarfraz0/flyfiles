module Handler.Rule where

import Import
import Control.Lens ((^.))

postRuleR :: Handler Value
postRuleR = do
    rule <- requireJsonBody :: Handler Rule
    isRule <- runDB . getBy $ UniqueRule (rule ^. ruleRegex) (rule ^. ruleRepo)
    _ <- case isRule of
        Nothing -> runDB $ insert rule
        Just _ -> sendResponseStatus status401 (toError alreadyExistKey)
    sendResponseStatus status201 toSuccess
