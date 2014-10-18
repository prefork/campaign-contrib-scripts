require 'csv'
require 'json'

DATA_DIR = File.expand_path("../../data/csv", __FILE__)
JSON_DIR = File.expand_path("../../data/json", __FILE__)

def new_committee(row)
  doc = {}
  return doc
end

committees = {}
cand = {}

CSV.read(File.join(DATA_DIR,"forma1cand.csv"), :headers => true).each do |row|
  unless cand[row['Form A1 ID Number']]
    cand[row['Form A1 ID Number']] = []
  end
  cand[row['Form A1 ID Number']] << {
    :candidate_id => row['Candidate ID'],
    :status => row['Support/Oppose'] == 1 ? :oppose : :support,
    :office_sought => row['Office Sought'],
    :office_title => row['Office Title'],
    :office_description => row['Office Description'],
    :filing_date => DateTime.strptime(row['Date Received'], "%m/%d/%Y")
  }
end

CSV.read(File.join(DATA_DIR,"forma1.csv"), :headers => true).each do |row|
  committee_id = row['Committee ID Number']
  committee = committees[committee_id] || {}
  committee[:committee_id] = committee_id
  committee[:name] = row['Committee Name']
  committee[:zipcode] = row['Committee Zip']
  committee[:candidates] = cand[committee_id] || []

  committees[committee_id] = committee
end

File.open(File.join(JSON_DIR, "committees.json"), 'w') {|doc| doc.write(committees.to_json)}
