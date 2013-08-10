#!/bin/bash

song=$1
book=$2

sed \
	-e 's/###SONGFILENAME###/working\/'$song.$book.tex'/' \
	-e 's/###BOOKNAME###/'$book'/' tex/single.tex
