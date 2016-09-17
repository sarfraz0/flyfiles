{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module FlyFiles.Releases where

import ClassyPrelude
import System.Directory
import System.FilePath.Posix
import Text.Regex.PCRE
import qualified Data.Text as T

-- | This function moves the file to the destination folder if the regex matches
processPath :: FilePath -- ^ The destination directory
            -> Text     -- ^ The validation regex
            -> FilePath -- ^ The absolute path of the file to process
            -> IO Bool  -- ^ True if the regex has matched
processPath dest reg fic = do
  fileExist <- doesFileExist fic
  if fileExist && fileIsOk
    then do
    print $ "--> MOVING " ++ fic ++ " TO " ++ (dest </> filename)
    renameFile fic $ dest </> filename
    return True
    else
    return False
  where
    filename = takeFileName fic
    fileIsOk = (toLower filename =~ T.unpack (T.toLower reg)) :: Bool

-- | This function moves the files to the destination folder if the regex matches
processPaths :: FilePath      -- ^ The destination directory
             -> Text          -- ^ The validation regex
             -> [FilePath]    -- ^ The absolute paths of the files to process
             -> IO [FilePath] -- ^ The list of not processed paths
processPaths _ _ [] = return []
processPaths dest reg ys@(x:xs) = do
  destExist <- doesDirectoryExist dest
  if destExist
    then do
    isFirstPath <- processPath dest reg x
    if isFirstPath
      then
      processPaths dest reg xs
      else do
      paths <- processPaths dest reg xs
      return (x:paths)
    else
    return ys

-- | This function moves the files to the destination folder if any of the regexes match
processRules :: [(FilePath, Text)] -- ^ The destinations directory and the matching regexes
             -> [FilePath]         -- ^ The absolute paths of the files to process
             -> IO [FilePath]      -- ^ The list of not processed paths
processRules [] xs = return xs
processRules (x:xs) paths = do
  resultingPaths <- uncurry processPaths x paths
  processRules xs resultingPaths

