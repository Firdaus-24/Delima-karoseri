<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.Form("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.*, DLK_M_Customer.custid, DLK_M_Customer.custnama FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrJulH.OJH_custid = DLK_M_Customer.custID WHERE OJH_AktifYN = 'Y' AND OJH_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  if not data.eof then
      response.write "{"   
        response.write """ID""" & ":" & """" & data("OJH_ID") &  """" & ","
        response.write """CABANG""" & ":" & """" & data("OJH_AgenID") &  """" & ","
        response.write """DATE""" & ":" & """" & data("OJH_Date") &  """" & ","
        response.write """JTDATE""" & ":" & """" & data("OJH_JTDate") &  """" & ","
        response.write """CUSTID""" & ":" & """" & data("Custid") &  """" & ","
        response.write """PPN""" & ":" & """" & data("OJH_PPN") &  """" & ","
        response.write """DISKONALL""" & ":" & """" & data("OJH_DiskonALL") &  """" & ","
        response.write """CUSTNAME""" & ":" & """" & data("custnama") &  """" & ","
        response.write """KETERANGAN""" & ":" & """" & data("OJH_Keterangan") &  """" 
      response.write "}"
  else
    response.write "{}"
  end if

%>