<!--#include file="../../init.asp"-->
<%
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT COUNT(OJH_ID) as so FROM MKT_T_OrJulH where OJH_AktifYN = 'Y' AND NOT EXISTS (SELECT PDH_OJHID FROM DLK_T_ProduksiH WHERE PDH_OJHID = MKT_T_OrJulH.OJH_ID)"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  response.write "{"   
    response.write """SO""" & ":" & """" & data("SO") &  """" 
  response.write "}"
%>