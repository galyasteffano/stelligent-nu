import json
import boto3

def handler(event, context): 

  print(event['body'])

  func_input = json.loads(event['body'])

  dynamo = boto3.resource('dynamodb')

  table = dynamo.Table('MyDynamoTableName')
  
  table.put_item(
    Item=func_input
  )

  table_pks = ["AttName"]
  key_dict = {key: func_input[key] for key in table_pks}

  return {
    'statusCode': 200,
    'body': json.dumps(table.get_item(Key=key_dict))
  }