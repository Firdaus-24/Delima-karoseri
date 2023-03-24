<!--#include file="../../init.asp"-->
<% 
  ojhid = trim(Request.Form("ojhid"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT CustNama, custID FROM DLK_T_OrjulH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrjulH.OJH_Custid = DLK_M_Customer.custID WHERE OJH_ID = '"& ojhid &"' AND OJH_AktifYN = 'Y' ORDER BY OJH_ID ASC"

  set data = data_cmd.execute

  if not data.eof then
    response.ContentType = "application/json;charset=utf-8"
    response.write "["
      response.write "{"   
         response.write """ID""" & ":" & """" & data("custid") & """" & ","
         response.write """NAMA""" & ":" & """" & data("custNama") &  """" 
      response.write "}"
    response.write "]"
  else
    response.write "404"
  end if
%>