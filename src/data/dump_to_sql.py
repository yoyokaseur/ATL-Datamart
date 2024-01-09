import gc
import os
import sys
import io
from minio import Minio

import pandas as pd
from sqlalchemy import create_engine


def write_data_postgres(dataframe: pd.DataFrame, name : str) -> bool:
    """
    Dumps a Dataframe to the DBMS engine

    Parameters:
        - dataframe (pd.Dataframe) : The dataframe to dump into the DBMS engine

    Returns:
        - bool : True if the connection to the DBMS and the dump to the DBMS is successful, False if either
        execution is failed
    """
    db_config = {
        "dbms_engine": "postgresql",
        "dbms_username": "postgres",
        "dbms_password": "admin",
        "dbms_ip": "localhost",
        "dbms_port": "15432",
        "dbms_database": "nyc_warehouse",
        "dbms_table": "nyc_raw"
    }

    db_config["database_url"] = (
        f"{db_config['dbms_engine']}://{db_config['dbms_username']}:{db_config['dbms_password']}@"
        f"{db_config['dbms_ip']}:{db_config['dbms_port']}/{db_config['dbms_database']}"
    )
    try:
        engine = create_engine(db_config["database_url"])
        with engine.connect():
            success: bool = True
            print("Connection successful! Processing parquet file", name)
            dataframe.to_sql(db_config["dbms_table"], engine, index=False, if_exists='append')
            print(f"Succes to download the file {name} to the table nyc_raw of database nyc_warehouse")

    except Exception as e:
        success: bool = False
        print(f"Error connection to the database: {e}")
        return success

    return success


def clean_column_name(dataframe: pd.DataFrame) -> pd.DataFrame:
    """
    Take a Dataframe and rewrite it columns into a lowercase format.
    Parameters:
        - dataframe (pd.DataFrame) : The dataframe columns to change

    Returns:
        - pd.Dataframe : The changed Dataframe into lowercase format
    """
    dataframe.columns = map(str.lower, dataframe.columns)
    return dataframe

def main() -> None:
    # Extract from Minio
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
    client.list_objects(bucket_name=bucket, prefix='yellow_tripdata_')
    i = 0

    for object in client.list_objects(bucket_name=bucket, prefix='yellow_tripdata_'): #! retry to download the 03
        if i < 2:
            i = i + 1
            continue
        obj = client.get_object( bucket_name=bucket, object_name=object.object_name )
        data = io.BytesIO()
        data.write(obj.read())
        data.seek(0)
        obj.close()
        parquet_df = pd.DataFrame = pd.read_parquet(data, engine='fastparquet')

        clean_column_name(parquet_df)
        if not write_data_postgres(parquet_df, object.object_name):
            del parquet_df
            gc.collect()
            return

        del parquet_df
        gc.collect()


if __name__ == '__main__':
    sys.exit(main())
