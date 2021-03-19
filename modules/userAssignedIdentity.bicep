param rssName string {
  minLength: 3
  maxLength: 128
  metadata: {
    description: 'Name of the Azure User Assigned Identity'
  }
}

resource rssName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: rssName
  location: resourceGroup().location
}

output userAssignedIdentity object = reference(rssName, '2018-11-30', 'Full')