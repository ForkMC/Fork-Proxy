#!/usr/bin/env bash

pushd ForkMC-Proxy
git rebase --interactive upstream/upstream
popd
