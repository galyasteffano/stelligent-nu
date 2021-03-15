import boto3
import json
from boto3.dynamodb.conditions import Key

def handler(event, context):
  
  query = json.loads(event['body'])['query']

  dynamo = boto3.client('dynamodb', region_name='us-east-2')

  table_scan = dynamo.scan(TableName='MyDynamoTableName')

  matched_results = []

  for item in table_scan['Items']:
    for event in item['logEvents']['L']:
      if event['M']['message']['S'].find("\"bucketName\":\"" + query + "\"") != -1:
        matched_results.append(event['M']['message']['S'])

  return {
    'statusCode': 200,
    'body': json.dumps(matched_results)
  }