from minio import Minio
import urllib.request
import pandas as pd
import sys

prefix_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data' #_2018-01.parquet'

def main():
    client = Minio(
        "localhost:9000",
        secure=False,
        access_key="minio",
        secret_key="minio123"
    )
    bucket: str = "datalake"
    found = client.bucket_exists(bucket)
    if not found:
        return 1
    for obj in client.list_objects(bucket_name=bucket, prefix='yellow_tripdata_'):
        print(obj.object_name)
    # grab_data()
    return 0

def get_filename(years : int, month : int):
    return f"yellow_tripdata_{years}-{'0' if month < 10 else ''}{month}.parquet"

def grab_data() -> None:
    """Grab the data from New York Yellow Taxi

    This method download x files of the New York Yellow Taxi. 
    
    Files need to be saved into "../../data/raw" folder
    This methods takes no arguments and returns nothing.
    """
    for years in range(2023, 2024):
        for month in range(1, 13):
            filename = get_filename(years, month)
            url = f"{prefix_url}/{filename}"
            req = urllib.request.Request(url=url)
            with urllib.request.urlopen(req) as data:
                write_data_minio(filename, data)


def write_data_minio(filename : str, data):
    """
    This method put all Parquet files into Minio
    Ne pas faire cette méthode pour le moment
    """
    client = Minio(
        "localhost:9000",
        secure=False,
        access_key="minio",
        secret_key="minio123"
    )
    bucket: str = "datalake"
    found = client.bucket_exists(bucket)
    if not found:
        client.make_bucket(bucket)
    else:
        print("Bucket " + bucket + " existe déjà")
    client.put_object(bucket, filename, data, length=-1, part_size=10*1024 * 1024)

if __name__ == '__main__':
    sys.exit(main())
