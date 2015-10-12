# packer-local-test

## Goal
Toy project that will try to create a test suite for packer.

## Main Idea

If local host have `bzr`, `go` and `gox` we will build locally.
If local host have `virtualbox`, `vmware`, `docker` we will try to test locally.

Then, we will be using `vmware-vmx` will spin a vm and test packer with a suite of known test.

## Workflow

If GOPATH is set, will:
- go get if there is no `$GOPATH/src/github.com/mitchellh/packer`
- git fetch if there is `$GOPATH/src/github.com/mitchellh/packer`
- ensure `pr/*` is part of the repo
- run make updatedeps on first run, or if updatedeps is an argument

If GOPATH is set, and bzr, go, gox are available, it will:
- make test
- make dev
  

## TODO

- be able to:

```bash
[ <master> || <branch> || <number> || <latest> ]
```

- have some known `template.json` and run packer validate
- based on what's available, do some packer build
- if vmware is available, do some nested vm for a more complete suite of tests


### Local requirements

- `git`
- `bzr`
- `go`
- `gox`
- GOPATH

### File structure


```bash.                                                                                                                                                                                                                                   
.
|-- Darwin
|-- Darwin.iso
|-- Darwin.vmx
|-- LICENSE
|-- README.md
|-- packer
|-- packer-local-test.sh
|-- scripts
`-- test_flavors.xlsx  
```

### Helper file

A file will be provided, `packer-local-test.sh` that will do some heavy lifting.

```bash
packer-local-test.sh  master // will checkout to master
packer-local-test.sh  nnnn // will checkout to pr/nnnn
```

If go and gox are available, the helper will try to compile locally.

Usage ie:
```bash
$ bash packer-local-test.sh 2810
/Volumes/hd1/Dropbox/am/Git/kikitux/packer-local-test/packer /Volumes/hd1/Dropbox/am/Git/kikitux/packer-local-test
Removing bin/
Removing pkg/
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
From https://github.com/mitchellh/packer
 * branch            HEAD       -> FETCH_HEAD
Already up-to-date.
Fetching origin
/Volumes/hd1/Dropbox/am/Git/kikitux/packer-local-test
Will checkout to pr/2810
/Volumes/hd1/Dropbox/am/Git/kikitux/packer-local-test/packer /Volumes/hd1/Dropbox/am/Git/kikitux/packer-local-test
Switched to branch 'pr/2810'
Your branch is up-to-date with 'origin/pr/2810'.
build goes here
go get -v -d ./...                                                                                                                                                                                                                  
```


### Tips that will make thing easier

```bash
git clone https://github.com/mitchellh/packer.git
cd packer
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git fetch
```

Then

```bash
git checkout pr/2805
```

ie:

```bash
$ git checkout master                                                                                                 
Already on 'master'
Your branch is up-to-date with 'origin/master'.
$ cat -n builder/digitalocean/artifact.go | grep 35
35          return strconv.FormatUint(uint64(a.snapshotId), 10)

$ git checkout pr/2805                                                                               
Switched to branch 'pr/2805'                                                                                          Your branch is up-to-date with 'origin/pr/2805'.                                                                      

$ cat -n builder/digitalocean/artifact.go | grep 35
35          return fmt.Sprintf("%s:%s", a.regionName, strconv.FormatUint(uint64(a.snapshotId), 10))
```

