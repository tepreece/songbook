#!/bin/bash

targets=

declare -A once_targets

target () {	
	echo
	echo $1: $2
	echo '	$(info '$1')'
}

target_required () {
	targets="$targets $1"
	target "$@"
}

target_once () {
	if [ "${once_targets["$1"]}" = "" ]; then
		# we haven't seen this one before
		once_targets[$1]=true
		target "$@"
	else
		# do nothing; this target has already been made
		return false
	fi
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
	
	for s in songs/*.tex; do
		song=$(basename $s .tex)
		
		if [ -f "songs/$song.$book.ly" ]; then
			target_required "pdf/$book/$song.pdf" "working/$song.$book.single.pdf working/$song.$book.lily.pdf"
			recipe "mkdir -p pdf/$book"
			recipe 'pdftk $^ cat output $@'
			
			target "working/$song.$book.lily.pdf" "songs/$song.$book.ly"
			recipe "lilypond -o working/$song.$book.lily $<"
		elif [ -f "songs/$song.ly" ]; then
			target_required "pdf/$book/$song.pdf" "working/$song.$book.single.pdf working/$song.lily.pdf"
			recipe "mkdir -p pdf/$book"
			recipe 'pdftk $^ cat output $@'
			
			if target_once "working/$song.lily.pdf" "songs/$song.ly"; then
				recipe "lilypond -o working/$song.lily $<"
			fi
		else
			target_required "pdf/$book/$song.pdf" "working/$song.$book.single.pdf"
			recipe "mkdir -p pdf/$book"
			recipe 'cp $< $@'
		fi

		target "working/$song.$book.single.pdf" "working/$song.$book.single.tex"
		recipe "pdflatex -output-directory=working $<"
		
		target "working/$song.$book.single.tex" "working/$song.$book.tex"
		recipe './scripts/generate-single.sh '$song' '$book' >$@'
		
		target "working/$song.$book.tex" "songs/$song.tex"
		recipe './scripts/preprocess-song.sh $< '$book
	done
done

echo
echo .pdfs: $targets


