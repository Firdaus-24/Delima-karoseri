<!--#include file="../../init.asp"-->
<%
  id = trim(Request.Form("id"))
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE (dbo.DLK_T_OrPemH.OPH_ID = '"& id &"')"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
  if not data.eof then
      response.write "{"   
        response.write """ID""" & ":" & """" & data("Ven_ID") &  """" & ","
        response.write """NAMA""" & ":" & """" & data("VEN_nama") &  """" 
      response.write "}"
  else
    response.write "{}"
  end if

%>