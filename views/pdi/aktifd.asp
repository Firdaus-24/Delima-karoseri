<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp "-->
<%
  if session("MQ3C") = false then
    Response.Redirect("index.asp")
  end if

call header("Aktif")

id = trim(Request.QueryString("id"))
initial = trim(Request.QueryString("init"))
p = trim(Request.QueryString("p"))

set data_cmd =  Server.CreateObject ("ADODB.Command")
data_cmd.ActiveConnection = mm_delima_string

data_cmd.commandtext = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& id &"' AND UPPER(PDI_Initial) = '"& ucase(initial) &"'"

set data = data_cmd.execute

if not data.eof then
  call query("DELETE DLK_T_PreDevInspectionD WHERE PDI_ID = '"& id &"' AND UPPER(PDI_Initial) = '"& ucase(initial) &"'")
  call alert("DETAIL PRE DELIVERY INSPECTIONS", "berhasil di hapus", "success", p&".asp?id="&id)
else 
  call alert("DETAIL PRE DELIVERY INSPECTIONS", "tidak terdaftar", "success", p&".asp?id="&id)
end if


call footer()
%>