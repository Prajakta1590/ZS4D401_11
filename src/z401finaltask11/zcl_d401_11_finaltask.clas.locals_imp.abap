*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
types: ty_price TYPE p LENGTH 8 DECIMALS 2,
       ty_cargo type p length 4 DECIMALS 2.
"-- Abstract base class: Vehicle ------------------------------------
CLASS lcl_vehicle DEFINITION ABSTRACT.
  PUBLIC SECTION.
    DATA: mv_make  TYPE string,
          mv_model TYPE string,
          mv_price TYPE ty_price,
          mv_color TYPE string.
              METHODS:
      constructor
        IMPORTING
          iv_make  TYPE string
          iv_model TYPE string
          iv_price TYPE ty_price
          iv_color TYPE string,
      display_attributes ABSTRACT.   "each subclass implements this
ENDCLASS.

"-- Truck: inherits Vehicle -----------------------------------------

CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    DATA: mv_cargo TYPE ty_cargo.   "cargo in tons
    METHODS:
      constructor
        IMPORTING
          iv_make  TYPE string
          iv_model TYPE string
          iv_price TYPE ty_price
          iv_color TYPE string
         iv_cargo TYPE ty_cargo
        RAISING
          zcx_d401_11_failed,
      display_attributes REDEFINITION,
      get_cargo  RETURNING VALUE(rv_cargo) TYPE ty_cargo.
      CLASS-METHODS:
  create
    IMPORTING
      iv_make  TYPE string
      iv_model TYPE string
      iv_price TYPE ty_price
      iv_color TYPE string
      iv_cargo TYPE ty_cargo
    RETURNING VALUE(ro_truck) TYPE REF TO lcl_truck
    RAISING   zcx_d401_11_failed.
ENDCLASS.

"-- Bus: inherits Vehicle -------------------------------------------
CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    DATA: mv_seats TYPE i.
    METHODS:
      constructor
        IMPORTING
          iv_make  TYPE string
          iv_model TYPE string
          iv_price TYPE ty_price
          iv_color TYPE string
          iv_seats TYPE i,
      display_attributes REDEFINITION,
      get_seats RETURNING VALUE(rv_seats) TYPE i.
ENDCLASS.

"-- Rental company: holds a polymorphic collection ------------------
CLASS lcl_rental DEFINITION.
  PUBLIC SECTION.
    METHODS:
      add_vehicle
        IMPORTING io_vehicle TYPE REF TO lcl_vehicle,
      display_all
        IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      get_max_cargo_truck
        RETURNING VALUE(ro_truck) TYPE REF TO lcl_truck.
  PRIVATE SECTION.
    DATA: mt_vehicles TYPE TABLE OF REF TO lcl_vehicle.
ENDCLASS.

" LOCAL CLASS IMPLEMENTATIONS

"-- lcl_vehicle -----------------------------------------------------
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD constructor.
    mv_make  = iv_make.
    mv_model = iv_model.
    mv_price = iv_price.
    mv_color = iv_color.
  ENDMETHOD.
ENDCLASS.

"-- lcl_truck -------------------------------------------------------
CLASS lcl_truck IMPLEMENTATION.
  METHOD constructor.
    "Always call super constructor first
    super->constructor(
      iv_make  = iv_make
      iv_model = iv_model
      iv_price = iv_price
      iv_color = iv_color ).
    mv_cargo = iv_cargo.

    "Aufgabe 5: Raise exception if cargo < 2 tons
    IF mv_cargo < 2.
      RAISE EXCEPTION TYPE zcx_d401_11_failed.
    ENDIF.
  ENDMETHOD.
  METHOD display_attributes.
    "Note: This version returns a string for use with out->write()
    "Called by lcl_rental->display_all which passes out
  ENDMETHOD.
  METHOD get_cargo.
    rv_cargo = mv_cargo.
  ENDMETHOD.
 METHOD create.
  ro_truck = NEW lcl_truck(
    iv_make  = iv_make
    iv_model = iv_model
    iv_price = iv_price
    iv_color = iv_color
    iv_cargo = iv_cargo ).   "Constructor already raises exception if < 2t
ENDMETHOD.
ENDCLASS.

"-- lcl_bus ---------------------------------------------------------
CLASS lcl_bus IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      iv_make  = iv_make
      iv_model = iv_model
      iv_price = iv_price
      iv_color = iv_color ).
    mv_seats = iv_seats.
  ENDMETHOD.
  METHOD display_attributes.
    "Implemented via display_all in rental (see below)
  ENDMETHOD.
  METHOD get_seats.
    rv_seats = mv_seats.
  ENDMETHOD.
ENDCLASS.

"-- lcl_rental ------------------------------------------------------
CLASS lcl_rental IMPLEMENTATION.
  METHOD add_vehicle.
    APPEND io_vehicle TO mt_vehicles.
  ENDMETHOD.
  METHOD display_all.
    DATA: lo_truck TYPE REF TO lcl_truck,
          lo_bus   TYPE REF TO lcl_bus.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle).
      "Try truck
      TRY.
        lo_truck ?= lo_vehicle.   "DOWNCAST attempt
        io_out->write( |TRUCK  | &&
                    |Make: { lo_truck->mv_make }  | &&
                    |Model: { lo_truck->mv_model }  | &&
                    |Cargo: { lo_truck->mv_cargo } t| ).
        CONTINUE.
      CATCH cx_sy_move_cast_error.
      ENDTRY.
      "Try bus
      TRY.
        lo_bus ?= lo_vehicle.
         io_out->write( |BUS    | &&
                    |Make: { lo_bus->mv_make }  | &&
                    |Model: { lo_bus->mv_model }  | &&
                    |Seats: { lo_bus->mv_seats }| ).
      CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
  METHOD get_max_cargo_truck.
    DATA: lv_max  TYPE p DECIMALS 2 VALUE 0,
          lo_truck TYPE REF TO lcl_truck.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle).
      TRY.
        lo_truck ?= lo_vehicle.           "Downcast: is this a truck?
        IF lo_truck->get_cargo( ) > lv_max.
          lv_max   = lo_truck->get_cargo( ).
          ro_truck = lo_truck.            "Remember this truck
        ENDIF.
      CATCH cx_sy_move_cast_error.
        CONTINUE.                         "It's a bus, skip
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
