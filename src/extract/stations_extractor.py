import pymongo
from config.config import mongo_config
import pandas as pd

# MongoDB connection
mongo_client = pymongo.MongoClient(
    f"mongodb+srv://{mongo_config['username']}:"
    f"{mongo_config['password']}@"
    f"{mongo_config['host']}/"
    f"{mongo_config['database']}?retryWrites=true&w=majority")

mongo_db = mongo_client.get_database(mongo_config['database'])

# MongoDB collections
metadatas_collection = mongo_db.get_collection(mongo_config['source_collection'])


def get_data(max_valid_epoch: int):
    # Get data from MongoDB
    data_list = list(metadatas_collection.find({'client': mongo_config['client'],
                                                     'project': mongo_config['project'],
                                                     'timestampArduino': {
                                                        "$gte": max_valid_epoch
                                                     }}))
    df = pd.DataFrame(data_list)
    return df