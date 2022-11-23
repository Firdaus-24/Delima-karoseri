<!--#include file="../init.asp"-->
<% 
   user = trim(Request.form("user"))
   serverID = trim(Request.form("serverID"))
   app = trim(Request.form("app"))

   set p = Server.CreateObject("ADODB.Command")
   p.activeConnection = MM_Delima_string

   set data_cmd = Server.CreateObject("ADODB.Command")
   data_cmd.activeConnection = MM_Delima_string

   data_cmd.commandText = "SELECT appIDRights FROM DLK_M_AppRight WHERE (Username = '"& user &"') AND (ServerID = '"& serverID &"') AND appIDRights = '"& app &"' "  
   ' response.write data_cmd.commandText & "<br>"
   set chekexist = data_cmd.execute

   if chekexist.eof then
      p.commandText = "INSERT INTO DLK_M_AppRight (Username, ServerID, appIDRights ) VALUES ('"& user &"', '"& serverID &"', '"& app &"')"
      ' Response.Write p.commandText 
      p.execute
   else
      p.commandText = "DELETE FROM DLK_M_AppRight WHERE (Username = '"& user &"') AND (ServerID = '"& serverID &"') AND appIDRights = '"& app &"' "
      p.execute
   end if

%>