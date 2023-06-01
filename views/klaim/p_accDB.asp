<!--#include file="../../Connections/cargo.asp"-->
<% 
   id = Request.QueryString("d")
   p = Request.QueryString("p")

   if p = "1" then
      strbm = "DB_acc1 = 'Y'"
   elseIf p = "2" then
      strbm = "DB_acc2 = 'Y'"
   else
      strbm = ""
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_String

   data_cmd.commandText = "SELECT * FROM DLK_T_DelBarang WHERE DB_ID = '"& id &"' AND DB_AktifYN = 'Y'"

   set data = data_cmd.execute

   if not data.eof then
      data_cmd.commandText = "UPDATE DLK_T_DelBarang SET "&strbm&" WHERE DB_ID = '"& id &"'"
      ' response.write data_cmd.commandText & "<br>"
      data_cmd.execute
   end if

   Response.Redirect("https://mail.google.com/")
%>