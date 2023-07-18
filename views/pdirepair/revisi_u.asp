<!--#include file="../../init.asp"-->
<% 
  if session("MQ5B") = false then
    Response.Redirect("../")
  end if

id = trim(Request.Form("id"))
revisi = trim(Request.Form("revisi"))

set data_cmd = Server.CreateObject("ADODB.COmmand")
data_cmd.ActiveConnection = mm_delima_string

data_cmd.commandTExt = "SELECT * FROM DLK_T_PDIRepairH WHERE PDIR_ID = '"& id &"' AND PDIR_Aktifyn = 'Y'"
set data = data_cmd.execute

if not data.eof then
  call query("UPDATE DLK_T_PDIRepairH SET PDIR_Revisi = "& revisi &" WHERE PDIr_ID = '"& id &"'")
  Response.Write "DATA BERHASIL DI UPDATE"
else
  Response.Write "DATA TIDAK TERDAFTAR"
end if
%>