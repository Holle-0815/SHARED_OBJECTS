*&---------------------------------------------------------------------*
*& Report z_hcw_read_shared_memory
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_hcw_read_shared_memory.


DATA: gt_sflight type WD_SFLIGHT_TAB,
      lr_sflight type ref to sflight.

DATA:
  go_handle  type ref to zcl_hcw_area, "cl_demo_area,"
  go_root    type ref to zcl_hcw_root, "cl_demo_root,"
  go_catalog type ref to zcl_hcw_catalog.

start-of-selection.
  Data: lv_innam type SHM_INST_NAME.

  write sy-uname to lv_innam.

  try.
      go_handle = zcl_hcw_area=>ATTACH_FOR_READ(
                    INST_NAME = lv_innam "CL_SHM_AREA=>DEFAULT_INSTANCE
                  ).
*              CATCH CX_SHM_INCONSISTENT.  "
    CATCH CX_SHM_NO_ACTIVE_VERSION.  "
      exit.
*              CATCH CX_SHM_READ_LOCK_ACTIVE.  "
*              CATCH CX_SHM_EXCLUSIVE_LOCK_ACTIVE.  "
*              CATCH CX_SHM_PARAMETER_ERROR.  "
*              CATCH CX_SHM_CHANGE_LOCK_ACTIVE.  "
  endtry.

  go_handle->root->gr_catalog->GET_FLIGHTS(
    IMPORTING
      ET_FLIGHTS = gt_sflight    " Tabelle für Struktur sflight
  ).

  cl_salv_table=>FACTORY(
*  EXPORTING
*    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV wird im Listenmodus angezeigt
*    R_CONTAINER    =     " Abstracter Container fuer GUI Controls
*    CONTAINER_NAME =
    IMPORTING
      R_SALV_TABLE   = data(go_alv)    " Basisklasse einfache ALV Tabellen
    CHANGING
      T_TABLE        = gt_sflight
  ).
*  CATCH CX_SALV_MSG.    "

  go_alv->DISPLAY( ).

  go_handle->DETACH( ).
*  CATCH CX_SHM_WRONG_HANDLE.    "
*  CATCH CX_SHM_ALREADY_DETACHED.    "

  go_handle->FREE_INSTANCE(
    EXPORTING
      INST_NAME              = lv_innam   " Name einer Shared Object Instanz eines Areas
*      TERMINATE_CHANGER      = ABAP_TRUE    " Schreiber werden beendet
*    RECEIVING
*      RC                     =     " Rückgabewert (Konstanten in CL_SHM_AREA)
  ).
*    CATCH CX_SHM_PARAMETER_ERROR.    "
