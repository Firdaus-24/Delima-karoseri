<!--#include file="../init.asp"-->
<% 
   id = trim(Request.form("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.*, DLK_M_Kebutuhan.K_ID, DLK_M_Kebutuhan.K_Name FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_OrPemH.OPH_KID = DLK_M_Kebutuhan.K_ID WHERE OPH_AktifYN = 'Y' AND OPH_ID = '"& id &"'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   if not data.eof then
         response.write "{"   
            response.write """ID""" & ":" & """" & data("OPH_ID") &  """" & ","
            response.write """CABANG""" & ":" & """" & data("OPH_AgenID") &  """" & ","
            response.write """DATE""" & ":" & """" & data("OPH_Date") &  """" & ","
            response.write """JTDATE""" & ":" & """" & data("OPH_JTDate") &  """" & ","
            response.write """VENDOR""" & ":" & """" & data("OPH_VenID") &  """" & ","
            response.write """PPN""" & ":" & """" & data("OPH_PPN") &  """" & ","
            response.write """ASURANSI""" & ":" & """" & data("OPH_ASURANSI") &  """" & ","
            response.write """LAIN""" & ":" & """" & data("OPH_LAIN") &  """" & ","
            response.write """DISKONALL""" & ":" & """" & data("OPH_DiskonALL") &  """" & ","
            response.write """KEBUTUHANLABEL""" & ":" & """" & data("K_NAME") &  """" & ","
            response.write """KEBUTUHANID""" & ":" & """" & data("K_ID") &  """" & ","
            response.write """KETERANGAN""" & ":" & """" & data("OPH_Keterangan") &  """" 
         response.write "}"
   else
      response.write "{}"
   end if

%>