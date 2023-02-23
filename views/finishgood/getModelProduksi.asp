<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.Form("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = ""
%>