@minLength(3)
@maxLength(50)
@description('Name of the Azure Key Vault')
param keyVaultName string

@description('Declare if the Azure Key Vault has been created or not.')
param kvAccessPolicies object = {
  list: []
}

@allowed([
  'standard'
  'premium'
])
@description('SKU name to specify whether the key vault is a standard vault or a premium vault. - standard or premium')
param skuName string = 'standard'

var tenantId = subscription().tenantId
var keyVaultConfig = {
  enabledForDeployment: true
  enabledForTemplateDeployment: true
  enabledForDiskEncryption: false
  enableSoftDelete: true
  accessPolicies: kvAccessPolicies.list
  networkAcl: {
    defaultAction: 'allow'
    bypass: 'AzureServices'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: resourceGroup().location
  properties: {
    enabledForDeployment: keyVaultConfig.enabledForDeployment
    enabledForTemplateDeployment: keyVaultConfig.enabledForTemplateDeployment
    enabledForDiskEncryption: keyVaultConfig.enabledForDiskEncryption
    tenantId: tenantId
    enableSoftDelete: keyVaultConfig.enableSoftDelete
    accessPolicies: keyVaultConfig.accessPolicies
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: keyVaultConfig.accessPolicies.defaultAction
      bypass: keyVaultConfig.accessPolicies.bypass
    }
  }
}

output keyVault object = keyVault
