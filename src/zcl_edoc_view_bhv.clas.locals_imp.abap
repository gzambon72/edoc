CLASS lhc_electronicdocument DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR electronicdocument RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR electronicdocument RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK electronicdocument.

    METHODS read FOR READ
      IMPORTING keys FOR READ electronicdocument RESULT result.


    METHODS fileupload FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~fileupload RESULT result.

    METHODS pdf_display FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~pdf_display RESULT result.

    METHODS xml_display FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~xml_display RESULT result.

    METHODS document_post FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~document_post RESULT result.

    METHODS uploadXML FOR MODIFY IMPORTING keys FOR  ACTION  electronicdocument~uploadXML  RESULT    result.

    METHODS uploadxml_model.

ENDCLASS.


CLASS lhc_electronicdocument IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD fileupload.
  ENDMETHOD.

  METHOD uploadXML.
    uploadxml_model(  ).

ENDMETHOD.
  METHOD uploadxml_model.
    DATA lv_title       TYPE string.
    DATA lt_filename    TYPE filetable.
    DATA lv_cnt         TYPE i.
    DATA lv_action      TYPE i.
    DATA lv_fl_length   TYPE i.
    DATA lt_data        TYPE etxml_xline_tabtype.



    lv_title = 'Select PDF file to upload'(001).
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = lv_title
      CHANGING
        file_table              = lt_filename
        rc                      = lv_cnt
        user_action             = lv_action
      EXCEPTIONS
        file_open_dialog_failed = 0
        cntl_error              = 0
        error_no_gui            = 0
        not_supported_by_gui    = 0
        OTHERS                  = 0.

    DATA xstring TYPE xstring.
    DATA(o_unit_test) = NEW zcl_zoe_edoc_unit_test( ).


    xstring  = o_unit_test->fake_xml_display_for_test( ).

    DATA o_edoc TYPE REF TO zcl_zoe_edoc.

    CREATE OBJECT o_edoc
      EXPORTING
*       iv_edoc_guid =
        iv_edocflow = 'EDOC'
*       is_new      = ABAP_TRUE
        iv_content  = xstring.
    o_edoc->execute_action( 'CREATE' ).

    FREE o_edoc.

  ENDMETHOD.

  METHOD pdf_display.

    IF 1 = 1.
    ENDIF.

  ENDMETHOD.

  METHOD xml_display.
    READ ENTITIES OF zcds_edoc_view IN LOCAL MODE
    ENTITY electronicdocument
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_documents).

    MODIFY ENTITIES OF zcds_edoc_view IN LOCAL MODE ENTITY electronicdocument
                 UPDATE FROM VALUE #( FOR key IN keys ( edocgroup = key-edocgroup edocflow = key-edocflow unique_value = |{ key-unique_value }_UPDATED| %control-file_name = 'filename' ) )
             FAILED   failed
             REPORTED reported.

    IF 1 = 1.
    ENDIF.

  ENDMETHOD.

  METHOD document_post.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcds_edoc_view DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_edoc_view IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
