#!/usr/bin/env bash

cd images
./generate_images.sh
cd -
bundle exec jekyll serve --drafts

