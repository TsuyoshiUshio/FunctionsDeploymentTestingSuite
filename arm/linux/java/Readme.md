# Java Deployment ARM template Suite

I created the ARM template for Java, however, it works for other languages as well.

# template 

## Premium Linux

`premium-8-dt-template.json`

## AppService Linux

`appservice-8-dt-template.json`

# How to use

## Deploy Function App 

## Prerequisite

* Install Azure CLI
* Login and set the target subscription

```bash
az login
az account set -s <YOUR_TARGET_SUBSCRIPTION>
```

## Deploy premium linux function with Java 8

```bash
./deploy.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX> 
```

## Deploy AppService linux function with Java 8

```bash
./deploy.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX> -t appservice-8-dt-template.json 
```

## Deploy premium linux function with Java 11 with location

```bash
./deploy.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX> -f "Java|11" -l westus2
```

## Delete the resource

```bash
./deploy.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX> -d true
```

## Reference 

```bash
./deploy.sh
```

## Create and Deploy Java HttpTrigger sample to the Function App

### Java 8 sample 

```bash
$ ./create_and_deploy_java_app.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX>
```

### Java 11 sample 

```bash
$ ./create_and_deploy_java_app.sh -g <RESOURCE_GROUP_NAME> -n <FUNCTION_APP_PREFIX> -v 11
```

