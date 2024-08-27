#!/bin/sh

convert $1 -resize 105x105 space_$1
convert space_$1 space_mask.png -alpha on -compose copy_opacity -composite space_$1
