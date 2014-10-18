DL=wget
SOURCE_DATA="https://data.opennebraska.io/dataset/0c5a44c3-fa26-4df5-aad2-c16b93f23084/resource/42328073-dd55-4072-b774-e02bf02b82ef/download/nadc.zip"

all:
	echo "Please choose a target."

api: json
	mkdir -p api/candidates
	mkdir -p api/contributors
	ruby scripts/generate_contributor_api_entities.rb
	ruby scripts/generate_candidate_api_entities.rb

json: data/json/contributors.json data/json/candidates.json data/json/committees.json

data/json/committees.json:
	mkdir -p data/json
	ruby scripts/generate_committee_json.rb

data/json/contributors.json:
	mkdir -p data/json
	ruby scripts/generate_contributor_json.rb

data/json/candidates.json:
	mkdir -p data/json
	ruby scripts/generate_candidate_json.rb

csv: data/src
	mkdir -p data/csv
	ruby scripts/normalize_csv_files.rb

data/src:
	mkdir -p data
	$(DL) $(SOURCE_DATA)
	unzip nadc.zip -d data
	mv data/nadc_data data/src
	rm nadc.zip

clean:
	rm -rf data nadc.zip
