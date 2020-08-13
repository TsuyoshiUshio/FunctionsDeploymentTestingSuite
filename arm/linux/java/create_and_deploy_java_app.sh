#!/bin/bash

usage() { echo "Usage: deploy.sh -g <resourceGroup> -n <baseName> -v <java_version>" 1>&2; exit 1;}

declare resourceGroup=""
declare baseName=""
declare javaVersion="1.8"

# Initialize parameters specified from command line
while getopts ":g:n:v:" arg; do
    case "${arg}" in
        g)
            resourceGroup=${OPTARG}
        ;;
        n)
            baseName=${OPTARG}
        ;;
        v)
            javaVersion=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$resourceGroup" ]]; then
    echo "Please specify a resouceGroup"
    usage
fi

if [[ -z "$baseName" ]]; then
    echo "Please specify baseName"
    usage
fi

testcmd () {
    command -v "$1" > /dev/null
}

verify () {
    if testcmd "$1"; then
       echo "$1 is in the path"
    else 
       echo "$1 in not in the path. Please install $1"
       exit 1
    fi
}

verify mvn
verify az
verify zip

mvn archetype:generate \
  -DarchetypeGroupId=com.microsoft.azure \
  -DarchetypeArtifactId=azure-functions-archetype \
  -DinteractiveMode=false \
  -DgroupId=com.fabrikam \
  -DartifactId=fabrikam-functions \
  -Dversion=1.0-SNAPSHOT \
  -Dpackage=com.fabrikam

pushd .

# Build sample functions
cd fabrikam-functions
mvn clean package -DfunctionAppName=sample

# packaging as a zip
cd target/azure-functions/sample
zip -r -q sample . 

# deploy the app to the function app
az functionapp deployment source config-zip -g ${resourceGroup} -n ${baseName}-app --src sample.zip 

popd

