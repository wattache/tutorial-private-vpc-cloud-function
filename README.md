# tutorial-cloud-workflow-bigquery
Chain your data transformations with BigQuery, Cloud Workflow and Cloud Function.

## I - Useful links

- Kaggle data used to feed CloudSQL table : https://www.kaggle.com/datasets/ankanhore545/100-highest-valued-unicorns

## II - Setup

In your GCP project, enable the following APIs :

| Name                                      | Google API Services                       |
|-------------------------------------------|-------------------------------------------|
| Identity and Access Management (IAM) API  | iam.googleapis.com                        |
| Serverless VPC Access API                 | vpcaccess.googleapis.com                  |
| Cloud Functions API                       | cloudfunctions.googleapis.com             |
| Cloud Build API                           | cloudbuild.googleapis.com                 |
| Cloud Build API                           | cloudbuild.googleapis.com                 |
| Cloud Build API                           | cloudbuild.googleapis.com                 |
| Cloud Build API                           | cloudbuild.googleapis.com                 |



Initiate your ```gcloud``` SDK configuration :
```sh
gcloud init
```

Export a few environement variables to ease the further actions :
```sh
export PROJECT_ID=$(gcloud config list --format=json | jq -r .core.project)
export TERRAFORM_SA_NAME=terraform-deployer
```

Create a service account to execute Terraform code :
```sh
gcloud iam service-accounts create ${TERRAFORM_SA_NAME} \
    --description="Service account used to deploy platform with Terraform" \
    --display-name="Terraform deployer"
```

From the console you should get the following succes message : 
```Created service account [terraform-deployer].```

Create and download a key associated with it :
```sh
gcloud iam service-accounts keys create my-key.json \
    --iam-account="${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
```

You should get the following prompt : 
```created key [***] of type [json] as [my-key.json] for [terraform-deployer@***.iam.gserviceaccount.com]```

In order to conform to the least-priviledge principle, create a custom role containing the necessary permissions for Terraform to apply :
:warning: ```You'll need the following role : roles/iam.roleAdmin``` :warning:
```sh
export ROLE_ID=terraform_builder
gcloud iam roles create ${ROLE_ID} --project=${PROJECT_ID} --file=terraform_custom_role.yaml
```

Bind your custom role :
```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="projects/${PROJECT_ID}/roles/${ROLE_ID}"
```

You will also need to add a predefined role ```roles/vpcaccess.admin```. According ```roles/vpcaccess.admin``` still 
renders blurry errors in the console :
```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/vpcaccess.admin"
```

:warning: This does not respect the least-priviledges principle. If you want to respect it, do not do these bindings, apply Terraform
and add the required permissions to a custom role. Do not hesitate to open a PR to improve this. :warning:

Export the so called ```GOOGLE_APPLICATION_CREDENTIALS``` environment variable to match your created key file :
```sh
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/my-key.json
```

Initiate your ```terraform``` configuration :
```sh
cd terraform
```
and 

```sh
terraform init
```

:warning: Please be aware that the Terraform state is local. No Cloud synchronization is made here. :warning:

If you want, look at the execution plan :
```sh
terraform plan -var="project_id=${PROJECT_ID}"
```

And apply your changes : 
```sh
terraform apply -var="project_id=${PROJECT_ID}" -auto-approve
```

To destroy your platform :
```sh
terraform destroy -var="project_id=${PROJECT_ID}" -auto-approve
```
