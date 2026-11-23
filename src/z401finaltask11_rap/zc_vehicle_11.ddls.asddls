@EndUserText.label: 'Vehicle Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI: {
  headerInfo: {
    typeName: 'Vehicle',
    typeNamePlural: 'Vehicles',
    title: { type: #STANDARD, value: 'Make' },
    description: { value: 'Model' }
  }
}
define root view entity ZC_VEHICLE_11
  provider contract transactional_query
  as projection on ZI_VEHICLE_11
{
  @UI.facet: [
    { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Vehicle Details', position: 10 }
  ]

  key VehicleUUID,

  @UI: { lineItem:       [{ position: 10, label: 'Type' }],
         identification: [{ position: 10, label: 'Vehicle Type (TRUCK/BUS)' }],
         selectionField: [{ position: 10 }] }
      VehicleType,

  @UI: { lineItem:       [{ position: 20, label: 'Make' }],
         identification: [{ position: 20, label: 'Make' }],
         selectionField: [{ position: 20 }] }
      Make,

  @UI: { lineItem:       [{ position: 30, label: 'Model' }],
         identification: [{ position: 30, label: 'Model' }] }
      Model,

  @UI: { lineItem:       [{ position: 40, label: 'Price' }],
         identification: [{ position: 40, label: 'Price' }] }
      Price,

      Currency,

  @UI: { lineItem:       [{ position: 50, label: 'Color' }],
         identification: [{ position: 50, label: 'Color' }] }
      Color,

  @UI: { lineItem:       [{ position: 60, label: 'Cargo (t)' }],
         identification: [{ position: 60, label: 'Cargo Capacity (tons)' }] }
      Cargo,

  @UI: { lineItem:       [{ position: 70, label: 'Seats' }],
         identification: [{ position: 70, label: 'Number of Seats' }] }
      Seats,

      LocalLastChangedAt
}
