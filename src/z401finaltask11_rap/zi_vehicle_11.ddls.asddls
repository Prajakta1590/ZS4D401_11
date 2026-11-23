@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data defination'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_VEHICLE_11 as select from zvehicle_11
{
      key vehicle_uuid          as VehicleUUID,
      vehicle_type          as VehicleType,
      make                  as Make,
      model                 as Model,
      @Semantics.amount.currencyCode: 'Currency'
      price                 as Price,
      currency              as Currency,
      color                 as Color,
      cargo                 as Cargo,
      seats                 as Seats,
      
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
