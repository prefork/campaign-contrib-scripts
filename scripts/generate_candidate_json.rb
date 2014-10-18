require 'csv'
require 'json'

DATA_DIR = File.expand_path("../../data/csv", __FILE__)
JSON_DIR = File.expand_path("../../data/json", __FILE__)

def new_candidate(row)
  doc = {}
  doc[:first_name] = row['Candidate First Name']
  doc[:middle_name] = row['Candidate Middle Initial']
  doc[:last_name] = row['Candidate Last Name']
  doc[:candidate_id] = row['Candidate ID']
  doc[:events] = []
  return doc
end

def new_event(row)
  office_code = row['Office Code']
  office_held = row['Office Held']
  office_area = row['Subdivision']
  filing_date = DateTime.strptime(row['Date Received'], "%m/%d/%Y")
  event_type = nil
  if(row['New Appt'])
    event_type = :newly_elected
  elsif(row['Elective Office'])
    event_type = :seeking_office
  elsif(row['Annual or Employee Report'])
    event_type = :annual_report
  else
    event_type = :unknown
  end
  return {:office_code => office_code, :office => office_held, :office_area => office_area, :event_type => event_type, :filing_date => filing_date}
end

candidates = {}

CSV.read(File.join(DATA_DIR,"formc1.csv"), :headers => true).each do |row|
  candidate_id = row['Candidate ID']

  # get a record to work on
  candidates[candidate_id] ||= new_candidate(row)
  candidate = candidates[candidate_id]

  candidate[:events] << new_event(row)

  # put it back
  candidates[candidate_id] = candidate
end

candidates.values.each do |c|
  c[:events].sort_by { |hsh| hsh[:filing_date].strftime('%s').to_i }
end

File.open(File.join(JSON_DIR, "candidates.json"), 'w') {|doc| doc.write(candidates.to_json)}
