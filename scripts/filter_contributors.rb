require 'json'

JSON_DIR = File.expand_path("../../data/json", __FILE__)
TYPE = ARGV[0]
INPUT_FILE = File.join(JSON_DIR, "contributors.json")
OUTPUT_FILE = File.join(JSON_DIR, TYPE + "_contributors.json")

puts "Generating " + TYPE + "_contributors.json"

output = {}
JSON.parse(File.read(INPUT_FILE)).each {|contrib_id, record|
  if(record['type'] == TYPE)
    output[contrib_id] = record
  end
}

File.open(OUTPUT_FILE, 'w') {|doc| doc.write(output.to_json)}
