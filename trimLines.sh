#!/bin/bash

awk -v maxLen=$3 'length>maxLen && $0 ~ />/{len=length;$0=substr($0,0,maxLen)};1' $1 > $2
