@minLength(1)
@maxLength(260)
@description('Name of the Application Insights')
param rssName string

@allowed([
  'web'
  'other'
])
@description('Enter the application type')
param type string = 'web'

@description('Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.')
param samplingPercentage int = 100

@description('Disable IP masking.')
param disableIpMasking bool = false

@description('Purge data immediately after 30 days.')
param purgeDataOn30Days bool = false

@description('ResourceId of the log analytics workspace which the data will be ingested to.')
param logAnalyticsId string = 'noneProvided'

@allowed([
  'Enabled'
  'Disabled'
])
@description('The network access type for accessing Application Insights ingestion.')
param publicIngestionAccess string = 'Enabled'

@allowed([
  'Enabled'
  'Disabled'
])
@description('The network access type for accessing Application Insights query.')
param publicQueryAccess string = 'Enabled'

var appInsightsConfig = {
  applicationType: type
  samplingPercentage: samplingPercentage
  disableIpMasking: disableIpMasking
  immediatePurgeDataOn30Days: purgeDataOn30Days
  logAnalyticsId: ((logAnalyticsId == 'noneProvided') ? json('null') : logAnalyticsId)
  publicNetworkAccessForIngestion: publicIngestionAccess
  publicNetworkAccessForQuery: publicQueryAccess
}

resource rssName_resource 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: rssName
  location: resourceGroup().location
  kind: appInsightsConfig.applicationType
  properties: {
    Application_Type: appInsightsConfig.applicationType
    SamplingPercentage: appInsightsConfig.samplingPercentage
    DisableIpMasking: appInsightsConfig.disableIpMasking
    ImmediatePurgeDataOn30Days: appInsightsConfig.immediatePurgeDataOn30Days
    WorkspaceResourceId: appInsightsConfig.logAnalyticsId
    publicNetworkAccessForIngestion: appInsightsConfig.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: appInsightsConfig.publicNetworkAccessForQuery
  }
}

output instrumentationKey string = reference(rssName).InstrumentationKey
output appInsights object = reference(rssName, '2020-02-02-preview', 'Full')
