CLASS zcl_d401_11_01diversethemen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_D401_11_01DIVERSETHEMEN IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/connection                              "#EC CI_NOWHERE
      FIELDS * INTO TABLE @DATA(lt_connection) ##NEEDED.     "#EC CI_ALL_FIELDS_NEEDED

    DATA text1 TYPE string ##NEEDED.
    DATA text2 TYPE string."#EC NEEDED
    DATA text3 TYPE string.



  ENDMETHOD.
ENDCLASS.
