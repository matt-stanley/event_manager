require 'csv'
require 'open-uri'
require 'json'
require 'erb'

template_letter = File.read('form_letter.erb')
erb_template = ERB.new(template_letter)

# Returns zipcode set to 5 digits, with 0s at beginning if too short, including if nil
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0').slice(0, 5)
end

def legislators_by_zipcode(zipcode)
  base_url = 'https://www.googleapis.com/civicinfo/v2/representatives?'
  levels = 'country'
  roles = %w[legislatorUpperBody legislatorLowerBody]
  key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    response = URI.open("#{base_url}address=#{zipcode}&levels=#{levels}&roles=#{roles[0]}&roles=#{roles[1]}&key=#{key}").read
    JSON.parse(response)['officials']
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'Event Manager initialized.'
puts 'Fetching data...'

attendees = 'event_attendees.csv'
contents = CSV.open(attendees, headers: true, header_converters: :symbol)

contents.each do |row|
  id       = row[0]
  name     = row[:first_name]
  zipcode  = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_letter(id, form_letter)
end

puts 'Personalized letters created in output directory.'
