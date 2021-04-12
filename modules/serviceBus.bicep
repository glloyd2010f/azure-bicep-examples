@minLength(6)
@maxLength(50)
@description('Name of the Azure Service Bus')
param svcBusName string

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Azure Service Bus Namespace SKU Name')
param sku string = 'Standard'

@allowed([
  1
  2
  4
])
@description('Messaging units for the selected Azure Service Bus Tier')
param capacity int = 1

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
