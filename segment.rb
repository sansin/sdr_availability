require 'pry'
require 'date'
require 'time'

def read_file(file_path)
	formatted_array = []
	File.open(file_path,'r') do |f|
		f.each_line do |line|
			(2..line.split(',').length).each do |n|
				slots = line.split(',')[n-1].tr('"','').split.join(" ")
				slot_length = slots[0..6].split('-').length
				if slot_length == 1
					h = {}
					h[:sdr] = line.split(',')[0].tr('"','').split.join(" ")
					#h[:time_slot] = line.split(',')[n-1].tr('"','').split.join(" ")
					week = line.split(',')[n-1].tr('"','').split.join(" ")[0..2]
					time_slot = line.split(',')[n-1].tr('"','').split.join(" ")[3..-1].split.join(" ").split('-').collect{|x| x.strip || x }
					h[:start_time] = Time.parse((Date.parse(week).to_datetime).to_s[0..9]+" "+time_slot[0])
					h[:end_time] = Time.parse((Date.parse(week).to_datetime).to_s[0..9]+" "+time_slot[1])
					formatted_array << h
				else
					(DateTime.parse(slots[0..6].split('-')[0]).wday..DateTime.parse(slots[0..6].split('-')[1]).wday).each do |e|
						h = {}
						h[:sdr] = line.split(',')[0].tr('"','').split.join(" ")
						week = Date::DAYNAMES[e][0..2] 
						time_slot = slots[7..-1].split('-').collect{|x| x.strip || x }
						#h[:time_slot] = Date::DAYNAMES[e][0..2] + slots[7..-1]
						h[:start_time] = Time.parse((Date.parse(week).to_datetime).to_s[0..9]+" "+time_slot[0])
						h[:end_time] = Time.parse((Date.parse(week).to_datetime).to_s[0..9]+" "+time_slot[1])
						formatted_array << h
					end
				end
			end
		end
	end
	return formatted_array
end

def read_inp_file_name
	begin
	puts "Enter Input file name along with full path: "
	file_path = gets.chomp
		return read_file(file_path)
	rescue Errno::ENOENT => e
		puts "Invalid File Path. #{e}"
		retry
	rescue Exception => e
		puts "ERROR: #{e}"
	end
end

output_hash = read_inp_file_name
loop do 
	puts "\n\nPlease enter time slot. Ex: Thu 10 am (Case insensitive)"
	inp = gets.chomp
	inp_week = inp.split.join(" ")[0..2]
	inp_time = inp.split.join(" ")[3..-1].split.join(" ")
	inp_date_time = Time.parse((Date.parse(inp_week).to_datetime).to_s[0..9]+" "+inp_time)
	cnt = 0
	output_hash.each do |l|
		if inp_date_time < l[:end_time] and inp_date_time >= l[:start_time]
			cnt+=1
			availability = (l[:end_time] - inp_date_time) / 60 
			if availability < 60 
				availability = availability.round(2).to_s + " Minutes"
			else 
				availability = (availability/60).round(2).to_s + " Hours"
			end
			puts "#{l[:sdr]} available for next #{availability}"
		end
	end
	if cnt == 0
			puts "No SDR's available for the given time slot."
	end

	puts "Do you want to continue (Y/N): "
	continue = gets.chomp
	if continue.downcase == 'n'
		break
	elsif continue.downcase != 'y' and continue.downcase != 'n'
		puts "Invalid Input."
		break
	else
		puts "Do you want to use different file as input? (Y/N)"
		new_file = gets.chomp
		if new_file.downcase == 'y'
			read_inp_file_name
		elsif new_file.downcase != 'y' and new_file.downcase != 'n'
			puts "Invalid Input."
			break
		end
	end
end

