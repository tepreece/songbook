#!/bin/bash

for s in songs/*.tex; do
	song=$(basename $s .tex)
	if [ "$1" = "" ]; then
		echo '\input{working/'$song.tex'}'
		
	else
		echo '\input{working/'$song.$1'.tex}'
	fi
done
