#!/bin/bash

print_help(){
cat <<EOF
help goes
here
mutiline
EOF
}

#if no arguments, or -h anywhere, we print help and exit
if [ $# -eq 0 ] || [[ "$@" =~ "-h" ]];then
  print_help
  exit 0
fi

#check for go and gox binary
#if no present, we skip local build, local test.
unset CHECK
which gox go bzr &>/dev/null
if [ $? -eq 0 ]; then
  CHECK=0
else
  echo "Info: bzr, go or gox not found, skipping local build"
  CHECK=1
fi

GHTEST="`curl -sS -I https://api.github.com 2>&1`"
RET=$?

if [ ${RET} -ne 0 ]; then
  echo "ERR: check internet connection"
  echo "${GHTEST}"
  echo "Curl exit code: ${RET}"
  exit ${RET}
fi

if [ $GOPATH ] && [ -d $GOPATH/src/github.com/mitchellh/packer ];then
  pushd $GOPATH/src/github.com/mitchellh/packer
  #check .git/config for pr/*, add if not present
  grep 'fetch.*.=.*.+refs/pull/\*/head:refs/remotes/origin/pr/\*' .git/config &>/dev/null
  if [ $? -ne 0 ]; then
    git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  fi
  git clean -fdx
  git checkout master
  git pull -f --prune origin HEAD
  git fetch --all --tags
  popd
elif  [ $GOPATH ];then
  go get github.com/mitchellh/packer
  pushd $GOPATH/src/github.com/mitchellh/packer
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git checkout master
  git pull -f --prune origin HEAD
  git fetch --all --tags
  #on first run we run make updatedeps
  make updatedeps
  popd
fi

if [ $CHECK ] && [ $CHECK -eq 0 ]; then
  echo "build goes here"
  pushd $GOPATH/src/github.com/mitchellh/packer
  #run make updatedeps
  if [[ "${@}" =~ "updatedeps" ]] ;then
    echo "running make updatedeps"
    make updatedeps
  fi
  if [ "${1}" == "master" ] || [ "${1}" -eq 0 ] ;then
    CHECKOUT="master"
    echo "Will checkout to master"
    git checkout ${CHECKOUT} --force
  elif [ "${1}" ];then
    CHECKOUT="pr/${1}"
    echo "Will checkout to ${CHECKOUT}"
    git checkout ${CHECKOUT} --force
  fi
  make test
  make dev
fi
