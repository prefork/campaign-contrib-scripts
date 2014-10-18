require 'csv'
require 'json'

DATA_DIR = File.expand_path("../../data/csv", __FILE__)
JSON_DIR = File.expand_path("../../data/json", __FILE__)
CONTRIBUTOR_TYPES = {
 "I" => :individual,
 "B" => :business,
 "C" => :corporation,
 "M" => :candidate_committee,
 "P" => :pac,
 "Q" => :ballot_question,
 "R" => :political_party
}

def new_contributor(row)
  doc = {}
  doc[:contributor_id] = row['Contributor ID']
  doc[:first_name] = row['Contributor First Name']
  doc[:middle_name] = row['Contributor Middle Initial']
  doc[:last_name] = row['Contributor Last Name']
  doc[:organization_name] = row['Contributor Organization Name']
  doc[:zip_code] = row['Contributor Zipcode']
  doc[:state] = row['Contributor State']
  doc[:city] = row['Contributor City']
  doc[:type] = contributor_type(row['Type of Contributor'])
  doc[:contributions] = []
  return doc
end

# (I=Individual, B=Business, C=Corporation, M=Candidate Committee, P=PAC, Q=Ballot Question, R=Political Party)
def contributor_type(code)
  if CONTRIBUTOR_TYPES.has_key?(code)
    return CONTRIBUTOR_TYPES[code]
  else
    puts "[warn] unknown contributor type: " + (code || '')
    return :unknown
  end
end

def new_contribution(row)
  contribution = {}
  contribution[:committee_id] = row['Committee ID']
  contribution[:date] = DateTime.strptime(row['Contribution Date'], "%Y-%m-%d")
  contribution[:amount] = {}
  contribution[:amount][:cash] = row['Cash Contribution']
  contribution[:amount][:in_kind] = row['In-Kind Contribution']
  contribution[:amount][:unpaid_pledge] = row['Unpaid Pledges']
  return contribution
end

contributors = {}

CSV.read(File.join(DATA_DIR,"formb1ab.csv"), :headers => true).each do |row|
  contributor_id = row['Contributor ID']

  # get a record to work on
  contributors[contributor_id] ||= new_contributor(row)
  contributor = contributors[contributor_id]

  contributor[:contributions] << new_contribution(row)

  # put it back
  contributors[contributor_id] = contributor
end

contributors.values.each do |c|
  c[:contributions].sort_by { |hsh| hsh[:date].strftime('%s').to_i }
end

File.open(File.join(JSON_DIR, "contributors.json"), 'w') {|doc| doc.write(contributors.to_json)}
