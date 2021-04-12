@minLength(1)
@maxLength(40)
@description('Name of the Azure App Service Plan')
param planName string

@allowed([
  'windows'
  'linux'
])
@description('The OS Type of App Service Plan for the Azure App Services')
param hostingPlatform string = 'linux'

@allowed([
  'S1'
  'S2'
  'S2'
  'P1v2'
  'P2v2'
  'P3v2'
  'P1v3'
  'P2v3'
  'P3v3'
])
@description('The Size of the Backend Servers for the Azure App Service Plan')
param sku string

@description('The current number of instances assigned to the Azure App Service Plan')
param capacity int = 1

@description( 'If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

var aspConfig = {
  reserved: ((toLower(hostingPlatform) == 'linux') ? true : false)
  perSiteScaling: ((perSiteScaling == true) ? true : false)
  capacity: capacity
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: planName
  location: resourceGroup().location
  sku: {
    name: sku
    capacity: aspConfig.capacity
  }
  properties: {
    reserved: aspConfig.reserved
    perSiteScaling: aspConfig.perSiteScaling
  }
}

output appServicePlan object = appServicePlan
