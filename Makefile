BOOKS=$(wildcard *.book)
SONGS=$(wildcard songs/*.tex)
LILYPONDS=$(wildcard songs/*.ly)
SONGS_WORKING=$(patsubst songs/%.tex,working/%.tex,$(SONGS))

.SECONDARY:

all: .pdf-targets

clean:
	rm -r songs.mk working pdf

-include songs.mk

songs.mk: Makefile $(BOOKS) $(SONGS) $(LILYPONDS)
	./scripts/generate-songs-mk.sh >$@
	
.pdf-targets: .pdfs

working/%_title.sxd: working/book.%.tex working/songs_%.tex
	pdflatex -output-directory=working $<

working/%_auth.sxd: working/%_title.sxd
	# pass

working/%.sbx: working/%.sxd
	songidx $< $@

working/book.%.pdf: working/book.%.tex working/%_title.sbx working/%_auth.sbx
	pdflatex -output-directory=working $<

working/book.%.tex: %.book working/songs_%.tex
	./scripts/generate-book-tex.sh $<

