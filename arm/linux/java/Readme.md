# Java Deployment ARM template Suite

I created the ARM template for Java, however, it works for other languages as well.

# template 

## Premium Linux

`premium-8-dt-template.json`

## AppService Linux

`appservice-8-dt-template.json`

# How to use

## deployment 

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