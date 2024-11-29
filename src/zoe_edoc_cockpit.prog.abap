*&---------------------------------------------------------------------*
REPORT zoe_edoc_cockpit.

TABLES: zedoc_flow, zedocgroup_db.

DATA alv TYPE REF TO zcl_alv_tree_edoc.
DATA lt TYPE zedoc_view_t.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_group FOR zedoc_flow-edocgroup OBLIGATORY.
  SELECT-OPTIONS: s_flow FOR zedoc_flow-edocflow OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.


START-OF-SELECTION.

INITIALIZATION.

START-OF-SELECTION.

  SELECT * FROM zedoc_view
    WHERE edocgroup IN @s_group AND edocflow IN @s_flow INTO TABLE @lt   .

  CALL SCREEN 9000.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS '9000'.
  SET TITLEBAR '001'.

ENDMODULE.                 " STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE PROGRAM.
ENDMODULE.                 " exit  INPUT
*&---------------------------------------------------------------------*
*&      Module  alv_display  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_display OUTPUT.
  IF alv IS INITIAL.
    CREATE OBJECT alv.
  ENDIF.
  alv->alv_tree_process( lt ).
ENDMODULE.                 " alv_display  OUTPUT
