#!/bin/bash

targets=

target () {	
	echo
	echo $1: $2
	echo '	$(info '$1')'
}

target_required () {
	targets="$targets $1"
	target $1 $2
}

recipe () {
	echo "	"$1
}

for b in *.book; do
	book=$(basename $b .book)
	
	target_required "pdf/$book/book.pdf" "working/book.$book.pdf"
	recipe "mkdir -p pdf/$book"
	recipe 'cp $< $@'
	
	echo
	echo 'SONGS_WORKING_'$book'=$(patsubst working/%.tex,working/%.'$book'.tex,$(SONGS_WORKING))'
	
	target "working/songs_$book.tex" '$(SONGS_WORKING_'$book')'
	recipe "./scripts/generate-songs-tex.sh $book "'>$@'
	
	for s in songs/*; do
		song=$(basename $s .tex)
		
		target_required "pdf/$book/$song.pdf" "working/$song.$book.single.pdf"
		recipe "mkdir -p pdf/$book"
		recipe 'cp $< $@'
		
		target "working/$song.$book.single.pdf" "working/$song.$book.single.tex"
		recipe "pdflatex -output-directory=working $<"
		
		target "working/$song.$book.single.tex" "songs/$song.tex"
		recipe './scripts/generate-single.sh '$song' '$book' >$@'
		
		target "working/$song.$book.tex" "songs/$song.tex working"
		recipe './scripts/preprocess-song.sh $< '$book
		recipe ./scripts/fix-lilypond.sh
	done
done

echo
echo .pdfs: $targets


