#!/usr/bin/env ruby

def compute_average(arr)
	average = 0.0

	for i in arr
		average += i
	end

	return average / arr.size
end

def generate_fibo(n, filename)
	filebo = open(filename, "w")
	filebo.puts("function fibo(n) {")
	filebo.puts("\tif (n < 2) {")
	filebo.puts("\t\treturn 1;")
	filebo.puts("\t};")
	filebo.puts("\treturn fibo(n - 1) + fibo(n - 2);")
	filebo.puts("};")

	filebo.puts("fibo(#{n});")

	filebo.close
end

REPEAT=5

if (ARGV.size != 4)
	puts "usage : " + __FILE__ + " exe start end step"
	return
end

EXE     = ARGV[0]
START   = ARGV[1].to_i
FINISH  = ARGV[2].to_i
STEP    = ARGV[3].to_i

filename = "#{START}_#{FINISH}_#{STEP}.dat"

if File.exist?(filename)
	printf "\e[31m ===> File #{filename} already exist! -  press 'y' to delete it: \e[m"
	prompt = STDIN.gets.chomp
	return unless prompt == 'y'
end

puts "Data will be stored in #{filename}"

file = File.open(filename, "w")

file.write("# fibo_rank time\n")

parsed_file = "/tmp/machin.parse"

for fibo_rank in ((START..FINISH).step(STEP))
	current_iteration = Array.new
	print fibo_rank.to_s + " "

	generate_fibo(fibo_rank, parsed_file + ".caca")

	`cat #{parsed_file}.caca | jsp > #{parsed_file}`

	for _ in 0..REPEAT
		res = `(/usr/bin/time -f "%e" ./#{EXE} #{parsed_file} 1> /dev/null) 2>&1`
#		puts res
		current_iteration.push(res.to_f)
		print "#"
	end

	# maintenant on va retirer les 10% les plus éloigné de la moyenne
	average = compute_average(current_iteration)

	file.write("#{fibo_rank} #{average}\n")
	file.flush
	puts
end

file.close

puts "Data are in #{filename}"
