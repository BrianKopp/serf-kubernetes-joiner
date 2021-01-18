# Serf Joiner Tester

Serf is a HashiCorp tool used for cluster-membership, failure detection, and orchestration.
It is distributed in nature and highly available. [Documentation](https://serf.io).

There aren't very many good examples of using serf in kuberenetes/docker, so this repository
sets out to demonstrate how serf can be used inside kubernetes. What might make
this useful for some and not useful for others is that it handles member discovery
using DynamoDB instead of kubernetes-native constructs. Discovery is handled this
way because I want to demonstrate how a cross-architecture serf cluster can discover
and join nodes across multiple and heterogeneous architectures (e.g. some nodes
in kubernetes and some nodes on EC2).

It will be tested on minikube using a deployment. For simplicity,
AWS credentials will be provided using programatic access keys (sad!).
Please don't ever do this in real life.

## Methodology

This will follow the docker & unix principle of single-purpose. Thus, there
will be a couple docker containers, each doing something similar. The first docker
container will run the serf agent and that's it. The second docker container will report
it's IP to DynamoDB. The third docker container will monitor the member list, and
whenever the member list is empty (except itself), it will attempt to connect to
other nodes that have reported in to DynamoDB.

## Resources

### AWS DynamoDB Table

You'll need an AWS DynamoDB table. Create it using the following AWS CLI command:

```sh
aws create-table \
    --table-name testserfmembers \
    --attribute-definitions AttributeName=ip,AttributeType=S AttributeName=ttl,AttributeType=N \
    --key-schema AttributeName=ip,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
aws update-time-to-live \
    --table-name testserfmembers \
    --time-to-live-specification Enabled=true,AttributeName=ttl
```

### AWS IAM Policy

You'll need an AWS IAM user or role with the following policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:Scan"
            ],
            "Resource": [
                "arn:aws:dynamodb:<YOUR_REGION>:<YOUR_ACCOUNT>:table/testserfmembers",
                "arn:aws:dynamodb:<YOUR_REGION>:<YOUR_ACCOUNT>:table/testserfmembers/index/*"
            ]
        }
    ]
}
```

For simplicity, and since this is just a demonstration app, I created IAM user
credentials. Doing IAM role stuff locally on minikube is a big pain.

