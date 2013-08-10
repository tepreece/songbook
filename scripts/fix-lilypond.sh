#!/bin/sh

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
