DL=wget
SOURCE_DATA="https://data.opennebraska.io/dataset/0c5a44c3-fa26-4df5-aad2-c16b93f23084/resource/42328073-dd55-4072-b774-e02bf02b82ef/download/nadc.zip"

all:
	echo "Please choose a target."

api: source_data

source_data: data/json

data/json/candidates.json: data/csv
	mkdir -p data/json
	bundle exec ruby scripts/generate_candidate_json.rb

data/csv: data/src
	mkdir data/csv
	bundle exec ruby scripts/normalize_csv_files.rb

data/src:
	mkdir -p data
	$(DL) $(SOURCE_DATA)
	unzip nadc.zip -d data
	mv data/nadc_data data/src
	rm nadc.zip

clean:
	rm -rf data nadc.zip
