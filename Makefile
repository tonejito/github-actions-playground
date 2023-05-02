#!/usr/bin/make -f
#	= ^ . ^ =
SHELL=/bin/bash

PANDOC_FLAGS=--defaults pandoc.cfg
INPUT=index.md

default:	build
test:	check

check:
	pre-commit install || cat ${HOME}/.cache/pre-commit/pre-commit.log
	pre-commit run --all-files --show-diff-on-failure --color=always

build:	${INPUT}
	test -d public || mkdir -vp public
	pandoc ${PANDOC_FLAGS}
