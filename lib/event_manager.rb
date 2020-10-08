require 'csv'
require 'open-uri'
require 'json'

attendees = '../event_attendees.csv'
contents = CSV.open(attendees, headers: true, header_converters: :symbol)

# Example API call
# https://www.googleapis.com/civicinfo/v2/representatives?address=80203&levels=country&roles=legislatorUpperBody&roles=legislatorLowerBody&key=AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw

# Returns zipcode set to 5 digits, with 0s at beginning if too short, including if nil
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0').slice(0, 5)
end

def make_api_call(zipcode)
  base_url = 'https://www.googleapis.com/civicinfo/v2/representatives?'
  key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  URI.open("#{base_url}address=#{zipcode}&levels=country&roles=legislatorUpperBody&roles=legislatorLowerBody&key=#{key}").read
end

puts 'Event Manager initialized.'

contents.each do |row|
  name     = row[:first_name]
  zipcode  = clean_zipcode(row[:zipcode])

  rep_info = JSON.parse(make_api_call(zipcode))

  puts "#{name}, #{zipcode}"
end
