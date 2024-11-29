CLASS lhc_upload DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ upload RESULT result.

    METHODS readxmlfile FOR MODIFY
      IMPORTING it_file_params FOR ACTION upload~readxmlfile RESULT result.


    METHODS validatexmlcontent
      IMPORTING iv_content      TYPE xstring
      RETURNING VALUE(rv_valid) TYPE abap_bool
      RAISING   cx_transformation_error.
ENDCLASS.

CLASS lhc_upload IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD readxmlfile.

    TRY.
        " Leggi i parametri
        READ TABLE it_file_params INTO  DATA(ls_params)  INDEX 1.

        " Valida il contenuto XML
        IF validatexmlcontent( ls_params-%param-xdata ) = abap_true.
          " Crea il record per il file
          MODIFY ENTITIES OF zi_upload
            ENTITY upload
            CREATE SET FIELDS WITH VALUE #(
              ( %cid        = 'XML_UPLOAD'
                filename    = ls_params-%param-filename
                mimetype    = 'application/xml'
                xdata      = ls_params-%param-xdata
                ) )
            MAPPED DATA(ls_mapped)
            FAILED DATA(ls_failed)
            REPORTED DATA(ls_reported).

          " Prepara il risultato
          IF ls_mapped IS NOT INITIAL.
            READ ENTITIES OF zi_upload IN LOCAL MODE
                ENTITY upload
                ALL FIELDS
                WITH VALUE #( ( ) )
                RESULT DATA(lt_documents).
          ENDIF.
        ELSE.
          APPEND VALUE #( %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Invalid XML content' ) ) TO reported-upload.
        ENDIF.

      CATCH cx_transformation_error INTO DATA(lx_transform).
        APPEND VALUE #( %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = lx_transform->get_text( ) ) ) TO reported-upload.

      CATCH cx_root INTO DATA(lx_root).
        APPEND VALUE #( %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = lx_root->get_text( ) ) ) TO reported-upload.
    ENDTRY.
  ENDMETHOD.

  METHOD validatexmlcontent.
    DATA: lo_xml TYPE REF TO cl_xml_document.

    TRY.
        " Crea un'istanza del parser XML
        lo_xml = NEW #( ).

        " Prova a parsare il contenuto XML
        lo_xml->parse_xstring(  iv_content ).

        " Se arriviamo qui, il parsing è riuscito
        rv_valid = abap_true.

      CATCH cx_root.
        rv_valid = abap_false.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

CLASS lsc_zi_upload DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_zi_upload IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
