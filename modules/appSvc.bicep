@minLength(2)
@maxLength(56)
@description('Prefix of the Azure App Service')
param appSvcNamePrefix string

param aspName string
param aspRg string
param storageAccountRg string

@description('Type of the Azure App Service')
@allowed([
  'api'
  'function'
  'web'
  'container'
])
param type string

param appInsightsId string
param functionSa string
param azureConfig object

var environment =  toLower(split(appSvcNamePrefix, '-')[2])
var application =  toLower(split(appSvcNamePrefix, '-')[3])
var serviceName =  toLower(split(appSvcNamePrefix, '-')[4])
var resourceNames = { // Variables for Resource Names
  appSvc: {
    api: '${appSvcNamePrefix}-Api'
    web: '${appSvcNamePrefix}-Web'
    function: '${appSvcNamePrefix}-Fun'
    container: '${appSvcNamePrefix}-Wac'
  }
}
var appServiceConfig = {
  defaultDocuments: [
    'hostingstart.html'
    'default.aspx'
    'index.html'
  ]
  clientAffinityEnabled: false
  netFrameworkVersion: 'v4.0'
  phpVersion: '5.6'
  processAs32bit: false
  alwaysOn: true
  minTlsVersion: '1.2'
  ftpsState: 'Disabled'
  httpsOnly: true
}
var resourceIDs = { // Variables for Resource IDs
  appServicePlan: resourceId(subscription().subscriptionId, aspRg, 'Microsoft.Web/serverfarms', aspName)
  storageAccounts: {
    appSvcs: resourceId(subscription().subscriptionId, storageAccountRg, 'Microsoft.Storage/storageAccounts', functionSa)
  }
}

resource appSvc 'Microsoft.Web/sites@2020-06-01' = {
  name: resourceNames.appSvc[type]
  location: resourceGroup().location
  kind: 'api'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceIDs.appServicePlan
    clientAffinityEnabled: appServiceConfig.clientAffinityEnabled
    httpsOnly: appServiceConfig.httpsOnly
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(appInsightsId, '2020-02-02-preview').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${reference(appInsightsId, '2020-02-02-preview').InstrumentationKey}'
        }
        {
          name: 'AppConfigUri'
          value: toLower(reference(azureConfig.appConfigId, '2020-07-01-preview').endpoint)
        }
        {
          name: 'KeyVaultUri'
          value: toLower(reference(azureConfig.keyVault.rssId, '2019-09-01').endpoint)
        }
        {
          name: 'EventGridUri'
          value: toLower(azureConfig.eventGridUri)
        }
        {
          name: 'GlobalReaderClientId'
          value: reference(azureConfig.managedIdentities.global.reader, '2018-11-30').clientId
        }
        {
          name: 'GlobalWriterClientId'
          value: reference(azureConfig.managedIdentities.global.writer, '2018-11-30').clientId
        }
        {
          name: 'Environment'
          value: environment
        }
        {
          name: 'Application'
          value: application
        }
        {
          name: 'AzureAppConfig_AppLabel'
          value: '${environment}.${application}.${serviceName}'
        }
        {
          name: 'AzureAppConfig_Uri'
          value: toLower(reference(azureConfig.appConfigId, '2020-07-01-preview').endpoint)
        }
      ]
      netFrameworkVersion: appServiceConfig.netFrameworkVersion
      phpVersion: appServiceConfig.phpVersion
      use32BitWorkerProcess: appServiceConfig.processAs32bit
      alwaysOn: appServiceConfig.alwaysOn
      defaultDocuments: appServiceConfig.defaultDocuments
      minTlsVersion: appServiceConfig.minTlsVersion
      ftpsState: appServiceConfig.ftpsState
    }
  }
}

output appService object = appSvc
