BOOKS=$(wildcard *.book)
SONGS=$(wildcard songs/*.tex)
SONGS_WORKING=$(patsubst songs/%.tex,working/%.tex,$(SONGS))

.SECONDARY:

all: .pdf-targets

clean:
	rm -r songs.mk working pdf

working:
	mkdir working

-include songs.mk

songs.mk: Makefile $(BOOKS) $(SONGS)
	./scripts/generate-songs-mk.sh >$@
	
.pdf-targets: .pdfs

working/%_title.sxd: working/book.%.tex working/songs.%.tex working
	pdflatex -output-directory=working $<

working/%_auth.sxd: working/%_title.sxd working
	# pass

working/%.sbx: working/%.sxd working
	songidx $< $@

working/book.%.pdf: working/book.%.tex
	#working/%_title.sbx working/%_auth.sbx working
	pdflatex -output-directory=working $<

working/book.%.tex: %.book working/songs_%.tex working
	./scripts/generate-book-tex.sh $<

#working/songs.tex: working $(SONGS_WORKING)
#	./scripts/generate-songs-tex.sh >$@
#	./scripts/fix-lilypond.sh

