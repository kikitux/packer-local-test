#!/bin/bash

GHTEST="`curl -sS -I https://api.github.com 2>&1`"
RET=$?

if [ ${RET} -ne 0 ]; then
  echo "ERR: check internet connection"
  echo "${GHTEST}"
  echo "Curl exit code: ${RET}"
  exit ${RET}
fi

if [ ${1} ];then
  PR="${1}"
else
  unset PR
fi

if [ -d packer ];then
  pushd packer
  git fetch
  git clean -fdx
  popd
else
  git clone https://github.com/mitchellh/packer.git
  pushd packer
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git fetch --all --tags
  popd
fi

if [ ${PR} ];then
  echo "Will checkout to pr/${PR}"
  pushd packer
  git checkout pr/${PR}
  popd
else
  echo "Will checkout to master"
  pushd packer
  git checkout master
  popd
fi
