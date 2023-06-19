<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp "-->
<%
  if session("PP6C") = false then
    Response.Redirect("./")
  end if

call header("Aktif")

id = trim(Request.QueryString("id"))

set data_cmd =  Server.CreateObject ("ADODB.Command")
data_cmd.ActiveConnection = mm_delima_string

data_cmd.commandtext = "SELECT * FROM DLK_T_BOMRepairD WHERE Bmrdid = '"& id &"'"

set data = data_cmd.execute

if not data.eof then
  call query("DELETE DLK_T_BOMRepairD WHERE bmrdid = '"& id &"'")
  call alert("DETAIL B.O.M Repair", "berhasil di hapus", "success", Request.ServerVariables("HTTP_REFERER"))
else 
  call alert("DETAIL B.O.M Repair", "tidak terdaftar", "success", Request.ServerVariables("HTTP_REFERER"))
end if


call footer()
%>