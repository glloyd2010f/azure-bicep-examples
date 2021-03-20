param sqlServerName string {
  minLength: 1
  maxLength: 63
  metadata: {
    description: 'Name of the Azure SQL Database'
  }
}
param dbaUsername string {
  metadata: {
    description: 'User Account for the default database account'
  }
  secure: true
}
param dbaPassword string {
  metadata: {
    description: 'Password for the default database account'
  }
  secure: true
  default: newGuid()
}
param minimalTlsVersion string {
  allowed: [
    '1.0'
    '1.1'
    '1.2'
  ]
  metadata: {
    description: 'Minimal TLS version'
  }
  default: '1.2'
}

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