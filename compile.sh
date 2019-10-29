#!/bin/bash

ec17.05 -c_compile -config ./tracker.ecf

rm -f ./my_tracker
cp EIFGENs/tracker/W_code/tracker ./my_tracker

