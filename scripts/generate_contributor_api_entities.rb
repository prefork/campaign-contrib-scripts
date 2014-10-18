require 'json'

API_DIR = File.expand_path("../../api/contributors", __FILE__)
JSON_DIR = File.expand_path("../../data/json", __FILE__)
INPUT_FILE = File.join(JSON_DIR, "contributors.json")
COMMITTEE_FILE = File.join(JSON_DIR, "committees.json")
CANDIDATE_FILE = File.join(JSON_DIR, "candidates.json")

COMMITTEES = JSON.parse(File.read(COMMITTEE_FILE))
CANDIDATES = JSON.parse(File.read(CANDIDATE_FILE))

def output_filename(id)
  return File.join(API_DIR, id + ".json")
end

def related_candidates(committees)
  related = {}
  committees.values.each do |c|
    if(c && c['candidates'])
      c['candidates'].each do |cand|
        related[cand['candidate_id']] = CANDIDATES[cand['candidate_id']]
      end
    end
  end
  return related
end

def related_committees(record)
  related = {}
  record['contributions'].each do |c|
    related[c['committee_id']] = COMMITTEES[c['committee_id']]
  end
  return related
end

JSON.parse(File.read(INPUT_FILE)).each {|contributor_id, record|
  record[:related_committees] = related_committees(record)
  record[:related_candidates] = related_candidates(record[:related_committees])
  File.open(output_filename(contributor_id), 'w') {|doc| doc.write(record.to_json)}
}
