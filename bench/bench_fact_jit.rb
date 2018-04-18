#!/usr/bin/env ruby

def compute_average(arr)
	average = 0.0

	for i in arr
		average += i
	end

	return average / arr.size
end

def generate_fact(n, filename)
	file = open(filename, "w")
	file.puts("function fact(n) {")
	file.puts("\tif (n < 2) {")
	file.puts("\t\treturn 1;")
	file.puts("\t};")
	file.puts("\treturn fact(n - 1) *n;")
	file.puts("};")

	file.puts("fact(#{n});")

	file.close
end

REPEAT=10

if (ARGV.size != 4)
	puts "usage : " + __FILE__ + " exe start end step"
	return
end

EXE     = ARGV[0]
START   = ARGV[1].to_i
FINISH  = ARGV[2].to_i
STEP    = ARGV[3].to_i

filename_exe = /.*\/(.*)\..*/.match(EXE)[1]
filename = "#{filename_exe}_#{START}_#{FINISH}_#{STEP}.dat"

if File.exist?(filename)
	printf "\e[31m ===> File #{filename} already exist! -  press 'y' to delete it: \e[m"
	prompt = STDIN.gets.chomp
	return unless prompt == 'y'
end

puts "Data will be stored in #{filename}"

file = File.open(filename, "w")

file.write("# fact_rank time\n")

parsed_file = "/tmp/machin.parse"

for fact_rank in ((START..FINISH).step(STEP))
	current_iteration = Array.new
	print fact_rank.to_s + " "

	generate_fact(fact_rank, parsed_file + ".caca")

	`cat #{parsed_file}.caca | jsp > #{parsed_file}`

	for _ in 0..REPEAT
		res = `(/usr/bin/time -f "%e" ./#{EXE} #{parsed_file} 1> /dev/null) 2>&1`

		current_iteration.push(res.to_f)
		print "#"
	end

	average = compute_average(current_iteration)

	file.write("#{fact_rank} #{average}\n")
	file.flush
	puts
end

file.close

puts "Data are in #{filename}"
