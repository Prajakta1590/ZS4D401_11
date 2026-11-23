CLASS zcl_d401_11_finaltask DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_11_finaltask IMPLEMENTATION.



    METHOD if_oo_adt_classrun~main.

    DATA: lo_rental TYPE REF TO lcl_rental,
          lo_truck  TYPE REF TO lcl_truck,
          lo_bus    TYPE REF TO lcl_bus.
    lo_rental = NEW lcl_rental( ).
    "------------------------------------------------------------
    " Aufgabe 3: Create 5 Trucks (different cargo capacities)
    "------------------------------------------------------------
    out->write( '=== Creating Trucks ===' ).
    "Truck 1 — cargo 1.5 t → will raise exception (< 2 t)
    TRY.
      lo_truck = NEW lcl_truck(
        iv_make ='MAN'
        iv_model ='TGX'
        iv_price = 80000
        iv_color ='Red'
        iv_cargo ='1.5' ).
    lo_rental->add_vehicle( io_vehicle = lo_truck ).
    CATCH zcx_d401_11_failed INTO DATA(lx_error).
      out->write( lx_error->get_text( ) ).
    ENDTRY.
    "Truck 2 — cargo 5 t
    TRY.
      lo_truck = NEW lcl_truck(
        iv_make = 'Volvo'
        iv_model = 'FH'
        iv_price = 90000
        iv_color = 'Blue'
        iv_cargo = '5' ).
    lo_rental->add_vehicle( io_vehicle = lo_truck ).
    CATCH zcx_d401_11_failed.
      out->write( 'Exception: Volvo FH cargo too small!' ).
    ENDTRY.
    "Truck 3 — cargo 8 t
    TRY.
      lo_truck = NEW lcl_truck(
        iv_make = 'Mercedes'
        iv_model = 'Actros'
        iv_price = 95000
        iv_color = 'White'
        iv_cargo ='8' ).
     lo_rental->add_vehicle( io_vehicle = lo_truck ).
    CATCH zcx_d401_11_failed.
      out->write( 'Exception: Mercedes Actros cargo too small!' ).
    ENDTRY.
    "Truck 4 — cargo 10 t
  TRY.
      lo_truck = NEW lcl_truck(
        iv_make  = 'Iveco'
        iv_model = 'Daily'
        iv_price = 45000
        iv_color = 'Orange'
        iv_cargo = '1.2' ).
      lo_rental->add_vehicle( io_vehicle = lo_truck ).
    CATCH zcx_d401_11_failed.
      out->write( 'Exception: Iveco Daily cargo too small (1.2t < 2t)!' ).
    ENDTRY.
    "Truck 5 — cargo 3 t
    TRY.
      lo_truck = NEW lcl_truck(
        iv_make = 'DAF'
        iv_model = 'XF'
        iv_price = 75000
        iv_color = 'Black'
        iv_cargo = '3' ).
      lo_rental->add_vehicle( lo_truck ).
    CATCH zcx_d401_11_failed.
      out->write( 'Exception: DAF XF cargo too small!' ).
    ENDTRY.
    "------------------------------------------------------------
    " Aufgabe 3: Create 5 Buses
    "------------------------------------------------------------
    out->write( '=== Creating Buses ===' ).
    lo_bus = NEW lcl_bus( iv_make = 'Mercedes'
                          iv_model = 'Tourismo'
                          iv_price = 200000
                          iv_color = 'Silver'
                          iv_seats = 50 ).

    lo_rental->add_vehicle( lo_bus ).
    lo_bus = NEW lcl_bus( iv_make = 'MAN'
                          iv_model = 'Lions Coach'
                          iv_price = 180000
                          iv_color = 'Yellow'
                          iv_seats = 45 ).
    lo_rental->add_vehicle( lo_bus ).
    lo_bus = NEW lcl_bus( iv_make = 'Volvo'
                          iv_model = '9700'
                          iv_price = 190000
                          iv_color = 'Blue'
                          iv_seats = 55 ).
    lo_rental->add_vehicle( lo_bus ).

    lo_bus = NEW lcl_bus( iv_make = 'Neoplan'
                          iv_model = 'Cityliner'
                          iv_price = 175000
                          iv_color = 'Red'
                          iv_seats = 60 ).
    lo_rental->add_vehicle( lo_bus ).

    lo_bus = NEW lcl_bus( iv_make = 'Setra'
                          iv_model = 'S 516'
                          iv_price = 210000
                          iv_color = 'White'
                          iv_seats = 48 ).
    lo_rental->add_vehicle( lo_bus ).
    "------------------------------------------------------------
    " Aufgabe 3: Display ALL vehicles
    "------------------------------------------------------------
    out->write( '=== All Vehicles in Rental Fleet ===' ).
    lo_rental->display_all( io_out = out ).
    "------------------------------------------------------------
    " Aufgabe 4: Find truck with MAX cargo (Downcasting)
    "------------------------------------------------------------
    out->write( '=== Truck with Maximum Cargo ===' ).
    DATA(lo_max) = lo_rental->get_max_cargo_truck( ).
    IF lo_max IS BOUND.
      out->write( |Make: { lo_max->mv_make }  | &&
                  |Model: { lo_max->mv_model }  | &&
                  |Cargo: { lo_max->mv_cargo } t| ).
    ENDIF.
        "------------------------------------------------------------
    " Save all vehicles into the Fiori Database
    "------------------------------------------------------------
    lo_rental->save_to_fiori_db( io_out = out ).

  ENDMETHOD.
ENDCLASS.

