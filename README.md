# packer-local-test

### Goal
Toy project that will try to create a test suite for packer.

### Main Idea

Using `vmware-vmx` will spin a vm and test packer with a suite of known test.

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

