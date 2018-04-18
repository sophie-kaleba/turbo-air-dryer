#!/usr/local/bin/gnuplot --persist

set encoding utf8

set autoscale

if (ARGC < 1 || ARGC > 4) {
	print "usage: \n\tgnuplot -c " ,ARG0, " inputFile outputFile\n"
	exit
}

set title "Variation du temps d'execution en fonction du rang de fibonacci"
set grid

set xlabel "Fibo rank"
set ylabel "Temps d'execution en secondes"

set xrange [0:40]
set yrange [0:2]

# set style data linespoints

if (ARGC > 3) {
	set term postscript color
	set output sprintf("%s.ps", ARG4)
}


plot ARG1 using 1:2 with lines lw 3 lt rgb "black" \
	     title "Jit", \
	     ARG2 using 1:2 with lines lw 3  lt rgb "red" \
	     title "unserializer", \
	     ARG3 using 1:2 with lines lw 3 lt rgb "green" \
	     title "Interpreter"

if (ARGC == 4) {
	system(sprintf("ps2pdf %s.ps", ARG4))
	exit
}

pause -1
