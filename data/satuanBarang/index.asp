<!--#include file="../../Connections/cargo.asp"-->
<% 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = "SELECT * FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   
   response.write "["   
      do while not data.eof
      response.write "{"   
         response.write """ID""" & ":" & """" & data("Sat_ID") &  """" & ","
         response.write """NAMA""" & ":" & """" & data("Sat_NAMA") &  """" 
      response.write "}"
      data.movenext
      if data.eof = false then
         response.write ","
      end if 
      loop
   response.write "]"   

%>