import boto3
import sys

client = boto3.client('cloudformation')

template_body = open('application.yaml', 'r').read()

try:
  client.validate_template(TemplateBody=template_body)
  print('validation passed!')
except:
  print('validation failed!')
  sys.exit(1)