<!--#include file="../../init.asp"-->
<% 
  if session("MQ2C") = false then
    Response.Redirect("index.asp")
  end if

  call header("Delete All Unit")
  id = trim(Request.QueryString("id"))
  p = trim(Request.QueryString("p"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD1 WHERE TFK_ID = '"& id &"'"
  set data = data_cmd.execute

  if not data.eof then
    call query("DELETE FROM DLK_T_UnitCustomerD1 WHERE TFK_ID = '"& id &"'")
    data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id &"'"

    set detail = data_cmd.execute

    if not detail.eof then
      call query("DELETE FROM DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id &"'")
    end if
      call alert("DETAIL TRANSAKSI UNIT CUSTOMER", "Berhasil dihapus", "success",p&".asp?id="&left(id,17))
  else
    call alert("DETAIL TRANSAKSI UNIT CUSTOMER", "Tidak Terdaftar!!", "error",p&".asp?id="&left(id,17))
  end if

  call footer()
%>
