<!--#include file="../../init.asp"-->
<%
  if session("MQ5") = false then
    Response.Redirect("../")
  end if
  id = trim(Request.form("id"))

  set data_cmd = Server.CreateObject("ADODB.COmmand")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_M_Brand.BrandName, dbo.DLK_T_ProduksiRepair.* FROM dbo.DLK_T_ProduksiRepair LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_ProduksiRepair.PDR_BrandID = dbo.DLK_M_Brand.BrandID WHERE (dbo.DLK_T_ProduksiRepair.PDR_ID = '"& id &"') AND (dbo.DLK_T_ProduksiRepair.PDR_AktifYN = 'Y')"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
    if not data.eof then
      response.write "["
        response.write "{"
          response.write """TFKID""" & ":" &  """" & data("PDR_TFKID") &  """" & ","
          response.write """IRHID""" & ":" & """" & data("PDR_IRHID") & """" & ","
          response.write """BRANDID""" & ":" & """" & data("PDR_BrandID") & """" & ","
          response.write """BRANDNAME""" & ":" &  """" & data("BrandName") &  """"  & ","
          response.write """TYPE""" & ":" &  """" & data("PDR_Type") &  """"  & ","
          response.write """NOPOL""" & ":" &  """" & data("PDR_Nopol") &  """"  & ","
          response.write """RANGKA""" & ":" &  """" & data("PDR_Norangka") &  """"  & ","
          response.write """MESIN""" & ":" &  """" & data("PDR_NoMesin") &  """"  & ","
          response.write """WARNA""" & ":" &  """" & data("PDR_Color") &  """" 
        response.write "}"
      response.write "]"
    else
      response.write "["
        response.write "{"
          response.write """ERROR""" & ":" &  """DATA TIDAK VALID""" 
        response.write "}"
      response.write "]"
    end if
%>