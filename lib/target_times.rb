require 'csv'
require 'quickchart'

def get_hour(entry)
  DateTime.strptime(entry[:regdate], '%m/%d/%y %k:%M').strftime('%-l%p')
end

def get_day_of_week(entry)
  DateTime.strptime(entry[:regdate], '%m/%d/%y %k:%M').strftime('%a')
end

def visualize_times(resolution, hash)
  base_url = 'https://quickchart.io/chart/create'
  case resolution
  when 'hour'
    # set labels to hour of day
    labels = (1..11).to_a.unshift(12).map { |hour| hour.to_s + 'AM' } +
             (1..11).to_a.unshift(12).map { |hour| hour.to_s + 'PM' }
  when 'day'
    # set labels to days of week, create hash of days with #get_day_of_week
    labels = %w[Sun Mon Tue Wed Thu Fri Sat]
  else
    return "Invalid resolution. Try 'hour' or 'day'."
  end

  data = create_data(labels, hash)

  chart = create_chart(labels, data)

  output_chart(chart, resolution)
end

def create_data(labels, hash)
  data = []
  labels.each_with_index do |label, idx|
    data[idx] = hash.key?(label) ? hash[label] : 0
  end
  data
end

def create_chart(labels, data)
  chart = QuickChart.new(
    {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Sign-Ups',
          data: data
        }]
      }
    },
    width: 600,
    height: 300,
    device_pixel_ratio: 2.0
  )
  chart
end

def output_chart(chart, resolution)
  Dir.mkdir('output/charts') unless Dir.exist?('output/charts')
  chart.to_file("output/charts/target-#{resolution}-#{Date.today}")
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

# hours = Hash.new(0)
# contents.each do |row|
#   hour = get_hour(row)
#   hours[hour] += 1
# end



days = Hash.new(0)
contents.each do |row|
  day = get_day_of_week(row)
  days[day] += 1
end

visualize_times('day', days)
