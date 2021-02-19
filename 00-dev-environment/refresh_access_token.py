import boto3
import sys
import configparser
from pathlib import Path
from botocore.exceptions import ClientError

"""
This script takes a profile and authenticator code to get a session token automatically.
Usage "python3 refresh_access_token.py stelligent_labs 564469"
"""

USER_IAM_NAME = "josh.dix.labs"
USER_AWS_ACCOUNT = "324320755747"
USER_MFA_DEVICE_ARN = "arn:aws:iam::" + USER_AWS_ACCOUNT + ":mfa/" + USER_IAM_NAME
AWS_CREDENTIAL_FILE_LOCATION = str(Path.home()) + "/.aws/credentials"

AWS_CRED_FILE_ACCESS_KEY_STRING = "aws_access_key_id"
AWS_CRED_FILE_SECRET_KEY_STRING = "aws_secret_access_key"
AWS_CRED_FILE_SESSION_TOKEN_STRING = "aws_session_token"

INPUT_PROFILE_NAME = sys.argv[1]
SESSION_PROFILE_SUFFIX = "_temp"
SESSION_PROFILE_NAME = INPUT_PROFILE_NAME + SESSION_PROFILE_SUFFIX
INPUT_MFA_CODE = sys.argv[2]

def program_failure(failure_message):
    print(failure_message)
    sys.exit(1)

def main():
    aws_cred_conf_parser = configparser.ConfigParser()
    aws_cred_conf_parser.read(AWS_CREDENTIAL_FILE_LOCATION)

    if INPUT_PROFILE_NAME in aws_cred_conf_parser.sections():
        try:
            sts_client = boto3.client("sts", aws_access_key_id=aws_cred_conf_parser[INPUT_PROFILE_NAME]['aws_access_key_id'], aws_secret_access_key=aws_cred_conf_parser[INPUT_PROFILE_NAME]['aws_secret_access_key'])
        except KeyError:
            program_failure('Access key or secret key not defined for profile.')
        try:
            sts_response = sts_client.get_session_token(SerialNumber=USER_MFA_DEVICE_ARN, TokenCode=INPUT_MFA_CODE)
        except ClientError as e:
            program_failure("Fatal error. received " + e.response['Error']['Code'] + " during sts token generation.")

        aws_cred_conf_parser[SESSION_PROFILE_NAME][AWS_CRED_FILE_ACCESS_KEY_STRING] = sts_response['Credentials']['AccessKeyId']
        aws_cred_conf_parser[SESSION_PROFILE_NAME][AWS_CRED_FILE_SECRET_KEY_STRING] = sts_response['Credentials']['SecretAccessKey']
        aws_cred_conf_parser[SESSION_PROFILE_NAME][AWS_CRED_FILE_SESSION_TOKEN_STRING] = sts_response['Credentials']['SessionToken']
        
        with open(AWS_CREDENTIAL_FILE_LOCATION, 'w') as conf_file:
            aws_cred_conf_parser.write(conf_file)
    else:
        program_failure('Profile ' + INPUT_PROFILE_NAME + ' not found.\nPlease enter a valid profile.')

if __name__ == "__main__":
    main()