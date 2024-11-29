*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 20.11.2024 at 06:50:23
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZEDOCGROUP_DB...................................*
DATA:  BEGIN OF STATUS_ZEDOCGROUP_DB                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEDOCGROUP_DB                 .
CONTROLS: TCTRL_ZEDOCGROUP_DB
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZEDOC_FLOW......................................*
DATA:  BEGIN OF STATUS_ZEDOC_FLOW                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEDOC_FLOW                    .
CONTROLS: TCTRL_ZEDOC_FLOW
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZEDOCGROUP_DB                 .
TABLES: *ZEDOC_FLOW                    .
TABLES: ZEDOCGROUP_DB                  .
TABLES: ZEDOC_FLOW                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
