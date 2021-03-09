#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
export AWS_PAGER=''
export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-5-4-4-jdix'

done="DONE"

if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]] ; then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]; then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM
    $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    # aws-sl ec2 create-image --instance-id i-0511836f00d4cbcd7 --name "jdix-su-lab-5-4-4"  
    # {
    #     "ImageId": "ami-02a5bd69d51bc5050"
    # }

    echo $done
elif [ $1 == 'down' ]; then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi


#  lab-5.4.4 % ssh -i keys/josh.dix.labs.mac.keypair.useast2.pem ubuntu@3.17.112.210
# The authenticity of host '3.17.112.210 (3.17.112.210)' can't be established.
# ECDSA key fingerprint is SHA256:s9ZwXWqfQC7gzRWlgariHVnq+pFZ7meKFoTE+0C5y2o.
# Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added '3.17.112.210' (ECDSA) to the list of known hosts.
# Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-1122-aws x86_64)

#  * Documentation:  https://help.ubuntu.com
#  * Management:     https://landscape.canonical.com
#  * Support:        https://ubuntu.com/advantage

# 0 packages can be updated.
# 0 of these updates are security updates.

# New release '18.04.5 LTS' available.
# Run 'do-release-upgrade' to upgrade to it.


# Last login: Fri Mar  5 02:46:51 2021 from 74.77.86.69
# To run a command as administrator (user "root"), use "sudo <command>".
# See "man sudo_root" for details.

# ubuntu@ip-10-10-0-77:~$ ls
# hello-from-the-other-side