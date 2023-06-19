<!--#include file="../../init.asp"-->
<%
  pdrid = trim(Request.form("pdrid"))

  set data_cmd = Server.CreateObject("ADODB.COMMAND")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_IncRepairH.IRH_ID, dbo.DLK_T_IncRepairH.IRH_TFKID, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_M_Customer.custNama, dbo.DLK_T_ProduksiRepair.PDR_ID, dbo.DLK_M_Brand.BrandName, dbo.DLK_T_UnitCustomerD1.TFK_Type FROM dbo.DLK_M_Brand INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_M_Brand.BrandID = dbo.DLK_T_UnitCustomerD1.TFK_BrandID RIGHT OUTER JOIN dbo.DLK_T_IncRepairH INNER JOIN dbo.DLK_T_ProduksiRepair ON dbo.DLK_T_IncRepairH.IRH_ID = dbo.DLK_T_ProduksiRepair.PDR_IRHID LEFT OUTER JOIN dbo.DLK_M_Customer ON LEFT(dbo.DLK_T_IncRepairH.IRH_TFKID, 11) = dbo.DLK_M_Customer.custId ON dbo.DLK_T_UnitCustomerD1.TFK_ID = dbo.DLK_T_IncRepairH.IRH_TFKID WHERE (dbo.DLK_T_IncRepairH.IRH_Approve1 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_Approve2 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_Approve3 = 'Y') AND (dbo.DLK_T_IncRepairH.IRH_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiRepair.PDR_ID = '"&pdrid&"')"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
    if not data.eof then
		  response.write "["
         response.write "{"
            response.write """IRHID""" & ":" &  """" & data("IRH_ID") &  """" & ","
            response.write """CUSTOMER""" & ":" & """" & data("custNama") & """" & ","
            response.write """BRANDNAME""" & ":" & """" & data("BrandName") & """" & ","
            response.write """TYPE""" & ":" & """" & data("TFK_Type") & """" & ","
            response.write """NOPOL""" & ":" &  """" & data("TFK_Nopol") &  """" 
         response.write "}"
      response.write "]"
    end if

%>
