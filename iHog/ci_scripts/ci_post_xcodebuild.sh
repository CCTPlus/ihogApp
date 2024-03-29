#!/bin/sh

if [[ $CI_WORKFLOW == "TestFlight" ]]; then
  pushd ..
    mkdir TestFlight
    pushd TestFlight
      for locale in en-US; do
        git fetch --deepen 3 && git log -3 --pretty=format:"%s" > WhatToTest.$locale.txt
      done
    popd
  popd
fi