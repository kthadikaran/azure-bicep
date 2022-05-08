az login --use-device-code
$rg="smartstim-dev-bicep-rg"
$location="westus"
az group create --name $rg --location $location
az deployment group create --name smartstimulayordeploy --resource-group $rg  --template-file smartstim_deployment.bicep  --parameters smartstim_deployment.parameters.json
az group delete  --resource-group $rg --yes