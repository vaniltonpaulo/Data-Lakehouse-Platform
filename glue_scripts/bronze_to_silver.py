#Some AWS Glue script

import sys
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col

args = getResolvedOptions(sys.argv, ["bronze_bucket", "silver_bucket"])

sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session

bronze_path = f"s3://{args['bronze_bucket']}/source=nyc-taxi/"
silver_path = f"s3://{args['silver_bucket']}/nyc-taxi/"

df = spark.read.parquet(bronze_path)

clean_df = (
    df.dropDuplicates()
    .dropna(subset=["tpep_pickup_datetime", "tpep_dropoff_datetime", "fare_amount"])
    .filter(col("fare_amount") >= 0)
)

clean_df.write.mode("overwrite").parquet(silver_path)

print(f"Processed {clean_df.count()} NYC taxi records to Silver")