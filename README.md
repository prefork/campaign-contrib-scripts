## Prerequisites

You'll need Ruby `>= 2.0.0` for running the scripts.  You'll also need the python module `csvkit` (`pip install csvkit`) for the initial import.

## Running

```
# Download and clean the data
make csv

# Parse the CSV into JSON
make json

# Generate a pseudo-api from the big JSON documents
make api

# Delete everything
make clean
```
