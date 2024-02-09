import json

# PostgreSQL config
with open('config/postgres_config.json') as f:
    postgres_config = json.load(f)

# MongoDB credentials
with open('config/mongodb_config.json') as f:
    mongo_config = json.load(f)