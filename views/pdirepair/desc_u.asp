<!--#include file="../../init.asp"-->
<% 
  if session("MQ5B") = false then
    Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
  end if

  id = trim(Request.Form("id"))
  condition = trim(Request.Form("type"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_PDIRepairD WHERE PDIR_ID = '"& id &"'"
  ' response.write data_cmd.commandTExt & "<br>"
  set p = data_cmd.execute

  if not p.eof then
    call query("UPDATE DLK_T_PDIRepairD SET PDIR_condition = '"& condition &"' WHERE PDIR_ID = '"& id &"'")
    hasil = "data berhasil diupdate!!"
  else
    hasil = "data header tidak terdaftar"
  end if  

  response.write hasil
%>