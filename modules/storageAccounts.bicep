@minLength(3)
@maxLength(24)
@description('Name of the Azure Storage Account')
param rssName string

@allowed([
  'appSvcs'
  'files'
  'fileService'
  'vmDiag'
])
@description('Type of Storage Account being deployed')
param type string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
@description('Declares controls the speed and replication of the SA')
param sku string = 'Standard_LRS'

var storageAccountConfig = {
  sku: sku
  kind: 'StorageV2'
  httpsTrafficOnlyEnabled: true
  encryptionState: {
    blob: true
    file: true
  }
  accessTier: 'Hot'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: rssName
  location: resourceGroup().location
  kind: storageAccountConfig.kind
  sku: {
    name: storageAccountConfig.sku
  }
  properties: {
    supportsHttpsTrafficOnly: storageAccountConfig.httpsTrafficOnlyEnabled
    accessTier: storageAccountConfig.accessTier
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: storageAccountConfig.encryptionState.blob
        }
        file: {
          enabled: storageAccountConfig.encryptionState.file
        }
      }
    }
  }
}

output storageAccount object = storageAccount
