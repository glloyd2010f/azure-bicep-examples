@minLength(5)
@maxLength(50)
@description('Name of the Azure App Config')
param appConfigName string

@description('Array of Objects that contain the key name, value, tag and contentType')
param keyData array = [
  {
    key: 'keyName'
    value: 'keyValue'
    tag: 'keyValue'
    contentType: 'keyContentType'
  }
]

resource appConfig_keyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2020-07-01-preview' = [for item in keyData: {
  name: '${appConfigName}/${(contains(item, 'label') ? '${item.key}$${item.label}' : item.key)}'
  properties: {
    value: item.value
    contentType: (contains(item, 'contentType') ? item.contentType : json('null'))
    tags: (contains(item, 'tag') ? item.tag : json('null'))
  }
}]
