#!/bin/bash


# not needed from cloud9? didn't /api/ endpoint didn't exist anyways. seems to use IMDSv1 vs IMDSv2
# TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
# && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/



curl http://169.254.169.254/latest/meta-data/api-id
curl http://169.254.169.254/latest/meta-data/instance-type
curl http://169.254.169.254/latest/meta-data/public-ipv4
curl http://169.254.169.254/latest/meta-data/security-groups
curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:38:12:84:68:0c/subnet-id


