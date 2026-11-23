*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_vehicle DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST  requested_authorizations FOR Vehicle RESULT result.
      METHODS validateCargo FOR VALIDATE ON SAVE
      IMPORTING keys FOR Vehicle~validateCargo.
ENDCLASS.

CLASS lhc_vehicle IMPLEMENTATION.
METHOD get_instance_authorizations.
ENDMETHOD.
  METHOD validateCargo.
    "Read the vehicles being created or edited
    READ ENTITIES OF zi_vehicle_11 IN LOCAL MODE
      ENTITY Vehicle
        FIELDS ( VehicleType Cargo ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_vehicles).

    LOOP AT lt_vehicles INTO DATA(ls_vehicle).
      "Check: If vehicle is a TRUCK and cargo is under 2 tons
      IF ls_vehicle-VehicleType = 'TRUCK' AND ls_vehicle-Cargo < 2.

        "1. Reject the save operation
        APPEND VALUE #( %tky = ls_vehicle-%tky ) TO failed-vehicle.

        "2. Display error message on the Fiori UI
        APPEND VALUE #(
          %tky = ls_vehicle-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |Cargo capacity { ls_vehicle-Cargo } t is too low (minimum 2 t required)!| )
          %element-cargo = if_abap_behv=>mk-on
        ) TO reported-vehicle.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
