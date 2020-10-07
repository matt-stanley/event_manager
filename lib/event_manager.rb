require 'csv'
require 'google/apis/civicinfo_v2'

root = '..'
attendees = "#{root}/event_attendees.csv"
contents = CSV.open(attendees, headers: true, header_converters: :symbol)

# Returns zipcode set to 5 digits, with 0s at beginning if too short, including if nil
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0').slice(0, 5)
end

puts 'Event Manager initialized.'

contents.each do |row|
  name     = row[:first_name]
  zipcode  = clean_zipcode(row[:zipcode])

  puts "#{name}, #{zipcode}"
end
