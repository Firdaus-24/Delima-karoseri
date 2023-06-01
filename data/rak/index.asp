<!--#include file="../../Connections/cargo.asp"-->
<% 
   agen = trim(Request.QueryString("agen"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = "SELECT * FROM DLK_M_rak WHERE LEFT(Rak_ID,3) = '"& agen &"' AND Rak_AktifYN = 'Y' ORDER BY Rak_Nama ASC"

   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   
   response.write "["   
      do while not data.eof
      response.write "{"   
         response.write """ID""" & ":" & """" & data("Rak_ID") &  """" & ","
         response.write """NAMA""" & ":" & """" & data("Rak_NAMA") &  """" 
      response.write "}"
      data.movenext
      if data.eof = false then
         response.write ","
      end if 
      loop
   response.write "]"   

%>