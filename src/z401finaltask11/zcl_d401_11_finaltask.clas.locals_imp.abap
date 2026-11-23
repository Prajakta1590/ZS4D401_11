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
        RETURNING VALUE(ro_truck) TYPE REF TO lcl_truck,
         save_to_fiori_db
           IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
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
      RAISE EXCEPTION TYPE zcx_d401_11_failed
        MESSAGE e001(Z401FINALTASK11)
        WITH |{ mv_cargo }| mv_model.
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
        lo_truck ?= lo_vehicle.
        io_out->write( |TRUCK |                             &&
                       |Make: { lo_truck->mv_make } |       &&
                       |Model: { lo_truck->mv_model } |     &&
                       |Price: { lo_truck->mv_price } EUR | &&
                       |Color: { lo_truck->mv_color } |     &&
                       |Cargo: { lo_truck->mv_cargo } t| ).
        CONTINUE.
      CATCH cx_sy_move_cast_error.
      ENDTRY.
      "Try bus
      TRY.
        lo_bus ?= lo_vehicle.
        io_out->write( |BUS   |                           &&
                       |Make: { lo_bus->mv_make } |       &&
                       |Model: { lo_bus->mv_model } |     &&
                       |Price: { lo_bus->mv_price } EUR | &&
                       |Color: { lo_bus->mv_color } |     &&
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
      METHOD save_to_fiori_db.
    DATA lt_db TYPE TABLE OF zvehicle_11.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    "Loop over all vehicles already in the rental fleet
    LOOP AT mt_vehicles INTO DATA(lo_vehicle).
      DATA(ls_row) = VALUE zvehicle_11(
        vehicle_uuid          = cl_system_uuid=>create_uuid_x16_static( )
        make                  = lo_vehicle->mv_make
        model                 = lo_vehicle->mv_model
        price                 = lo_vehicle->mv_price
        currency              = 'EUR'
        color                 = lo_vehicle->mv_color
        created_by            = sy-uname
        created_at            = lv_timestamp
        local_last_changed_at = lv_timestamp
      ).

      "Check if Truck or Bus via Downcasting:
      TRY.
        DATA(lo_truck) = CAST lcl_truck( lo_vehicle ).
        ls_row-vehicle_type = 'TRUCK'.
        ls_row-cargo        = lo_truck->mv_cargo.
      CATCH cx_sy_move_cast_error.
        DATA(lo_bus) = CAST lcl_bus( lo_vehicle ).
        ls_row-vehicle_type = 'BUS'.
        ls_row-seats        = lo_bus->mv_seats.
      ENDTRY.

      APPEND ls_row TO lt_db.
    ENDLOOP.

    "Save into the database table
    DELETE FROM zvehicle_11. "Clears old data
    INSERT zvehicle_11 FROM TABLE @lt_db.
    COMMIT WORK.

    io_out->write( '===> All fleet vehicles successfully synced to Fiori Database! <===' ).
ENDMETHOD.

ENDCLASS.
