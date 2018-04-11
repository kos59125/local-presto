#!/bin/bash

launcher start

presto --server localhost:8080 "$@"
