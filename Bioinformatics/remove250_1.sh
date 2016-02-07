#!/bin/bash

tr "\250" "@" < $1 | sed -e 's/@//g' > $2
