# lastfm-to-hipchat

This is a little script that will post what you're currently playing on last.fm to HipChat. It polls last.fm every 20 sec to see what's
currently playing. If that's changed since the last time it checked, it knows a new song has started, and it sends a message to HipChat.

You can also post what you're playing on Spotify by changing Spotify's settings to "scrobble" to last.fm.

## Why?

Why not? Mostly this is an alternative to other things I've seen which do the same thing in hundreds of lines of Node.js vomit. 
This is less 40 lines of shell script, _including the configuration_. You be the judge on which approach is saner.

## Requirements 

- some kind of shell. bash or dash will do. (you've probably already got this)
- jq - a command line JSON processor. I've tested with version 1.4. I don't recommend anything below that.
- curl - command line HTTP client. (you've very likely already got this)
- Hipchat API key
- last.fm API key

That's pretty much it, I think.

## Setup

Copy the config.example file to one called "config". Edit the fields inside to match your desired API keys and other stuff. 

## Running

cd into the folder you cloned this into and run simply run the script like so:

`./lastfm-to-hipchat.sh`

## Have fun!
