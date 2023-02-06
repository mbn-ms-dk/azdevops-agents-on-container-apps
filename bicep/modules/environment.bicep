param name string
param location string
param vnetName string
param infrastructureSubnetId string
param runtimeSubnetId string
param lawClientId string
@secure()
param lawClientSecret string

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: 'env-${name}'
  location: location
  tags: {
    owner: 'Leandro'
    workload: 'AzureDevOps-Agents'
  }
  sku: {
    name: 'Consumption'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: lawClientId
        sharedKey: lawClientSecret
      }
    }
    // customDomainConfiguration: {
    //   certificatePassword: any()
    //   certificateValue: any()
    //   dnsSuffix: 'string'
    // }
    // daprAIConnectionString: 'string'
    // daprAIInstrumentationKey: 'string'
    vnetConfiguration: {
      internal: false
      infrastructureSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, infrastructureSubnetId)
      dockerBridgeCidr: '10.2.0.1/16'
      platformReservedCidr: '10.1.0.0/16'
      platformReservedDnsIP: '10.1.0.2'
      // runtimeSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, runtimeSubnetId)
    }
    // workloadProfiles: [
    //   {
    //     maximumCount: int
    //     minimumCount: int
    //     workloadProfileType: 'string'
    //   }
    // ]
    // zoneRedundant: bool
  }
}

output id string = containerAppEnvironment.id
