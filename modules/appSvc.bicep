// Parameters Section
param rssPrefix string {
    minLength: 2
    maxLength: 56
}
param aspName string
param aspRg string
param storageAccountRg string
param type string {
    allowed: [
        'api'
        'function'
        'web'
        'container'
    ]
}
param appInsightsId string
param functionSa string
param azureConfig object

// Variables Section
var environment =  toLower(split(rssPrefix, '-')[2])
var application =  toLower(split(rssPrefix, '-')[3])
var serviceName =  toLower(split(rssPrefix, '-')[4])
var resourceNames = { // Variables for Resource Names
  appSvc: {
    api: '${rssPrefix}-Api'
    web: '${rssPrefix}-Web'
    function: '${rssPrefix}-Fun'
    container: '${rssPrefix}-Wac'
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

// Resources Section
resource apiApp 'Microsoft.Web/sites@2020-06-01' = {
    name: resourceNames.appSvc.api
    location: resourceGroup().location
    kind: 'api'
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
    identity: {
        type: 'SystemAssigned'
    }
}