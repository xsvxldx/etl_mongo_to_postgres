from sqlalchemy import create_engine, func
from sqlalchemy.orm import sessionmaker
from config.config import postgres_config
from db.orm import SubsetMetadata, EtlLog


# PostgreSQL connection
pg_connection_string = (
    f'postgresql://{postgres_config["username"]}:'
    f'{postgres_config["password"]}@'
    f'{postgres_config["host"]}/'
    f'{postgres_config["database"]}'
)
pg_engine = create_engine(pg_connection_string)

# SQLAlchemy session
Session = sessionmaker(bind=pg_engine)
session = Session()


# Get latest loaded epoch from PostgreSQL
max_valid_epoch = session.query(func.max(SubsetMetadata.epoch_arduino)).filter(SubsetMetadata.is_valid == True).scalar()
max_epoch = session.query(func.max(SubsetMetadata.epoch_arduino)).scalar()

# If there is no valid timestamp -table is empty yet-, set the epoch to 0
if max_valid_epoch is None:
    max_valid_epoch = 0
    max_epoch = 0


def upload_to_postgres(df, engine, target_table):
    # Upload to postgres
    try:
        df.to_sql(postgres_config["target_table"], engine, schema='stations', if_exists='append', index=False)
        #print(f"Uploaded {i} to postgres")
        status = 'success'
        message = 'Data uploaded successfully'

    except Exception:
        print("Error uploading to postgres")
        status = 'error'
        message = 'Error uploading to postgres'
    
    return status, message

def update_log(timestamp_utc, table, rows, status, message):
    # Create log data
    log_data = {'timestamp': timestamp_utc, 'table': table, 'rows': rows, 'status': status, 'message': message}
    etl_log_instance = EtlLog(**log_data)
    # Add log data to session
    session.add(etl_log_instance)
    # Commit the transaction to the database
    session.commit()

def test_function():
    print("This is a test function")
    print (pg_engine)
    print(session)
    print(max_valid_epoch)