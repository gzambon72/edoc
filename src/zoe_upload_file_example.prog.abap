
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


  DATA  lv_filename TYPE string.
  DATA xresult TYPE xstring.
  DATA result TYPE string.

*  filename = p_file.
*
*  lo_xml->import_from_file( filename ).
*
*
*  lo_xml->render_2_string(
*  IMPORTING
*    stream = result ).
*
*  lo_xml->render_2_xstring(
*  IMPORTING
*    stream = xresult ).

  PERFORM upload_file_from_frontend
    CHANGING xresult
             lv_filename.




  DATA o_edoc TYPE REF TO zcl_zoe_edoc.


  CREATE OBJECT o_edoc
    EXPORTING
*     iv_edoc_guid =
      iv_edocflow = 'EDOC'
*     is_new      = ABAP_TRUE
      iv_content  = xresult.
  o_edoc->execute_action( 'CREATE' ).

  FREE o_edoc.


*  lstring =  cl_bcs_convert=>xstring_to_string(  xstring ).
  cl_bcs_convert=>xstring_to_string(
      EXPORTING
        iv_xstr   = xresult
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
FORM upload_file_from_frontend
  CHANGING cv_file TYPE xstring
           cv_filename TYPE string.

  DATA lv_title       TYPE string.
  DATA lt_filename    TYPE filetable.
  DATA lv_cnt         TYPE i.
  DATA lv_action      TYPE i.
  DATA lv_fl_length   TYPE i.
  DATA lt_data        TYPE etxml_xline_tabtype.

  lv_title = 'Select PDF file to upload'(001).

* File open dialog
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = lv_title
    CHANGING
      file_table              = lt_filename
      rc                      = lv_cnt
      user_action             = lv_action
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    RETURN.
  ENDIF.

  IF lv_action IS NOT INITIAL.
    RETURN.
  ENDIF.

  READ TABLE lt_filename INTO cv_filename INDEX 1.
  IF cv_filename IS INITIAL.
    RETURN.
  ENDIF.

  TRY.                                                      "Start 2927542
      cl_edoc_util=>check_max_file_size(
        EXPORTING iv_file_name = cv_filename ).
    CATCH cx_edocument.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
  ENDTRY.                                                   "End 2927542

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename   = cv_filename
      filetype   = 'BIN'
    IMPORTING
      filelength = lv_fl_length
    CHANGING
      data_tab   = lt_data
    EXCEPTIONS
      OTHERS     = 1.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    RETURN.
  ENDIF.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_fl_length
    IMPORTING
      buffer       = cv_file
    TABLES
      binary_tab   = lt_data
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Obtain filename from file path
  CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = cv_filename
    IMPORTING
      stripped_name = cv_filename
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
