<!--#include file="../../Connections/cargo.asp"-->
<% 
   id = LEFT(trim(Request.queryString("id")),16) 

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string 

   data_cmd.CommandText = "SELECT dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_InvPemH.IPH_ID, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_InvPemH.IPH_AktifYN, DLK_T_InvPemH.IPH_Date, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.GLB_M_Agen RIGHT OUTER JOIN dbo.DLK_T_InvPemH ON dbo.GLB_M_Agen.AgenID = dbo.DLK_T_InvPemH.IPH_AgenId LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_VenId = dbo.DLK_M_Vendor.Ven_ID RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_InvPemD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.kategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE (dbo.DLK_T_InvPemD.IPD_IphID = '"& id &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y')"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
      if not data.eof then
		response.write "["
         response.write "{"
            response.write """ID""" & ":" &  """" & data("IPD_IPHID") &  """" & ","
            response.write """KODE BARANG""" & ":" &  """" & data("kategoriNama") & "-" & data("JenisNama") &  """" & ","
            response.write """BARANG""" & ":" & """" & data("Brg_Nama") & """" & ","
            response.write """CABANG""" & ":" &  """" & data("AgenName") &  """" & ","
            response.write """VENDOR""" & ":" &  """" & data("Ven_Nama") &  """"  & ","
            response.write """SATUAN""" & ":" &  """" & data("Sat_Nama") &  """"  & ","
            response.write """TANGGAL BELI""" & ":" &  """" & data("IPH_Date") &  """" 
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