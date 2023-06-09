<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp "-->
<%
  if session("PP5C") = false then
    Response.Redirect("index.asp")
  end if

call header("Aktif")

id = trim(Request.QueryString("id"))

set data_cmd =  Server.CreateObject ("ADODB.Command")
data_cmd.ActiveConnection = mm_delima_string

data_cmd.commandtext = "SELECT * FROM DLK_T_ProduksiRepair WHERE PDR_ID = '"& id &"'"

set data = data_cmd.execute

if not data.eof then
  call query("DELETE DLK_T_ProduksiRepair WHERE PDR_ID = '"& id &"' AND PDR_UpdateID = '"& session("userid") &"'")
  call alert("PRODUKSI REPAIR", "berhasil di hapus", "success","./")
else 
  call alert("PRODUKSI REPAIR", "tidak terdaftar", "success","./")
end if


call footer()
%>