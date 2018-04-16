#!/usr/local/bin/gnuplot --persist

set encoding utf8

set autoscale

if (ARGC < 1 || ARGC > 2) {
	print "usage: \n\tgnuplot -c " ,ARG0, " inputFile outputFile\n"
	exit
}

set title "Débit moyen pour envoyer n octets"
set grid

set xlabel "Taille des données envoyées"
set ylabel "Débit en o/s"

# set style data linespoints

if (ARGC > 1) {
	set term postscript color
	set output ARG2
}


plot ARG1 using 1:2 with lines lt rgb "black" \
	     title "Débit en fonction du nombres d'octets envoyée", \
	ARG1 using 1:($2 + $3) with lines lt rgb "red" \
	     title "+ écart-type", \
	ARG1 using 1:($2 - $3) with lines lt rgb "red"\
	     title "- écart-type", \

if (ARGC == 2) {
	system(sprintf("ps2pdf %s", ARG2))
	exit
}

pause -1
