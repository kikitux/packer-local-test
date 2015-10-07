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

GHTEST="`curl -sS -I https://api.github.com 2>&1`"
RET=$?

if [ ${RET} -ne 0 ]; then
  echo "ERR: check internet connection"
  echo "${GHTEST}"
  echo "Curl exit code: ${RET}"
  exit ${RET}
fi

if [ -d packer ];then
  pushd packer
  git clean -fdx
  git checkout master
  git pull -f --prune origin HEAD
  git fetch --all --tags
  popd
else
  git clone https://github.com/mitchellh/packer.git
  pushd packer
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git checkout master
  git pull -f --prune origin HEAD
  git fetch --all --tags
  popd
fi

if [ "${1}" == "master" ] || [ "${1}" -eq 0 ] ;then
  CHECKOUT="master"
  echo "Will checkout to master"
  pushd packer
  git checkout master
  popd
elif [ "${1}" ];then
  CHECKOUT="pr/${1}"
  echo "Will checkout to ${CHECKOUT}"
  pushd packer
  git checkout ${CHECKOUT}
  popd
fi