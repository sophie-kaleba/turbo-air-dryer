#!/usr/local/bin/gnuplot --persist

set encoding utf8

set autoscale

if (ARGC < 1 || ARGC > 3) {
	print "usage: \n\tgnuplot -c " ,ARG0, " inputFile outputFile\n"
	exit
}

set title "Variation du temps d'execution en fonction du rang de fibonacci"
set grid

set xlabel "Fibo rank"
set ylabel "Temps d'execution"

set xrange [0:45]

# set style data linespoints

if (ARGC > 1) {
	set term postscript color
	set output sprintf("%s.ps", ARG3)
}


plot ARG1 using 1:2 with lines lt rgb "black" \
	     title "Jit", \
	     ARG2 using 1:2 with lines lt rgb "red" \
	     title "Interpreter"

if (ARGC == 3) {
	system(sprintf("ps2pdf %s.ps", ARG3))
	exit
}

pause -1
