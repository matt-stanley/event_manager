require 'csv'

def validate_phone(phone)
  phone.gsub!(/\D/, '')
  if phone.nil? || phone.length < 10 || phone.length > 11 || (phone.length == 11 && phone[0] != '1')
    'Invalid phone number'
  else
    phone.slice(-10..)
  end
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

contents.each do |row|
  id = row[0]
  phone = validate_phone(row[:homephone])

  puts "#{id}: #{phone}"
end