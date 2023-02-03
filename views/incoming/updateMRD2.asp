<!--#include file="../../init.asp"-->
<% 
   if session("INV2B") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.Form("id"))
   trans = trim(Request.Form("trans"))
   rak = trim(Request.Form("rak"))
   qty = trim(Request.Form("qty"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"'"

   set data = data_cmd.execute

   if not data.eof then
      call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Qtysatuan = "& qty &", MR_RakID = '"& rak &"' WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"'")
      response.write "DONE"
   else
      response.write "ERROR"
   end if
%>