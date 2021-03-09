#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
cw_stack_name='lab-8-1-2-jdix-cwinfra'
res_stack_name='lab-8-1-2-jdix-instance'
done="DONE"


if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $cw_stack_name --template-file cw-infra.yaml --parameter-overrides file://vpc_params.json --region us-east-2 --capabilities CAPABILITY_NAMED_IAM
    $aws_sl cloudformation deploy --stack-name $res_stack_name --template-file res.yaml --region us-east-2 --capabilities CAPABILITY_NAMED_IAM
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $res_stack_name --region us-east-2
    $aws_sl cloudformation wait stack-delete-complete --stack-name $res_stack_name
    # $aws_sl cloudformation delete-stack --stack-name $cw_stack_name --region us-east-2
    # $aws_sl cloudformation wait stack-delete-complete --stack-name $cw_stack_name
    echo $done
fi

# xcode-select --install
# brew install awslogs
# awslogs get --profile stelligent_labs_temp --aws-region us-east-2 "josh.dix.c9logs"
# ./lab down # (with cw stack still up)

# awslogs get --profile stelligent_labs_temp --aws-region us-east-2 "josh.dix.c9logs"

# awslogs get --profile stelligent_labs_temp --aws-region us-east-2 "josh.dix.c9logs" | grep josh | grep DELETE
# josh.dix.c9logs 324320755747_CloudTrail_us-east-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR7GYAT4AML","arn":"arn:aws:iam::324320755747:user/josh.dix.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR2C2CSG45","userName":"josh.dix.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"mfaAuthenticated":"true","creationDate":"2021-03-09T13:23:08Z"}}},"eventTime":"2021-03-09T21:44:15Z","eventSource":"cloudformation.amazonaws.com","eventName":"ListStacks","awsRegion":"us-east-2","sourceIPAddress":"74.77.86.69","userAgent":"console.amazonaws.com","requestParameters":{"stackStatusFilter":["CREATE_IN_PROGRESS","UPDATE_COMPLETE","DELETE_FAILED","REVIEW_IN_PROGRESS","ROLLBACK_IN_PROGRESS","UPDATE_ROLLBACK_IN_PROGRESS","CREATE_COMPLETE","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS","ROLLBACK_COMPLETE","ROLLBACK_FAILED","CREATE_FAILED","UPDATE_ROLLBACK_FAILED","UPDATE_COMPLETE_CLEANUP_IN_PROGRESS","UPDATE_IN_PROGRESS","DELETE_IN_PROGRESS","IMPORT_COMPLETE","IMPORT_IN_PROGRESS","IMPORT_ROLLBACK_IN_PROGRESS","IMPORT_ROLLBACK_FAILED","IMPORT_ROLLBACK_COMPLETE"]},"responseElements":null,"requestID":"04cf4846-e877-475b-9729-ecc2961b78e6","eventID":"598fef18-5c31-4568-8f6b-bd3315bda4f1","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"eventCategory":"Management","recipientAccountId":"324320755747"}
# josh.dix.c9logs 324320755747_CloudTrail_us-east-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR7GYAT4AML","arn":"arn:aws:iam::324320755747:user/josh.dix.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR2C2CSG45","userName":"josh.dix.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"mfaAuthenticated":"true","creationDate":"2021-03-09T13:23:08Z"}}},"eventTime":"2021-03-09T21:46:15Z","eventSource":"cloudformation.amazonaws.com","eventName":"ListStacks","awsRegion":"us-east-2","sourceIPAddress":"74.77.86.69","userAgent":"console.amazonaws.com","requestParameters":{"stackStatusFilter":["CREATE_IN_PROGRESS","UPDATE_COMPLETE","DELETE_FAILED","REVIEW_IN_PROGRESS","ROLLBACK_IN_PROGRESS","UPDATE_ROLLBACK_IN_PROGRESS","CREATE_COMPLETE","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS","ROLLBACK_COMPLETE","ROLLBACK_FAILED","CREATE_FAILED","UPDATE_ROLLBACK_FAILED","UPDATE_COMPLETE_CLEANUP_IN_PROGRESS","UPDATE_IN_PROGRESS","DELETE_IN_PROGRESS","IMPORT_COMPLETE","IMPORT_IN_PROGRESS","IMPORT_ROLLBACK_IN_PROGRESS","IMPORT_ROLLBACK_FAILED","IMPORT_ROLLBACK_COMPLETE"]},"responseElements":null,"requestID":"b833046b-2a2f-44d2-a71d-9154339b4ebf","eventID":"93904e10-3475-4fd3-b40c-e143282e412a","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"eventCategory":"Management","recipientAccountId":"324320755747"}
# josh.dix.c9logs 324320755747_CloudTrail_us-east-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR7GYAT4AML","arn":"arn:aws:iam::324320755747:user/josh.dix.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR2C2CSG45","userName":"josh.dix.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"mfaAuthenticated":"true","creationDate":"2021-03-09T13:23:08Z"}}},"eventTime":"2021-03-09T21:47:15Z","eventSource":"cloudformation.amazonaws.com","eventName":"ListStacks","awsRegion":"us-east-2","sourceIPAddress":"74.77.86.69","userAgent":"console.amazonaws.com","requestParameters":{"stackStatusFilter":["CREATE_IN_PROGRESS","UPDATE_COMPLETE","DELETE_FAILED","REVIEW_IN_PROGRESS","ROLLBACK_IN_PROGRESS","UPDATE_ROLLBACK_IN_PROGRESS","CREATE_COMPLETE","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS","ROLLBACK_COMPLETE","ROLLBACK_FAILED","CREATE_FAILED","UPDATE_ROLLBACK_FAILED","UPDATE_COMPLETE_CLEANUP_IN_PROGRESS","UPDATE_IN_PROGRESS","DELETE_IN_PROGRESS","IMPORT_COMPLETE","IMPORT_IN_PROGRESS","IMPORT_ROLLBACK_IN_PROGRESS","IMPORT_ROLLBACK_FAILED","IMPORT_ROLLBACK_COMPLETE"]},"responseElements":null,"requestID":"7adc202c-2b52-4f62-81ae-723ef5c6410a","eventID":"2447614e-c5e8-452a-b0ad-fc90f57210bc","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"eventCategory":"Management","recipientAccountId":"324320755747"}
# josh.dix.c9logs 324320755747_CloudTrail_us-east-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR7GYAT4AML","arn":"arn:aws:iam::324320755747:user/josh.dix.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR2C2CSG45","userName":"josh.dix.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"mfaAuthenticated":"true","creationDate":"2021-03-09T13:23:08Z"}}},"eventTime":"2021-03-09T21:45:15Z","eventSource":"cloudformation.amazonaws.com","eventName":"ListStacks","awsRegion":"us-east-2","sourceIPAddress":"74.77.86.69","userAgent":"console.amazonaws.com","requestParameters":{"stackStatusFilter":["CREATE_IN_PROGRESS","UPDATE_COMPLETE","DELETE_FAILED","REVIEW_IN_PROGRESS","ROLLBACK_IN_PROGRESS","UPDATE_ROLLBACK_IN_PROGRESS","CREATE_COMPLETE","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS","ROLLBACK_COMPLETE","ROLLBACK_FAILED","CREATE_FAILED","UPDATE_ROLLBACK_FAILED","UPDATE_COMPLETE_CLEANUP_IN_PROGRESS","UPDATE_IN_PROGRESS","DELETE_IN_PROGRESS","IMPORT_COMPLETE","IMPORT_IN_PROGRESS","IMPORT_ROLLBACK_IN_PROGRESS","IMPORT_ROLLBACK_FAILED","IMPORT_ROLLBACK_COMPLETE"]},"responseElements":null,"requestID":"5b2a497a-c249-4be2-a339-07e3c3ed4932","eventID":"c0d491a6-9cf2-4d53-939a-f6da127fe4c6","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"eventCategory":"Management","recipientAccountId":"324320755747"}

