#!/usr/bin/make -f
SHELL=/bin/bash

PANDOC_FLAGS=--defaults pandoc.cfg

default:	build

check:
	pre-commit run --all-files

build:	${INPUT}
	test -d public || mkdir -vp public
	pandoc ${PANDOC_FLAGS}
