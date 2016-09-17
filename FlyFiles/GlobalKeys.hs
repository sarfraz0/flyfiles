{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module FlyFiles.GlobalKeys where

import ClassyPrelude

-- | states

updatedKey :: Text
updatedKey = "updated"

deletedKey :: Text
deletedKey = "deleted"

createdKey :: Text
createdKey = "created"

errorKey :: Text
errorKey = "error"

successKey :: Text
successKey = "success"

messageKey :: Text
messageKey = "message"

statusKey :: Text
statusKey = "status"

-- | errors

alreadyExistKey :: Text
alreadyExistKey = "already exist"

doesNotExistKey :: Text
doesNotExistKey = "does not exist"



