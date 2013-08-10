#!/bin/sh

SONGNAME=$(basename $1 .tex)
BOOK=$2

LYTEX=working/$SONGNAME.lytex
OUTTEX=working/$SONGNAME.tex
FINALTEX=working/$SONGNAME.$BOOK.tex

echo "  cp $1 $LYTEX"
cp $1 $LYTEX

echo "  lilypond-book --pdf --output=working $LYTEX"
lilypond-book --pdf --output=working $LYTEX

echo "  mv $OUTTEX $OUTTEX.tmp"
mv $OUTTEX $OUTTEX.tmp

echo "  sed 's_\input _\input working/_' <$OUTTEX.tmp >$OUTTEX"
sed 's_\input _\input working/_' <$OUTTEX.tmp >$OUTTEX

if [ "$BOOK" != "" ]; then
	if [ "$BOOK" = ukulele ]; then
		# for ukuleles - remove slash chords
		# eg: D/F# -> D, Em/F# -> Em
		sed -e 's_\\\[\(.*\)/..\?\]_\\\[\1\]_g' <$OUTTEX >$FINALTEX
	else
		# any other book, just move it into place
		cp $OUTTEX $FINALTEX
	fi
fi
