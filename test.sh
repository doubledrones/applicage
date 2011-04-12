#!/bin/sh

cd `dirname $0`

./install.sh

function port_test() {
  port uninstall $1
  port install $1
}

port_test Caffeine
port_test iTerm
port_test postgresql84
port_test postgresql84-server
port_test Mactracker
port_test Steam
port_test Pixelmator
port_test cue-splitter
port_test PYMPlayer
port_test TVShows
port_test TwistedWave64
port_test XLD
port_test Dropbox
port_test jDownloader
port_test NetworkLocation
port_test openssh
port_test simpleproxy
port_test Skype
port_test uTorrent
port_test weex
port_test 1Password
port_test Alfred
port_test Evernote
port_test KeyboardMaestro
port_test MindNode
port_test TextMate
port_test Things
port_test Arq
port_test CleanMyMac
port_test DasBoot
port_test firefox-bin-pl
port_test MozillaPrism
port_test polipo
