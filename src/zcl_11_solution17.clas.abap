CLASS zcl_11_solution17 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_11_SOLUTION17 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DATA c_carrier_id TYPE /dmo/carrier_id VALUE 'LH'.
*    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'LH'.

    TRY.
        DATA(carrier) = NEW lcl_carrier( i_carrier_id = c_carrier_id ).

        out->write( name = |{ 'Übersicht der Transportunternehmen'(006) }|
                    data = carrier->get_output(  ) ).
      CATCH cx_abap_invalid_value.
        out->write( |Carrier { c_carrier_id } does not exist| )    ##NO_TEXT .
    ENDTRY.

    IF carrier IS BOUND.
      out->write(  `--------------------------------------------------` ).

      "Find a passenger flight from Frankfurt to New York
      "starting as soon as possible
      "with at least 5 free seats
      DATA(today) = cl_abap_context_info=>get_system_date( ).

      carrier->find_passenger_flight(
         EXPORTING
           i_airport_from_id = 'FRA'
           i_airport_to_id   = 'JFK'
           i_from_date       = today
           i_seats           = 5
         IMPORTING
           e_flight =     DATA(pass_flight)
           e_days_later = DATA(days_later)
               ).

      IF pass_flight IS BOUND.
        out->write( name = |{ 'Found a suitable passenger flight in'(007) } { days_later } { 'days:'(008) }|
                    data = pass_flight->get_description( ) ).
      ELSE.
        out->write( data = `No passenger flight found` )  ##NO_TEXT .
      ENDIF.

      out->write(  `--------------------------------------------------` ).

      "Find a cargo flight from Frankfurt to New York
      "starting as soon as possible
      "with at least 1200 KG free capacity
      carrier->find_cargo_flight(
         EXPORTING
           i_airport_from_id = 'FRA'
           i_airport_to_id   = 'JFK'
           i_from_date       = today
           i_cargo           = 1200
         IMPORTING
           e_flight =     DATA(cargo_flight)
           e_days_later = DATA(days_later2)
               ).

      IF cargo_flight IS BOUND.
        out->write( name = |Found a suitable cargo flight in { days_later2 } days:|  ##NO_TEXT
                    data = cargo_flight->get_description( ) ).
      ELSE.
        out->write( data = `No cargo flight found` )  ##NO_TEXT .
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
