#!/usr/local/bin/gnuplot --persist

set encoding utf8

set autoscale

set title "Variation du temps d'execution en fonction du rang de fibonacci"
set grid

set xlabel "Fibo rank"
set ylabel "Temps d'execution en secondes"

set key left

set xrange [27:46]
set yrange [0:100]

# set style data linespoints

if (ARGC > 0) {
	set term postscript color
	set output "plot5.ps"
}

plot "data/Jit_0_50_1.dat" using 1:2 with lines lw 3 lt rgb "black" \
	     title "Jit", \
	     "data/unserializer_0_50_1.dat" using 1:2 with lines lw 3  lt rgb "orange" \
	     title "unserializer", \
	     "data/node_1_100_1.dat" using 1:2 with lines lw 3  lt rgb "red" \
	     title "nodejs", \
	     "data/go_1_100_1.dat" using 1:2 with lines lw 3  lt rgb "cyan" \
	     title "golang", \
	     "data/python2_1_100_1.dat" using 1:2 with lines lw 3  lt rgb "purple" \
	     title "python2", \
	     "data/python3_1_100_1.dat" using 1:2 with lines lw 3 lt rgb "green" \
	     title "python3", \
	     "data/ruby_1_100_1.dat" using 1:2 with lines lw 3 lt rgb "grey" \
	     title "ruby"

if (ARGC == 20) {
	system("ps2pdf plot5.ps"))
	exit
}

pause -1
