{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module FlyFiles.Helpers where

import ClassyPrelude
import Data.Aeson
import System.FilePath.Posix
import System.Directory
import FlyFiles.GlobalKeys

toSuccess :: Text
toSuccess = toStrict . decodeUtf8 . encode $ object [statusKey .= successKey]

toError :: Text -> Text
toError errMsg = toStrict . decodeUtf8 . encode $ object [
  statusKey .= errorKey,
  messageKey .= errMsg ]

-- | This function lists the the contents of a directory with only absolutes
getDirIfAbsoluteContents :: FilePath -> IO [FilePath]
getDirIfAbsoluteContents path =
  doesDirectoryExist path >>= \dirExist ->
    if dirExist && isAbsolute path
      then trimDirList (path </>) path
      else getCurrentDirectory >>= \d -> trimDirList (d </>) path
  where
    trimDirList :: (FilePath -> FilePath) -> FilePath -> IO [FilePath]
    trimDirList trimFunc pth = fmap trimFunc . filter (`onotElem` [".", ".."])
                               <$> getDirectoryContents pth

-- | Same as above but only keeps the files
getFilesDirIfAbsoluteContents :: FilePath -> IO [FilePath]
getFilesDirIfAbsoluteContents path =
  getDirIfAbsoluteContents path >>= keepOnlyExistingFiles
  where
    keepOnlyExistingFiles :: [FilePath] -> IO [FilePath]
    keepOnlyExistingFiles [] = return []
    keepOnlyExistingFiles (x:xs) =
      doesFileExist x >>= \e ->
        if e
          then keepOnlyExistingFiles xs >>= \o -> return (x:o)
          else keepOnlyExistingFiles xs
