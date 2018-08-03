# BuildKite AWS+Kube

```
mikehock/buildkite-agent-aws-kube:latest
```

This is a simple docker image which bundles a few extra utilities into the buildkite agent.

- `aws`
- `kubectl`
- `yq` (yaml processor)

## Configuring AWS

Be sure to give the docker container all the environment variables it needs for the aws cli tools
to authenticate with aws:

```
AWS_DEFAULT_REGION=us-east-1
AWS_ACCESS_KEY_ID=asdf
AWS_SECRET_ACCESS_KEY=qwerty
```

## Configuing Kubectl

How you configure kubectl is up to you. 

The method I've used is to inject a service account token, certificate, and the api server url
commands into the running container via environment variables, then passing them to the 
`--token` and `--server` arguments whenever `kubectl` is called.
