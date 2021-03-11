


aws-sl logs put-retention-policy --log-group-name josh.dix.c9logs --retention-in-days 60

aws-sl logs describe-log-groups --log-group-name josh.dix.c9logs
# {
#     "logGroups": [
#         {
#             "logGroupName": "josh.dix.c9logs",
#             "creationTime": 1615296476938,
#             "retentionInDays": 60,
#             "metricFilterCount": 0,
#             "arn": "arn:aws:logs:us-east-2:324320755747:log-group:josh.dix.c9logs:*",
#             "storedBytes": 0
#         }
#     ]
# }

aws-sl logs put-retention-policy --log-group-name josh.dix.c9logs --retention-in-days 3653 
aws-sl logs describe-log-groups --log-group-name josh.dix.c9logs                          
# {
#     "logGroups": [
#         {
#             "logGroupName": "josh.dix.c9logs",
#             "creationTime": 1615296476938,
#             "retentionInDays": 3653,
#             "metricFilterCount": 0,
#             "arn": "arn:aws:logs:us-east-2:324320755747:log-group:josh.dix.c9logs:*",
#             "storedBytes": 0
#         }
#     ]
# }