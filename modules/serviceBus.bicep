param svcBusName string {
  minLength: 6
  maxLength: 50
  metadata: {
    description: 'Name of the Azure Service Bus'
  }
}
param sku string {
  allowed: [
    'Basic'
    'Standard'
    'Premium'
  ]
  metadata: {
    description: 'Azure Service Bus Namespace SKU Name'
  }
  default: 'Standard'
}
param capacity int {
  allowed: [
    1
    2
    4
  ]
  metadata: {
    description: 'Messaging units for the selected Azure Service Bus Tier'
  }
  default: 1
}

var serviceBusConfig = {
  sku: {
    name: sku
    tier: sku
    capacity: capacity
  }
}

resource svcBus 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: svcBusName
  location: resourceGroup().location
  sku: {
    name: serviceBusConfig.sku.name
    tier: serviceBusConfig.sku.tier
    capacity: serviceBusConfig.sku.capacity
  }
  properties: {}
}

output serviceBus object = svcBus