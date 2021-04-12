@minLength(3)
@maxLength(44)
@description('Name of the Azure Cosmos DB')
param rssName string

@allowed([
  'DocumentDB'
  'MongoDB'
  'Table'
  'Graph'
])
@description('Type of the Azure Cosmos DB Instance')
param databaseType string = 'DocumentDB'

var cosmosDbConfig = {
  apiType: {
    kind: databaseType
    capabilities: []
  }
  automaticFailover: true
  primaryRegion: 'eastus'
  multipleWriteLocations: true
  virtualNetworkFilterEnabled: false
  disableKeyBasedMetadataWriteAccess: false
  consistencyPolicy: {
    defaultConsistencyLevel: 'Session'
    maxIntervalInSeconds: 5
    maxStalenessPrefix: 100
  }
  locations: {
    eastus: {
      locationName: resourceGroup().location
      failoverPriority: 0
      zoneRedundant: false
    }
  }
  throughput: 400
  databaseAccountOfferType: 'Standard'
}

resource cosmosDb 'Microsoft.DocumentDb/databaseAccounts@2020-04-01' = {
  name: rssName
  location: resourceGroup().location
  properties: {
    databaseAccountOfferType: cosmosDbConfig.databaseAccountOfferType
    enableAutomaticFailover: cosmosDbConfig.automaticFailover
    isVirtualNetworkFilterEnabled: cosmosDbConfig.virtualNetworkFilterEnabled
    enableMultipleWriteLocations: cosmosDbConfig.multipleWriteLocations
    disableKeyBasedMetadataWriteAccess: cosmosDbConfig.disableKeyBasedMetadataWriteAccess
    consistencyPolicy: {
      defaultConsistencyLevel: cosmosDbConfig.consistencyPolicy.defaultConsistencyLevel
      maxIntervalInSeconds: cosmosDbConfig.consistencyPolicy.maxIntervalInSeconds
      maxStalenessPrefix: cosmosDbConfig.consistencyPolicy.maxStalenessPrefix
    }
    locations: [
      cosmosDbConfig.locations.eastus
    ]
    capabilities: []
    virtualNetworkRules: []
  }
}

output cosmosDatabase object = cosmosDb
