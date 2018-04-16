#!/usr/bin/env ruby

def compute_average(arr)
	average = 0.0

	for i in arr
		average += i
	end

	return average / arr.size
end

REPEAT=30

if (ARGV.size != 5)
	puts "usage : " + __FILE__ + " exe start end step"
	return
end

EXE     = ARGV[0]
START   = ARGV[1].to_i
FINISH  = ARGV[2].to_i
STEP    = ARGV[3].to_i

filename = "#{EXE}_#{START}_#{FINISH}_#{STEP}.dat"

if File.exist?(filename)
	printf "\e[31m ===> File #{filename} already exist! -  press 'y' to delete it: \e[m"
	prompt = STDIN.gets.chomp
	return unless prompt == 'y'
end

puts "Data will be stored in #{filename}"

file = File.open(filename, "w")

file.write("# fibo_rank time\n")

for fibo_rank in ((START..FINISH).step(STEP))
	current_iteration = Array.new
	print fibo_rank.to_s + " "

	parsed_file = # truc

	for _ in 0..REPEAT
		client_res = `./#{EXE} #{parsed_file}`
		current_iteration.push(client_res.to_f)
		print "#"
	end

	# maintenant on va retirer les 10% les plus éloigné de la moyenne
	average = compute_average(current_iteration)

	v1 = [0, 0.0]
	v2 = [0, 0.0]
	v3 = [0, 0.0]
	for n in 0..(current_iteration.size - 1)
		if ((average - current_iteration[n]).abs > v1[1])
			v1 = [n, (average - current_iteration[n]).abs]
		end

		v2 = v1 if v2[1] < v1[1]
		v3 = v2 if v3[1] < v2[1]
	end

	current_iteration.delete_at(v1[0])
	current_iteration.delete_at(v2[0])
	current_iteration.delete_at(v3[0])

	average = compute_average(current_iteration)

	# Puis on calcule l'écart type (standard deviation en anglais)
	variance = 0.0
	for value in current_iteration
		variance += (value - average) ** 2
	end

	variance /= current_iteration.size

	standard_deviation = Math.sqrt(variance)

	file.write("#{i} #{average} #{standard_deviation}\n")
	file.flush
	puts
end

file.close

puts "Data are in #{filename}"
