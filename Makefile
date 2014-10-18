DL=wget
SOURCE_DATA="https://data.opennebraska.io/dataset/0c5a44c3-fa26-4df5-aad2-c16b93f23084/resource/42328073-dd55-4072-b774-e02bf02b82ef/download/nadc.zip"

all:
	echo "Please choose a target."

api: json

json: data/json/contributors.json data/json/candidates.json data/filtered_contributors

data/filtered_contributors: data/json/individual_contributors.json data/json/business_contributors.json data/json/corporation_contributors.json data/json/candidate_committee_contributors.json data/json/pac_contributors.json data/json/ballot_question_contributors.json data/json/political_party_contributors.json

data/json/individual_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb individual

data/json/business_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb business

data/json/corporation_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb corporation

data/json/candidate_committee_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb candidate_committee

data/json/pac_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb pac

data/json/ballot_question_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb ballot_question

data/json/political_party_contributors.json: data/json/contributors.json
	mkdir -p data/json
	bundle exec ruby scripts/filter_contributors.rb political_party

data/json/contributors.json:
	mkdir -p data/json
	bundle exec ruby scripts/generate_contributor_json.rb

data/json/candidates.json:
	mkdir -p data/json
	bundle exec ruby scripts/generate_candidate_json.rb

csv: data/src
	mkdir -p data/csv
	bundle exec ruby scripts/normalize_csv_files.rb

data/src:
	mkdir -p data
	$(DL) $(SOURCE_DATA)
	unzip nadc.zip -d data
	mv data/nadc_data data/src
	rm nadc.zip

clean:
	rm -rf data nadc.zip
