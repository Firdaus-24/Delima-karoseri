<!--#include file="../../init.asp"-->
<% 
  barang = trim(Request.Form("item"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT RCD_Harga FROM DLK_T_RCProdD WHERE RCD_Item = '"& barang &"' ORDER BY RCD_ID DESC"
  ' response.write data_cmd.commandTExt & "<br>"
  set data = data_cmd.execute

  ' if not data.eof then
  response.write data("RCD_Harga")
  ' end if
%>