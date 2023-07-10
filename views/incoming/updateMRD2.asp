<!--#include file="../../init.asp"-->
<% 
   if session("INV2B") = false then
      Response.Redirect("./")
   end if

   id = trim(Request.form("id"))
   trans = trim(Request.form("trans"))
   rak = trim(Request.form("rak"))
   acpdate = trim(Request.form("acpdate"))
   qtylama = trim(Request.Form("qtylama"))
   qty = trim(Request.form("qty"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"' AND MR_Qtysatuan = "& qtylama &" AND MR_Acpdate = '"& acpdate &"'"
   set data = data_cmd.execute

   if not data.eof then
      
      ' cek stok barang
      data_cmd.commandText = "SELECT Brg_Nama, ISNULL((SELECT MR_Harga as harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID GROUP BY MR_Harga),0) as harga,ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& data("MR_Item") &"'"
      ' response.write data_cmd.commandText
      set stokMaster = data_cmd.execute

      ' cek harga di po 
      data_cmd.commandTExt = "SELECT dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_Qtysatuan, dbo.DLK_T_OrPemD.OPD_Harga FROM dbo.DLK_T_OrPemH INNER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemD.OPD_OPHID = '"& trans &"') AND (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y')"
      ' Response.Write data_cmd.commandTExt
      set ckharga = data_cmd.execute 

      ' cek barang yang sudah masuk ke mr
      data_cmd.commandTExt = "SELECT SUM(ISNULL(MR_Qtysatuan, 0)) AS qtymr FROM dbo.DLK_T_MaterialReceiptD2 WHERE MR_Transaksi = '"& trans &"'"
  
      set mrincome = data_cmd.execute

      if qty = qtylama then
         response.write "TIDAK ADA PERUBAHAN DI TERANSAKSI INCOMMING"
         Response.end
      end if

      totalupdate = mrincome("qtymr") - qtylama + qty

      if not ckharga.eof then
         if Cint(ckharga("OPD_Qtysatuan")) < Cint(totalupdate) then
            response.write "QTY MELEBIHI BATAS PEMBELIAN"
            Response.end
         end if
         if Cint(stokMaster("stok")) > 0 then
            ckhargastok = Round(stokMaster("harga") * stokMaster("stok")) 
            pengurang = qtylama - qty 

            hargapengurang = pengurang * ckharga("OPD_Harga") 

            thargamr = ckhargastok - hargapengurang 
            stokbaru = stokMaster("stok") - pengurang 
            realharga = Round(thargamr / stokbaru)
            
            call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '" & realharga &"' WHERE MR_Item = '"& data("MR_Item") &"'")
            call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Qtysatuan = "& qty &", MR_RakID = '"& rak &"' WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"' AND MR_Qtysatuan = '"& qtylama &"' AND MR_acpdate = '"& acpdate &"' ")

            response.write "DONE"
         elseIf Cint(stokMaster("stok")) = 0 then
            ' cek jumlah data detail
            data_cmd.commandTExt = "SELECT dbo.DLK_T_OrPemH.OPH_Asuransi, dbo.DLK_T_OrPemH.OPH_Lain, COUNT(dbo.DLK_T_OrPemD.OPD_OPHID) AS datapo FROM dbo.DLK_T_OrPemH INNER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_ID = '"& left(trans,13) &"') GROUP BY dbo.DLK_T_OrPemH.OPH_Asuransi, dbo.DLK_T_OrPemH.OPH_Lain, dbo.DLK_T_OrPemH.OPH_AktifYN HAVING (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y')"

            set ckdatapo = data_cmd.execute

            asuransilain = (ckdatapo("OPH_asuransi") + ckdatapo("OPH_Lain")) / ckdatapo("datapo")
            hppawal = Round(ckharga("OPD_Harga") * qty) + asuransilain
            hargabaru = hppawal / qty

            call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Qtysatuan = "& qty &", MR_RakID = '"& rak &"', MR_harga = '"& hargabaru &"' WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"' AND MR_Qtysatuan = '"& qtylama &"' AND MR_acpdate = '"& acpdate &"' ")

            Response.Write "DATA STOK DARI 0 SUDAH TERUPDATE"
         end if

      else
         response.write "DATA TIDAK TERDAFTAR DI PURCHASING"
      end if
   else
      response.write "DATA TIDAK TERDAFTAR"
   end if
%>