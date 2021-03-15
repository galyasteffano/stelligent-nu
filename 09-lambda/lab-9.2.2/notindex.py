import json
import boto3
import gzip
import base64

def handler(event, context): 

  normalized_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))

  print(normalized_data)

  normalized_data['AttName'] = normalized_data['logEvents'][0]['id']

  func_input = normalized_data

  dynamo = boto3.resource('dynamodb')

  table = dynamo.Table('MyDynamoTableName')
  
  table.put_item(
    Item=func_input
  )

  table_pks = ["AttName"]
  key_dict = {key: func_input[key] for key in table_pks}

  return {
    'statusCode': 200,
    'body': table.get_item(Key=key_dict)
  }