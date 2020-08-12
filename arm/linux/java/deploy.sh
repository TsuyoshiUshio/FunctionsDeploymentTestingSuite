#!/bin/bash

usage() { echo "Usage: deploy.sh -g <resourceGroup> -n <baseName> -l <location>(optional) -f <linuxFxVersion> -r <functionWorkerRuntime> -t <templateFile>(optional) -d <delete command>" 1>&2; exit 1;}

declare resrouceGroup=""
declare baseName=""
declare location="centraluseuap"
declare templateFile="premium-8-dt-template.json"
declare linuxFxVersion="Java|8"
declare functionWorkerRuntime="java"
declare delete=""

# Initialize parameters specified from command line
while getopts ":g:n:l:t:d:" arg; do
    case "${arg}" in
        g)
            resourceGroup=${OPTARG}
        ;;
        n)
            baseName=${OPTARG}
        ;;
        l)
            location=${OPTARG}
        ;;
        t)
            templateFile=${OPTARG}
        ;;
        r)
            functionWorkerRuntime=${OPTARG}
        ;;
        f)  
            linuxFxVersion=${OPTARG}
        ;;
        d)
            delete=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo -n $(( $RANDOM % 10 ))
}

number="$(randomChar;randomChar;randomChar;randomNum;)"


declare subscriptionId=`az account show | jq ".id" | xargs`
declare deploymentName="${baseName}deploymnet"
declare functionAppName="${baseName}-app"
declare hostingPlanName="${baseName}plan"
declare storageAccountName="${baseName}${number}"
declare appInsightsName="${baseName}"

if [[ -z "$resourceGroup" ]]; then
    echo "Please specify a resouceGroup"
    usage
fi

if [[ ! -z "$delete" ]]; then
    echo "deleting... (az deployment group delete -n $deploymentName -g $resourceGroup)"
    az deployment group delete -n $deploymentName -g $resourceGroup
    exit 0
fi

if [[ -z "$baseName" ]]; then
    echo "Please specify baseName"
    usage
fi

if [ `az group exists -n $resourceGroup -o tsv` == false ]; then
    echo "Resource group with name" $resourceGroup "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        echo "0-Provision Resource Group (az group create --name $resourceGroup --location $location)"
        az group create --name $resourceGroup --location "$location"
    )
else
    echo "Using existing resource group..."
fi

echo "SubscriptionId : ${subscriptionId}"

echo "Deploying Function App..."

echo "1-Provision FunctionApp (az group deployment create --name ${deploymentName} --resource-group $resourceGroupName --template-file $templateFile --parameters subscriptionId=$subscriptionId serverFarmResourceGroup=$resourceGroup name=$functionAppName location="${location}" hostingPlanName=$hostingPlanName storageAccountName=$storageAccountName appInsightsName=$appInsightsName linuxFxVersion=$linuxFxVersion  functionWorkerRuntime=$functionWorkerRuntime)"
az deployment group create \
    --name ${deploymentName} \
    --resource-group $resourceGroup \
    --template-file $templateFile \
    --parameters subscriptionId=$subscriptionId serverFarmResourceGroup=$resourceGroup name=$functionAppName location="${location}" hostingPlanName=$hostingPlanName storageAccountName=$storageAccountName appInsightsName=$appInsightsName linuxFxVersion="$linuxFxVersion" functionWorkerRuntime=$functionWorkerRuntime

