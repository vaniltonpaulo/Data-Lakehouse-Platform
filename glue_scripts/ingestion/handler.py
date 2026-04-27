import json
import os
import urllib.request
from datetime import datetime

import boto3


def lambda_handler(event, context):
    s3 = boto3.client("s3")
    bucket = os.environ["BRONZE_BUCKET"]

    url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet"

    now = datetime.utcnow()
    key = (
        f"source=nyc-taxi/"
        f"year={now.year}/month={now.month:02d}/day={now.day:02d}/"
        f"yellow_tripdata_2024-01.parquet"
    )

    with urllib.request.urlopen(url) as response:
        data = response.read()

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=data,
        ContentType="application/octet-stream",
    )

    return {
        "statusCode": 200,
        "body": json.dumps({"bucket": bucket, "key": key}),
    }