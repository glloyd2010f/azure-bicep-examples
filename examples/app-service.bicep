param namePrefix string = newGuid()
param appSvcType string {
  default: 'api'
  allowed: [
    'api'
    'function'
    'web'
    'container'
  ]
}
param aspName string = newGuid()
param aspRg string = newGuid()
param storageAccountRg string = newGuid()
param insightsId string = newGuid()
param functionSa string = newGuid()

var sharedInsightsId = 'appliation-insights-instrumentation-key'
var sharedStorageAccount = 'shared-storage-account-name'
var azureConfig=  {
  appConfigId: 'azure-app-configuration-resourceId'
  keyVault: {
    rssId: 'key-vault-resourceId'
  }
  eventGridUri: 'event-grid-uri' // Can be whatever since this is a direct string pass
  managedIdentities: {
    global: {
      reader: 'managed-identity-resourceId'
      writer: 'managed-identity-resourceId'
    }
  }
}

module appSvc '../modules/appSvc.bicep' = {
  name: 'appSvc01'
  params:{
    appSvcNamePrefix: namePrefix
    aspName: aspName
    aspRg: aspRg
    storageAccountRg: storageAccountRg
    type: appSvcType
  appInsightsId: insightsId ?? sharedInsightsId
  functionSa: functionSa ?? sharedStorageAccount
  azureConfig: azureConfig
  }
}