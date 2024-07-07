#!/usr/bin/env bash

git config --global --add safe.directory "$(pwd)"
pre-commit install --install-hooks
