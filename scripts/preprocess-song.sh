#!/bin/sh

SONGNAME=$(basename $1 .tex)
BOOK=$2

if [ ! -d working ]; then
	mkdir working
fi

LYTEX=working/$SONGNAME.lytex
OUTTEX=working/$SONGNAME.tex
FINALTEX=working/$SONGNAME.$BOOK.tex

echo "  cp $1 $LYTEX"
cp $1 $LYTEX

echo "  lilypond-book --pdf --output=working $LYTEX"
lilypond-book --pdf --output=working $LYTEX

# go through any lilypond output created, and fix it to include 'working'
for dir in working/*; do
	d=$(basename $dir)
	if [ -d $dir ]; then
		if [ ! -f $dir/already_done ]; then
			for f in working/$d/*.tex; do
				echo "  mv $f $f.tmp"
				mv $f $f.tmp
				echo "  sed 's/\includegraphics{'$d'/\includegraphics{working\/'$d'/' <$f.tmp >$f"
				sed 's/\includegraphics{'$d'/\includegraphics{working\/'$d'/' <$f.tmp >$f
			done
			touch $dir/already_done
		fi
	fi
done

echo "  mv $OUTTEX $OUTTEX.tmp"
mv $OUTTEX $OUTTEX.tmp

echo "  sed 's_\input _\input working/_' <$OUTTEX.tmp >$OUTTEX"
sed 's_\input _\input working/_' <$OUTTEX.tmp >$OUTTEX

if [ "$BOOK" != "" ]; then
	if [ "$BOOK" = ukulelo ]; then
		# for ukuleles - remove slash chords
		# eg: D/F# -> D, Em/F# -> Em
		sed -e 's_\\\[\(..\?.\?\)/..\?\]_\\\[\1\]_g' <$OUTTEX >$FINALTEX
	else
		# any other book, just move it into place
		cp $OUTTEX $FINALTEX
	fi
fi
