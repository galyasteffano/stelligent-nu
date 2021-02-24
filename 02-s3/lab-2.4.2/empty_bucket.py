import sys, boto3

BUCKET = sys.argv[1]

s3 = boto3.resource('s3')
bucket = s3.Bucket(BUCKET)
bucket.object_versions.delete()

#bucket.delete()