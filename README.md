# packer-local-test

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

