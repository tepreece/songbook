#!/bin/bash

name=$(basename $1 .book)
echo "  sed 's/###BOOKNAME###/$name/' <tex/book.tex >working/book.$name.tex"
sed 's/###BOOKNAME###/'$name'/' <tex/book.tex >working/book.$name.tex
