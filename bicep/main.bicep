param location string = resourceGroup().location
param workloadName string = 'azdevops-agent'
param containerImage string = 'docker.io/lopezleandro03/azdevops-agent-aca:v1'

param azpUrl string
param azpPool string
param azpPoolId string
@secure()
param azpToken string

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    name: 'vnet-${workloadName}'
  }
}

module law 'modules/law.bicep' = {
    name: 'log-analytics-workspace'
    params: {
      location: location
      name: 'law-${workloadName}'
    }
}

module containerAppEnvironment 'modules/environment.bicep' = {
  name: 'container-app-environment'
  params: {
    name: 'cae-${workloadName}'
    location: location
    lawClientId:law.outputs.clientId
    lawClientSecret: law.outputs.clientSecret
    vnetName: 'vnet-${workloadName}'
    infrastructureSubnetId: vnet.outputs.infrastructureSubnetId
    runtimeSubnetId: vnet.outputs.runtimeSubnetId
  }
}

module containerApp 'modules/containerapp.bicep' = {
  name: 'capp-${workloadName}'
  params: {
    name: workloadName
    location: location
    containerAppEnvironmentId: containerAppEnvironment.outputs.id
    containerImage: containerImage
    azpToken: azpToken
    azpUrl: azpUrl
    azpPool: azpPool
    azpPoolId: azpPoolId
  }
}

output fqdn string = containerApp.outputs.fqdn
