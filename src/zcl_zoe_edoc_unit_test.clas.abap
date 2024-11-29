class ZCL_ZOE_EDOC_UNIT_TEST definition
  public
  inheriting from ZCL_ZOE_EDOC
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods FAKE_XML_DISPLAY_FOR_TEST
    returning
      value(E_CONTENT) type RSRAWSTRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZOE_EDOC_UNIT_TEST IMPLEMENTATION.


  METHOD constructor.

    CALL METHOD super->constructor.


  ENDMETHOD.


  METHOD fake_xml_display_for_test.


    SELECT * FROM zedoc_view INTO @DATA(wa).
    ENDSELECT.

    SELECT SINGLE * FROM zedoc_db WHERE unique_value = @wa-unique_value INTO @data(ls).

    me->xcontent = ls-xdata.

    e_content = me->xcontent.
  ENDMETHOD.
ENDCLASS.
