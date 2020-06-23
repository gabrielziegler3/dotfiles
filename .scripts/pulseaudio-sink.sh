#!/usr/bin/bash

pacmd list-sinks | sed -n '/\* index:/ s/.*: //p'
