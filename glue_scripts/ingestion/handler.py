import json
import os
from datetime import datetime

import boto3


def lambda_handler(event, context):
    s3 = boto3.client("s3")
    bucket = os.environ["BRONZE_BUCKET"]

    now = datetime.utcnow()
    key = (
        f"source=test-ingestion/"
        f"year={now.year}/month={now.month:02d}/day={now.day:02d}/"
        f"sample.json"
    )

    body = {
        "message": "hello from lambda",
        "created_at": now.isoformat(),
        "event": event,
    }

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=json.dumps(body),
        ContentType="application/json",
    )

    return {
        "statusCode": 200,
        "body": json.dumps({"bucket": bucket, "key": key}),
    }