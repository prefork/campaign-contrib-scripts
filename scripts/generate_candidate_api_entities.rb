require 'json'

API_DIR = File.expand_path("../../api/candidates", __FILE__)
JSON_DIR = File.expand_path("../../data/json", __FILE__)
INPUT_FILE = File.join(JSON_DIR, "candidates.json")
COMMITTEE_FILE = File.join(JSON_DIR, "committees.json")
CONTRIBUTOR_FILE = File.join(JSON_DIR, "contributors.json")

committees = JSON.parse(File.read(COMMITTEE_FILE))
contributors = JSON.parse(File.read(CONTRIBUTOR_FILE))

COMM_FOR_CAND = {}
committees.values.each do |committee|
  committee['candidates'].each do |candidate|
    COMM_FOR_CAND[candidate['candidate_id']] ||= {}
    COMM_FOR_CAND[candidate['candidate_id']][committee['committee_id']] = committee
  end
end

CON_FOR_COMM = {}
contributors.values.each do |contributor|
  contributor['contributions'].each do |contribution|
    CON_FOR_COMM[contribution['committee_id']] ||= {}
    CON_FOR_COMM[contribution['committee_id']][contributor['contributor_id']] = contributor
  end
end

def related_committees(candidate_id)
  if candidate_id
    return COMM_FOR_CAND[candidate_id] || {}
  else
    return {}
  end
end

def related_contributions(committees)
  contributions = {}
  committees.values.each do |committee|
    contributions[committee['committee_id']] = CON_FOR_COMM[committee['committee_id']]
  end
end

def output_filename(id)
  return File.join(API_DIR, id + ".json")
end

JSON.parse(File.read(INPUT_FILE)).each {|candidate_id, record|
  record['related_committees'] = related_committees(candidate_id)
  record['related_contributions'] = related_contributions(record['related_committees'])
  File.open(output_filename(candidate_id), 'w') {|doc| doc.write(record.to_json)}
}
