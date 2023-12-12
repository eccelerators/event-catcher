#!/usr/bin/bash

docker run -it -v ${PWD}:/work -w /work ghdl/ghdl:ubuntu22-llvm-11
