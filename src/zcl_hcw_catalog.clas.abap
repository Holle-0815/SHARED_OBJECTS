class ZCL_HCW_CATALOG definition
  public
  final
  create public
  shared memory enabled .

  public section.

    data MT_CATALOG type WD_SFLIGHT_TAB .

    methods FILL_CATALOG
      importing
        !IT_CATALOG type WD_SFLIGHT_TAB .
    methods GET_FLIGHTS
      exporting
        !ET_FLIGHTS type WD_SFLIGHT_TAB .
  protected section.
  private section.

ENDCLASS.



CLASS ZCL_HCW_CATALOG IMPLEMENTATION.


  method FILL_CATALOG.
    MT_CATALOG = IT_CATALOG.
  endmethod.


  method GET_FLIGHTS.
    et_flights = MT_CATALOG.
  endmethod.
ENDCLASS.
