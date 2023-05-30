<!--#include file="../../init.asp"-->
<% 
  ojhid = trim(Request.Form("ojhid"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string


  if left(ojhid,2) = "SO" then
    data_cmd.commandText = "SELECT CustNama, custID FROM DLK_T_OrjulH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrjulH.OJH_Custid = DLK_M_Customer.custID WHERE OJH_ID = '"& ojhid &"' AND OJH_AktifYN = 'Y' ORDER BY OJH_ID ASC"
  else
    data_cmd.commandText = "SELECT CustNama, custID FROM MKT_T_OrjulREpairH LEFT OUTER JOIN DLK_M_Customer ON MKT_T_OrjulREpairH.ORH_Custid = DLK_M_Customer.custID WHERE ORH_ID = '"& ojhid &"' AND ORH_AktifYN = 'Y' ORDER BY ORH_ID ASC"
  end if
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