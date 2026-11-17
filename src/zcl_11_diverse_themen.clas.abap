"! <p class="shorttext synchronized" lang="de">Demo</p>
CLASS zcl_11_diverse_themen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_11_DIVERSE_THEMEN IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*        Entität lesen
    DATA input_keys TYPE TABLE FOR READ IMPORT zc_00house.
    DATA result_keys TYPE TABLE FOR READ RESULT zc_00house.
    input_keys = VALUE #( ( HouseID = '0010' ) ).

    READ ENTITIES OF zc_00house ENTITY house
      ALL FIELDS WITH input_keys
          RESULT result_keys.
    out->write( result_keys ).
*        Änderungen speichern
*********************************************************
    DATA update_tab TYPE TABLE FOR UPDATE zc_00house.


    update_tab = VALUE #( ( HouseID = '0010' City = 'Update'  ) ).
    MODIFY ENTITIES OF zc_00house ENTITY house
         UPDATE FIELDS ( City ) WITH update_tab.

    COMMIT ENTITIES.


  ENDMETHOD.
ENDCLASS.
