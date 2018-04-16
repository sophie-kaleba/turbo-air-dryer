#!/usr/local/bin/gnuplot --persist

set encoding utf8

set autoscale

if (ARGC < 1 || ARGC > 2) {
	print "usage: \n\tgnuplot -c " ,ARG0, " inputFile outputFile\n"
	exit
}

set title "Variation du temps d'execution en fonction du rang de fibonacci"
set grid

set xlabel "Temps d'execution"
set ylabel "Fibo rank"

# set style data linespoints

if (ARGC > 1) {
	set term postscript color
	set output ARG2
}


plot ARG1 using 1:2 with lines lt rgb "black" \
	     title "Débit en fonction du nombres d'octets envoyé

if (ARGC == 2) {
	system(sprintf("ps2pdf %s", ARG2))
	exit
}

pause -1
