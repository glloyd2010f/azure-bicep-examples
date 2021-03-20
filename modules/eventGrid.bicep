param topicName string {
  minLength: 3
  maxLength: 50
  metadata: {
    description: 'Name of the Azure Event Grid Topic'
  }
}
param inputSchema string {
  allowed: [
    'EventGridSchema'
    'CustomEventSchema'
    'CloudEventSchemaV1_0'
  ]
  metadata: {
    description: 'Schema of the incoming events for the Azure Event Grid Topic'
  }
  default: 'EventGridSchema'
}

resource eventGrid 'Microsoft.EventGrid/topics@2020-04-01-preview' = {
  name: topicName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    inputSchema: inputSchema
  }
}

output eventGridTopic object = eventGrid