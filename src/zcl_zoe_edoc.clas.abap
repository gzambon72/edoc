class ZCL_ZOE_EDOC definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_EDOC_GUID type EDOC_GUID optional
      !IV_EDOCFLOW type ZEDOCFLOW default 'EDOC'
      !IS_NEW type XFELD default ABAP_TRUE
      !IV_CONTENT type RSRAWSTRING optional .
  methods EXECUTE_ACTION
    importing
      !IV_ACTION type EDOC_ACTION .
protected section.

  data EDOCUMENT type ZOE_EDOCUMENT .
  data EDOCUMENTFILE type ZOE_EDOCFILE .
  data NEW type XFELD .
  data ACTION type EDOC_ACTION .
  data FILE_GUID type EDOC_GUID .
  data EDOC_GUID type EDOC_GUID .
  data XCONTENT type EDOC_FILE .
  data EDOCFLOW type ZEDOCFLOW .
  data BUFFER type ZEDOC_DB .
private section.

  methods XML_2_BUFFER .
  methods EDOC_SAVE_2_DB .
  methods XML_DISPLAY .
  methods PDF_DISPLAY .
  methods CREATE .
  methods UPDATEINVOICE .
  methods DISPLAY_FILE .
  methods DISPLAY_PDF .
  methods IV_PARK .
  methods IV_POST .
  methods UPLOAD_FILE .
  methods UPLOAD_XML .
  methods VALIDATE_SOURCE .
  methods DELETE .
ENDCLASS.



CLASS ZCL_ZOE_EDOC IMPLEMENTATION.


  METHOD constructor.

    me->new = is_new.
    me->xcontent = iv_content.
    me->edocflow = iv_edocflow .

    CASE new.
      WHEN abap_true.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
        me->edoc_guid = unique_value.
        me->file_guid = 'F' && me->edoc_guid.
        me->edocument-edoc_guid = me->edoc_guid.
        me->edocument-file_guid = me->file_guid.
        me->edocumentfile-file_guid = me->file_guid.
        me->edocumentfile-edoc_guid = me->edoc_guid.
        me->edocumentfile-file_raw = me->xcontent.
        me->xml_2_buffer( ).
      WHEN abap_false.
        me->edoc_guid = iv_edoc_guid.
        SELECT SINGLE * FROM zedoc_db INTO me->buffer WHERE unique_value = iv_edoc_guid.
        SELECT SINGLE * FROM zoe_edocument INTO me->edocument WHERE edoc_guid = iv_edoc_guid.
        SELECT SINGLE * FROM zoe_edocfile INTO me->edocumentfile WHERE file_guid = me->edocument-file_guid.
        xcontent = me->buffer-xdata.
    ENDCASE.
  ENDMETHOD.


  METHOD create.
    edoc_save_2_db( ).
  ENDMETHOD.


  METHOD delete.

    DELETE zoe_edocument FROM me->edocument.
    " COMMIT WORK..
    DELETE zoe_edocfile FROM me->edocumentfile.
    " COMMIT WORK..
    DELETE zedoc_db FROM me->buffer.
    " COMMIT WORK..
  ENDMETHOD.


  method DISPLAY_FILE.
  endmethod.


  method DISPLAY_PDF.
  endmethod.


  METHOD edoc_save_2_db.

    MODIFY zoe_edocument FROM me->edocument.
    " COMMIT WORK..
    MODIFY zoe_edocfile FROM me->edocumentfile.
    " COMMIT WORK..
  ENDMETHOD.


  METHOD execute_action.
    CASE  iv_action.
      WHEN 'CREATE'. create( ).
      WHEN 'UPDATEINVOICE'. updateinvoice( ).
      WHEN 'DELETE'. delete( ).
      WHEN 'DISPLAY_FILE'. display_file( ).
      WHEN 'DISPLAY_PDF'. display_pdf( ).
      WHEN 'IV_PARK'. iv_park( ).
      WHEN 'IV_POST'. iv_post( ).
      WHEN 'UPLOAD_FILE'. upload_file( ).
      WHEN 'UPLOAD_XML'. upload_xml( ).
      WHEN 'VALIDATE_SOURCE'. validate_source( ).
    ENDCASE.

  ENDMETHOD.


  method IV_PARK.
  endmethod.


  method IV_POST.
  endmethod.


  method PDF_DISPLAY.
  endmethod.


  METHOD updateinvoice.
    edoc_save_2_db( ).
  ENDMETHOD.


  method UPLOAD_FILE.
  endmethod.


  method UPLOAD_XML.
  endmethod.


  method VALIDATE_SOURCE.
  endmethod.


  METHOD xml_2_buffer.
    DATA ls_data TYPE zedoc_db.

    GET TIME STAMP FIELD DATA(tmstp).
    ls_data  = VALUE #( edocflow = me->edocflow   unique_value = me->edoc_guid   xdata = me->xcontent ernam = sy-uname erdat = sy-datum erzet = sy-uzeit tmstp = tmstp ).
    MODIFY zedoc_db FROM ls_data.
    " COMMIT WORK..

    me->buffer = ls_data.

  ENDMETHOD.


  method XML_DISPLAY.
  endmethod.
ENDCLASS.
