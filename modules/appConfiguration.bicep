param appConfigName string {
  minLength: 5
  maxLength: 50
  metadata: {
    description: 'Name of the Azure App Config'
  }
}
param sku string {
  allowed: [
    'Free'
    'Standard'
  ]
  metadata: {
    description: 'Azure App Configuration SKU'
  }
  default: 'Standard'
}

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