#! /bin/bash
set -e

BUILD_TAG=$1
DOCKER_PROJECT=$2
ORG=$3
EB_ENV=$4
APP_NAME=$EB_ENV

DOCKERRUN_FILE=Dockerrun.aws.json

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

# variable substitutions
sed -e "s/<TAG>/$BUILD_TAG/" \
    -e "s/<ORG>/$ORG/" \
    -e "s/<DOCKER_PROJECT>/$DOCKER_PROJECT/" \
    < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip -r $DOCKERRUN_FILE.zip $DOCKERRUN_FILE

echo "copying dockerrun file to s3 bucket..."
aws s3 cp $DOCKERRUN_FILE.zip s3://$EB_BUCKET/$EB_ENV/$DOCKERRUN_FILE.zip
echo "dockerrun file copied"

echo "creating elasticbeanstalk application version..."
aws elasticbeanstalk create-application-version --application-name $APP_NAME \
  --version-label $BUILD_TAG --source-bundle S3Bucket=$EB_BUCKET,S3Key=$EB_ENV/$DOCKERRUN_FILE.zip \
  --region us-east-1
echo "elasticbeanstalk application version created"

# Update Elastic Beanstalk environment to new version
echo "deploying elasticbeanstalk application..."
aws elasticbeanstalk update-environment --environment-name $EB_ENV \
    --version-label $BUILD_TAG --region us-east-1
echo "elasticbeanstalk application deployed"
