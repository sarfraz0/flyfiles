{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module FlyFiles.Regex where

import ClassyPrelude
import qualified Data.Text as T
import System.Directory (getDirectoryContents)

-- | This function removes a list of chars from a string
remChars :: [Text] -- ^ List of chars to remove
         -> Text   -- ^ The string to filter
         -> Text
remChars = flip $ foldl' (\x y -> T.replace y "" x)

speChars :: [Text]
speChars = [".", "{", "}", "<", ">", "(", ")", "[", "]", ",", ";", ":",
             "!", "?", "|", "&", "\\", "/", "-", "_", "\"", "^", "$", "#",
             "*", "+"]

remSpeChars :: Text -> Text
remSpeChars = T.concat . intersperse " " . fmap (remChars speChars) . filter (not . T.isInfixOf "'") . T.split (==' ')

wildcardString :: Text -> Text
wildcardString = wildcardString' [" "]
  where
    wildcardString' = flip $ foldl' (\x y -> T.replace y ".*" x)

buildBasicRegex :: String -> Text
buildBasicRegex = (\x -> "^.*"<>x<>".*$" ) . wildcardString .  remSpeChars . T.strip . T.toLower . T.pack

getDirectoryRegexes :: FilePath -> IO [Text]
getDirectoryRegexes pth = do
  fics <- filter (`onotElem` [".", ".."]) <$> getDirectoryContents pth
  return $ buildBasicRegex <$> fics
