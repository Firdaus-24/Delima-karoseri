<!--#include file="../../init.asp"-->
<%
  irhid = trim(Request.Form("irhid"))

  set data_cmd = Server.CreateObject("ADODB.COmmand")
  data_cmd.ActiveConnection = mm_delima_string   

  data_cmd.commandTExt = "SELECT dbo.DLK_T_UnitCustomerD1.TFK_ID, dbo.DLK_T_UnitCustomerD1.TFK_BrandID, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Norangka, dbo.DLK_T_UnitCustomerD1.TFK_NoMesin, dbo.DLK_T_UnitCustomerD1.TFK_Color, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_UnitCustomerD1 LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID FULL OUTER JOIN dbo.DLK_T_IncRepairH ON dbo.DLK_T_UnitCustomerD1.TFK_ID = dbo.DLK_T_IncRepairH.IRH_TFKID WHERE (dbo.DLK_T_IncRepairH.IRH_ID = '"& irhid &"') AND (dbo.DLK_T_IncRepairH.IRH_Approve1 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_Approve2 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_Approve3 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_AktifYN = 'Y')"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
    if not data.eof then
		  response.write "["
         response.write "{"
            response.write """TFKID""" & ":" &  """" & data("TFK_ID") &  """" & ","
            response.write """BRANDID""" & ":" &  """" & data("TFK_BrandID") & """" & ","
            response.write """BRANDNAME""" & ":" & """" & data("BrandName") & """" & ","
            response.write """TYPE""" & ":" & """" & data("TFK_Type") & """" & ","
            response.write """RANGKA""" & ":" &  """" & data("TFK_Norangka") &  """" & ","
            response.write """MESIN""" & ":" &  """" & data("TFK_NoMesin") &  """"  & ","
            response.write """WARNA""" & ":" &  """" & data("TFK_Color") &  """"  & ","
            response.write """NOPOL""" & ":" &  """" & data("TFK_Nopol") &  """" 
         response.write "}"
      response.write "]"
    end if

%>
