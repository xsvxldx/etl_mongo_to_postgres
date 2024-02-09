from config import config

import pytz
from datetime import datetime

from src.extract.stations_extractor import get_data

from src.transform.data_wrangler import basic_cleansing, create_valid_column

from src.loader.warehouse_loader import max_epoch, max_valid_epoch, pg_engine, upload_to_postgres, update_log


def run():
    # Extract
    print(f"Getting  from mongodb")
    df = get_data(max_valid_epoch)
    extraction_timestamp = datetime.now(pytz.timezone('UTC'))

    # Transform
    print(f"Transforming data. Basic cleansing")
    df = basic_cleansing(df)

    print(f"Creating is_valid column")
    df = create_valid_column(df)

    if max_epoch != 0:
        print(f"Filtering dataframe to include only new rows")
        df = df[df['epoch_arduino'] > max_epoch]

    # Load
    print(f"Uploading to postgres")
    status, message = upload_to_postgres(df, pg_engine, config.target_table)

    # Update etl_log
    print(f"Updating ETL log")
    update_log(extraction_timestamp, config.target_table, df.shape[0], status, message)

    print(f"ETL process finished.\nStatus: {status}.\nMessage: {message}\n\nTerminating program")


if __name__ == "__main__":
    run()
    #test_function()


