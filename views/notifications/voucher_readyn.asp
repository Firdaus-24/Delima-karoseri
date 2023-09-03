<!--#include file="../../init.asp"-->
<%
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT COUNT(VCH_ID) as id FROM DLK_T_VoucherH where VCH_Aktifyn = 'Y' AND VCH_Readyn = 'N'"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  response.write "{"   
    response.write """READYN""" & ":" & """" & data("id") &  """" 
  response.write "}"
%>