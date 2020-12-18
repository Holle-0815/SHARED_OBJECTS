*&---------------------------------------------------------------------*
*& Report z_hcw_write_shared_memory
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_hcw_write_shared_memory.

DATA: gt_sflight type WD_SFLIGHT_TAB.

DATA:
  go_handle  type ref to zcl_hcw_area, "cl_demo_area,"
  go_root    type ref to zcl_hcw_root, "cl_demo_root,"
  go_catalog type ref to zcl_hcw_catalog.

DATA: gv_carrid type S_CARR_ID.

start-of-selection.

  Data: lv_innam type SHM_INST_NAME.

  write sy-uname to lv_innam.

  try.
      go_handle = zcl_hcw_area=>ATTACH_FOR_WRITE(
                   INST_NAME                     = lv_innam
*                ATTACH_MODE                   = 'X'
*                WAIT_TIME                     = 0
               ).
    catch CX_SHM_EXCLUSIVE_LOCK_ACTIVE.  "
    catch CX_SHM_VERSION_LIMIT_EXCEEDED.  "
    catch CX_SHM_CHANGE_LOCK_ACTIVE.  "
    catch CX_SHM_PARAMETER_ERROR.  "
    catch CX_SHM_PENDING_LOCK_REMOVED.  "
  endtry.

*   GO_HANDLE = CL_DEMO_AREA=>ATTACH_FOR_WRITE(
**                INST_NAME                     = CL_SHM_AREA=>DEFAULT_INSTANCE
**                ATTACH_MODE                   =
**                WAIT_TIME                     = 0
*            ).
**              catch CX_SHM_EXCLUSIVE_LOCK_ACTIVE.  "
**              catch CX_SHM_VERSION_LIMIT_EXCEEDED.  "
**              catch CX_SHM_CHANGE_LOCK_ACTIVE.  "
**              catch CX_SHM_PARAMETER_ERROR.  "
**              catch CX_SHM_PENDING_LOCK_REMOVED.  "
*
  create object go_root area handle go_handle.
*
  create object go_catalog area handle go_handle.

**********************************************************************

  if sy-uname = 'WAGNERHO'.
    gv_carrid = 'AA'.
  else.
    gv_carrid = 'AZ'.
  endif.

  select from sflight
    fields *
    where carrid = @gv_carrid
    into corresponding fields of table @gt_sflight.

  go_catalog->fill_catalog( it_catalog = gt_sflight ).

**********************************************************************

*
  go_root->gr_catalog = go_catalog.
*
  go_handle->set_root( go_root ).

*go_handle->root->gr_catalog->fill_catalog( it_catalog = gt_sflight ).

  go_handle->DETACH_COMMIT( ).
*  catch CX_SHM_WRONG_HANDLE.    "
*  catch CX_SHM_ALREADY_DETACHED.    "
*  catch CX_SHM_SECONDARY_COMMIT.    "
*  catch CX_SHM_EVENT_EXECUTION_FAILED.    "
*  catch CX_SHM_COMPLETION_ERROR.    "
