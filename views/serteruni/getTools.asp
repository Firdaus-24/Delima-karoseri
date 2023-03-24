<!--#include file="../../init.asp"-->
<% 
  if session("MQ2A") = false OR session("MQ2B") = false then
    Response.Redirect("index.asp")
  end if

  id1 = trim(Request.Form("id1"))
  id2 = trim(Request.Form("id2"))
  keterangan = trim(Request.Form("keterangan"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id1 &"' AND TFK_FKID = '"& id2 &"'"
  set data = data_cmd.execute

  if data.eof then
    call query("INSERT INTO DLK_T_UnitCustomerD2 (TFK_ID,TFK_FKID,TFK_Keterangan) VALUES ('"& id1 &"', '"& id2 &"', '"& keterangan &"')")
  else
    call query("DELETE DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id1 &"' AND TFK_FKID = '"& id2 &"'")
  end if
%>