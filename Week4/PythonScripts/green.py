import os
import urllib.request
import pandas as pd
import pandas_gbq

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_"

YEARS = [f"{i:02d}" for i in range(2019,2021)]
MONTHS = [f"{i:02d}" for i in range(1,13)]

DOWNLOAD_DIR = "."

def download_file(years,month):
    url = f"{BASE_URL}{years}-{month}.csv.gz"
    file_name = f"green_tripdata_{years}-{month}.csv.gz"
    file_path = os.path.join(DOWNLOAD_DIR, file_name)

    try:
        print(f"Downloading {url} ...")
        urllib.request.urlretrieve(url, file_path)
        print(f"Downloaded: {file_path}")
        return file_path
    
    except Exception as e:
        print(f"Failed to download {url}: {e}")
        return None

def upload_to_bigquery():
    for years in YEARS:
        for month in MONTHS:
            download_file(years, month)

            file_name = f"green_tripdata_{years}-{month}.csv.gz"

            try:
                df = pd.read_csv(file_name, compression = 'gzip')
                
                df["file_name"] = file_name

                df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
                df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])

                print(f"Transformed data for {file_name}")

                pandas_gbq.to_gbq(df, destination_table="data.green_taxidata", project_id="example", if_exists="append")

                print(f"Uploaded {file_name} to BigQuery -> nyc_taxi_data.green_taxidata")

                os.remove(file_name)
                print(f"Removed {file_name} after upload.")


            except Exception as e:
                print(f"Failed for {file_name} :{e}")

upload_to_bigquery()
