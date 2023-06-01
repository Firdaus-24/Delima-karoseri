<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.Form("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandtext = "SELECT ven_PayTerm FROM DLK_M_Vendor where Ven_ID = '"& id &"'"
   ' response.write data_cmd.commandText 
   set data = data_cmd.execute

   if not data.eof then
      response.write data("ven_PayTerm")
   else
      response.write 0
   end if
%>