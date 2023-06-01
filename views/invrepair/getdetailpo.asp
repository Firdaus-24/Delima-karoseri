<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.Form("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_OrJulRepairH.*, DLK_M_Customer.custid, DLK_M_Customer.custnama FROM dbo.MKT_T_OrJulRepairH LEFT OUTER JOIN DLK_M_Customer ON MKT_T_OrJulRepairH.ORH_custid = DLK_M_Customer.custID WHERE ORH_AktifYN = 'Y' AND ORH_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  if not data.eof then
      response.write "{"   
        response.write """ID""" & ":" & """" & data("ORH_ID") &  """" & ","
        response.write """CABANG""" & ":" & """" & data("ORH_AgenID") &  """" & ","
        response.write """DATE""" & ":" & """" & data("ORH_Date") &  """" & ","
        response.write """JTDATE""" & ":" & """" & data("ORH_JTDate") &  """" & ","
        response.write """CUSTID""" & ":" & """" & data("Custid") &  """" & ","
        response.write """PPN""" & ":" & """" & data("ORH_PPN") &  """" & ","
        response.write """DISKONALL""" & ":" & """" & data("ORH_DiskonALL") &  """" & ","
        response.write """CUSTNAME""" & ":" & """" & data("custnama") &  """" & ","
        response.write """TIMEWORK""" & ":" & """" & data("ORH_TImeWork") &  """" & ","
        response.write """UANGMUKA""" & ":" & """" & data("ORH_UangMuka") &  """" & ","
        response.write """KETERANGAN""" & ":" & """" & data("ORH_Keterangan") &  """" 
      response.write "}"
  else
    response.write "{}"
  end if

%>