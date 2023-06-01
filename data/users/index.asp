<!--#include file="../../Connections/cargo.asp"-->
<% 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM DLK_M_WebLogin WHERE userAktifYN = 'Y' ORDER BY UserName"

   set users = data_cmd.execute  

   response.ContentType = "application/json;charset=utf-8"
   response.write "["
   do while not users.eof  
      response.write "{"
         response.write """USERID""" & ":" &  """" & users("userid") & """"  & ","
         response.write """USERNAME""" & ":" &  """" & users("username") & """"  & ","
         response.write """SERVERID""" & ":" &  """" & users("SERVERID") & """"  & ","
         response.write """PASSWORD""" & ":" &  """" & users("PASSWORD") & """"
      response.write "}"
   users.movenext
   if users.eof = false then
      response.write ","
   end if 
   loop
   response.write "]"
%>