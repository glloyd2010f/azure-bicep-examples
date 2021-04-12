@minLength(3)
@maxLength(128)
@description('Name of the Azure User Assigned Identity')
param identityName string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: identityName
  location: resourceGroup().location
}

output userAssignedIdentity object = identity
