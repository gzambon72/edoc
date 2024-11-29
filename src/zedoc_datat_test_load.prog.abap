
REPORT z.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE rlgrap-filename DEFAULT 'C:\Users\Ocra\OneDrive - OCRA SRL\Documenti\OCRA-Progetti\SAP-OCRA\custom-edoc\fattura.xml' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f4_filename.

START-OF-SELECTION.
  DATA xstring TYPE xstring.
  DATA lstring TYPE string.
  DATA(lo_xml) = NEW cl_xml_document( ).
  DATA filename TYPE localfile.

  filename = p_file.

  lo_xml->import_from_file( filename ).

  lo_xml->render_2_string(
  IMPORTING
    stream = DATA(result) ).

  lo_xml->render_2_xstring(
  IMPORTING
    stream = DATA(xresult) ).

  DATA ls_data TYPE zedoc_db.

  cl_bcs_convert=>xstring_to_string(
      EXPORTING
        iv_xstr   = xresult
        iv_cp     = '4110'  "UTF-8
      RECEIVING
        rv_string = lstring
    ).

  cl_demo_output=>display_xml( lstring ).

  DELETE FROM zedoc_db.
  DELETE FROM zoe_edocument.
  DELETE FROM zoe_edocfile.


  DATA o_edoc TYPE REF TO zcl_zoe_edoc.

  DO 3 TIMES.
    CREATE OBJECT o_edoc
      EXPORTING
*       iv_edoc_guid =
        iv_edocflow = 'EDOC'
*       is_new      = ABAP_TRUE
        iv_content  = xresult.
    o_edoc->execute_action( 'CREATE' ).
    WAIT UP TO 2 SECONDS.
    FREE o_edoc.
  ENDDO.

*  DO 3 TIMES.
*    GET TIME STAMP FIELD DATA(tmstp).
*    DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
*    ls_data  = VALUE #( edocflow = 'SUP01'   unique_value = unique_value    xdata = xresult ernam = sy-uname erdat = sy-datum erzet = sy-uzeit tmstp = tmstp ).
*    MODIFY zedoc_db FROM ls_data.
*    ls_data  = VALUE #( edocflow = 'SUP02'   unique_value = unique_value    xdata = xresult ernam = sy-uname erdat = sy-datum erzet = sy-uzeit tmstp = tmstp ).
*    MODIFY zedoc_db FROM ls_data.
*    COMMIT WORK.
*  ENDDO.


*  SELECT * FROM zedoc_db INTO TABLE @DATA(lt_db).
*  SORT lt_db BY unique_value.
*  cl_demo_output=>display_data( lt_db ).

  DATA(o_unit_test) = NEW zcl_zoe_edoc_unit_test( ).


  xstring  = o_unit_test->fake_xml_display_for_test( ).


*  lstring =  cl_bcs_convert=>xstring_to_string(  xstring ).
  cl_bcs_convert=>xstring_to_string(
      EXPORTING
        iv_xstr   = xstring
        iv_cp     = '4110'  "UTF-8
      RECEIVING
        rv_string = lstring
    ).

  cl_demo_output=>display_xml( lstring ).

FORM f4_filename.
  DATA: lt_filetable TYPE filetable,
        lv_rc        TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title      = 'Seleziona file JSON'
      default_extension = '*.json'
      file_filter       = 'JSON Files (*.json)|*.json|'
    CHANGING
      file_table        = lt_filetable
      rc                = lv_rc.

  IF lv_rc = 1.
    READ TABLE lt_filetable INDEX 1 INTO p_file.
  ENDIF.
ENDFORM.
