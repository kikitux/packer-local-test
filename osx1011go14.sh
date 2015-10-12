#!/bin/sh
export PATH=$PATH:/usr/local/bin
brew update && brew upgrade --all
brew install git bzr homebrew/versions/go14
export GOROOT=/usr/local/Cellar/go14/1.4.2/libexec
export GOPATH=~/go
mkdir -p $GOPATH
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
[ -f $GOPATH/bin/gox ] || {
  go get github.com/mitchellh/gox
  go build github.com/mitchellh/gox
}
