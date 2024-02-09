import pandas as pd


# Basic cleansing
def basic_cleansing(df):
    df.drop(columns='__v',  inplace=True)
    df['timestamp_arduino'] = pd.to_datetime(df['timestampArduino'], unit='ms')
    df['timestamp_server'] = pd.to_datetime(df['timestampServer'], unit='ms')
    df['_id'] = df['_id'].astype('str')
    df['epoch_arduino'] = df['timestampArduino']
    df.wifi= pd.to_numeric(df.wifi, errors='coerce')
    df.drop(columns=['timestampArduino', 'timestampServer'], inplace=True)
    return df


# Create boolean column to indicate if data is valid
# Data is valid if it's not within 25 minutes of the last valid data
def create_valid_column(df):
    df.sort_values(by=['composedIdHashed', 'epoch_arduino'], inplace=True)
    df['is_valid'] = False
    
    # Iterate through the DataFrame to mark valid rows.
    last_valid_timestamp = None

    for index, row in df.iterrows():
        if last_valid_timestamp is None:
            # The first row is always valid.
            df.at[index, 'is_valid'] = True
            last_valid_timestamp = row['timestamp_arduino']
            current_compsed_id = row['composedIdHashed']

        else:
            time_elapsed = row['timestamp_arduino'] - last_valid_timestamp
            if time_elapsed.seconds  >= 1500: #25 minutes
                df.at[index, 'is_valid'] = True
                last_valid_timestamp = row['timestamp_arduino']

                current_compsed_id = row['composedIdHashed']

            elif row['composedIdHashed'] != current_compsed_id:
                df.at[index, 'is_valid'] = True 
                current_compsed_id = row['composedIdHashed']
            else:
                df.at[index, 'is_valid'] = False
    return df
