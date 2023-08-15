<!--#include file="../../init.asp"-->
<%
  id = trim(Request.Form("id"))
  keterangan = trim(Request.Form("keterangan"))

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoid = '"& id &"'"
  set data = data_cmd.execute

  if not data.eof then
    call query("UPDATE DLK_T_Memo_H SET memoketerangan = '"& keterangan &"' where memoid = '"& id &"'")
    Response.Write "DONE"
  else 
    Response.Write "FAIL"
  end if
%>