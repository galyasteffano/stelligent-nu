

sudo apt install python-pip -y
pip install awslogs

awslogs get josh.dix.c9logs

export AWS_REGION=us-east-2
awslogs get josh.dix.c9logs

awslogs get josh.dix.c9logs --start='5m'
awslogs get josh.dix.c9logs --start='20m'
awslogs get josh.dix.c9logs --start='1 hour'