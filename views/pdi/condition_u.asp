<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.Form("id"))
  initial = trim(Request.Form("int"))
  condition = trim(Request.Form("type"))

  ' hasil = ""

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_PreDevInspectionH WHERE PDI_ID = '"& id &"' AND PDI_AktifYN = 'Y'"
  ' response.write data_cmd.commandTExt & "<br>"
  set p = data_cmd.execute

  if not p.eof then
    data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& id &"' AND PDI_Description = '"& initial &"'"
    ' response.write data_cmd.commandText 
    set detail = data_cmd.execute

    if not detail.eof then
      call query("UPDATE DLK_T_PreDevInspectionD SET PDI_Condition = '"& condition &"' WHERE PDI_ID = '"& id &"' AND PDI_Description = '"& initial &"'")
      hasil = "data berhasil diupdate!!"
    else
      hasil = "data tidak terdaftar!!!"
    end if  
  else
    hasil = "data header tidak terdaftar"
  end if  

  response.write hasil
%>