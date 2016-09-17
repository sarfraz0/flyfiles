FlyFiles
========

This little REST API handles the sorting of downloaded shows
I wrote it because I was fed up with the random behaviour of sickrage/sonarr sorting mechanism

# Build

Install stack and the pcre C lib
stack build

# TODO
- add auto regex generation from repository
- add show metadata grabbing (mediainfo + online apis)
- add show renaming and creation of nfo from metadata
- add email and kodi notifications
- add sonarr handles
- add posters images grabing
- populate init.sql script with current common shows
- add season ordering
- add x265 reencoding -> x264
- add subtitles grabbing
- add processed files report after sorting
- create documentation
- create dockerfile
- create supervisord config
- trim yesod dependencies
- profile recursives calls
- add swagger specs
- add transmission completion check