#Some AWS Glue script

import sys
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ["bronze_bucket", "silver_bucket"])

sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session

bronze_path = f"s3://{args['bronze_bucket']}/source=test-ingestion/"
silver_path = f"s3://{args['silver_bucket']}/test-ingestion/"

df = spark.read.json(bronze_path)

clean_df = df.dropDuplicates()

clean_df.write.mode("overwrite").parquet(silver_path)

print(f"Processed {clean_df.count()} records from Bronze to Silver")