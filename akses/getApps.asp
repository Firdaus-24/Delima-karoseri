<!--#include file="../Connections/cargo.asp"-->
<% 
   user = Request.form("user")
   serverid = Request.form("serverID")
   app = Request.form("app")

   set rs = Server.CreateObject("ADODB.Command")
   rs.activeConnection = MM_Delima_string

   rs.commandText = "SELECT appIDRights FROM DLK_M_AppRight WHERE (Username = '"& user &"') AND (ServerID = '"& serverid &"') AND appIDRights = '"& app &"' "
   set chekexist = rs.execute

   if chekexist.eof then
      rs.commandText = "INSERT INTO DLK_M_AppRight (Username, ServerID, appIDRights ) VALUES ('"& user &"', '"& serverid &"', '"& app &"')"
      ' Response.Write rs.com
      rs.execute
   else
      rs.commandText = "DELETE FROM DLK_M_AppRight WHERE (Username = '"& user &"') AND (ServerID = '"& serverid &"') AND appIDRights = '"& app &"' "
      rs.execute
   end if

%>