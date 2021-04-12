@minLength(1)
@maxLength(63)
@description('Name of the Azure SQL Database')
param sqlServerName string

@secure()
@description('User Account for the default database account')
param dbaUsername string

@secure()
@description('Password for the default database account')
param dbaPassword string

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Minimal TLS version')
param minimalTlsVersion string  = '1.2'

var tenantId = subscription().tenantId
var sqlServerConfig = {
  dbaUsername: dbaUsername
  dbaPassword: dbaPassword
  version: '12.0'
  minimalTlsVersion: minimalTlsVersion
}

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: sqlServerConfig.dbaUsername
    administratorLoginPassword: sqlServerConfig.dbaPassword
    minimalTlsVersion: sqlServerConfig.minimalTlsVersion
    version: sqlServerConfig.version
  }
}

output azureSqlServer object = sqlServer
