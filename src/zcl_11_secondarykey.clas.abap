   CLASS zcl_11_secondarykey DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_11_SECONDARYKEY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DATA(flights) = NEW lcl_flights(  ).

    flights->access_standard(  ).
    flights->access_standard_hashed(  ).
    flights->access_standard_hashed(  ).
    flights->access_standard_sorted(  ).
    flights->access_standard_sorted(  ).
    flights->access_standard_sorted(  ).

    flights->access_sorted(  ).
    flights->access_hashed( ).

    out->write( `Done`  ).



  ENDMETHOD.
ENDCLASS.
