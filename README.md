# Serf Joiner Tester

Serf is a HashiCorp tool used for cluster-membership, failure detection, and orchestration.
It is distributed in nature and highly available. [Documentation](https://serf.io).

There aren't very many good examples of using serf in kuberenetes, so this repository
sets out to demonstrate how serf can be used inside kubernetes. What might make
this useful for some and not useful for others is that it handles member discovery
using DynamoDB instead of kubernetes-native constructs. Discovery is handled this
way because I want to demonstrate how a cross-architecture serf cluster can discover
and join nodes across multiple and heterogeneous architectures (e.g. some nodes
in kubernetes and some nodes on EC2).

It will be tested on minikube using a deployment. For simplicity,
AWS credentials will be provided using programatic access keys (sad!).
Please don't ever do this in real life.
