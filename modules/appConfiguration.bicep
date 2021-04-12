@minLength(1)
@maxLength(50)
@description('Name of the Azure App Configuration')
param appConfigName string

@allowed([
  'Free'
  'Standard'
])
@description('Azure App Configuration SKU')
param sku string = 'Standard'

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2020-06-01' = {
  name: appConfigName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
  sku: {
    name: sku
  }
}

output appConfiguration object = appConfig
