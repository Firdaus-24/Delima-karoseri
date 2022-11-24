<!--#include file="../../Connections/cargo.asp"-->
<% 
   user = Ucase(trim(Request.QueryString("user")))
   agen = trim(Request.QueryString("agen"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Appright WHERE Username = '"& user &"' AND serverID = '"& agen &"'"   

   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   response.write "["
   do while not data.eof
   response.write "{"
         response.write """APP""" &":"& """" & data("AppIDRights") & """" 
   response.write "}"
   data.movenext
   if data.eof = false then
      response.write ","
   end if
   loop
   response.write "]"
%>