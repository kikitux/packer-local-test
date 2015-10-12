# Makefile
#this makefile will recreate base box for test

date:=$(shell date +%y.%m.%d 2>/dev/null | tee date.txt)

TEMPLATE_FILES := $(wildcard *test.json)
TEMPLATE_BASE := $(TEMPLATE_FILES:test.json=.json)
VMX_FILES := $(foreach template, $(TEMPLATE_BASE), $(template:.json=)/$(template:.json=.vmx))

PWD := `pwd`



osx1011go14/osx1011go14.vmx: osx1011go14.json osx1011go14.sh
	@-rm -fr $(@D)
	packer build $<

.PHONY: all list

all: $(VMX_FILES)

list:
	@echo vms: $(VMX_FILES), templates: $(TEMPLATE_BASE)

test: all
	@echo pepe
	@echo packer build osx1011go14test.json
