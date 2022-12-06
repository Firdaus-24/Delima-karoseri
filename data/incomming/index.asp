<!--#include file="../../Connections/cargo.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   trans1 = trim(Request.QueryString("trans1")) 'cek detail1
   trans2 = trim(LEFT(Request.QueryString("trans2"),16)) 'cek detail2

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_ID = '"& id &"' AND MR_AktifYN = 'Y'"
   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   if not data.eof then 
      strid = data("MR_ID")
      strupdateid = data("MR_updateID")

      head = ""&"""ID""" & ":"  & """"& data("MR_ID") &""""& "," &"""SUCCESS""" & ":"  & """DATA HEAD TERDAFTAR""" &""
   else
      strid = ""
      head = ""& """ERROR""" & ":" & """DATA TIDAK TERDAFTAR""" &""
   end if

   if trans1 <> "" AND strid <>  "" then
      data_cmd.CommandText = "SELECT * FROM DLK_T_MaterialReceiptD1 WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& trans1 &"'"
      ' response.write data_cmd.commandText & "<br>"
      set cktrans1 = data_cmd.execute

      if cktrans1.eof then
         data_cmd.commandText = "SELECT (IPH_ID) AS notrans  FROM (SELECT IPH_ID FROM dbo.DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' UNION ALL SELECT PDID FROM dbo.DLK_T_ProductH WHERE PDAktifYN = 'Y' ) AS U WHERE U.IPH_ID = '"& trans1 &"'"

         set ckurut = data_cmd.execute

         if not ckurut.eof then
            data_cmd.commandText = "INSERT INTO DLK_T_MaterialREceiptD1 (MR_ID,MR_Transaksi,MR_UpdateTime,MR_UpdateID) VALUES ('"& strid &"', '"& trans1 &"','"& now &"','"& strupdateid &"')"

            set dtrans1 = data_cmd.execute

            detail1 = ","& """MASSAGE1""" & ":" & """DATA BERHASIL DI TAMBAHKAN""" &""
         else
            detail1 = ","& """MASSAGE1""" & ":" & """NOMOR TRANSAKSI TIDAK DITEMUKAN""" &""
         end if
      else
         detail1 = ","& """MASSAGE1""" & ":" & """DATA SUDAH TERDAFTAR""" &""
      end if
   else
      detail1 = ""
   end if

   if trans2 <> "" AND strid <> "" then
      data_cmd.CommandText = "SELECT * FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& trans2 &"'"

      set cktrans2 = data_cmd.execute

      if cktrans2.eof then
         ' cek detail 1
         data_cmd.commandText = "SELECT * FROM DLK_T_MaterialReceiptD1 WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& LEFT(trans2,13) &"'"

         set mrd1 = data_cmd.execute

         if not mrd1.eof then
            data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemH.IPH_AktifYN FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_IPHID = '"& trans2 &"')"

            set ckurut2 = data_cmd.execute

            if not ckurut2.eof then
               harga = (ckurut2("IPH_PPN") / 100 ) * ckurut2("IPD_Harga") 
               newharga = harga + ckurut2("IPD_Harga")

               data_cmd.commandText = "INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID,MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat,MR_Nharga) VALUES ('"& strid &"', '"& trans2 &"','"& ckurut2("IPD_Item") &"',1, '"& ckurut2("IPD_Harga") &"','"& ckurut2("IPD_Jenissat") &"', '"& newharga &"')"

               set dtrans2 = data_cmd.execute

               detail2 = ","& """MASSAGE2""" & ":" & """DATA BERHASIL DI TAMBAHKAN""" &""
            else
               detail2 = ","& """MASSAGE2""" & ":" & """NO TRANSAKSI TIDAK TERDAFTAR""" &""
            end if
         else
            detail2 = ","& """MASSAGE2""" & ":" & """NO TRANSAKSI TIDAK SESUAI DENGAN NOMOR FAKTUR""" &""
         end if
      else
         ' cek detail 1
         data_cmd.commandText = "SELECT * FROM DLK_T_MaterialReceiptD1 WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& LEFT(trans2,13) &"'"

         set mrd1 = data_cmd.execute

         if not mrd1.eof then
            data_cmd.commandText = "SELECT MR_Qtysatuan + 1 as qty FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& trans2 &"' "

            set ckqty = data_cmd.execute

            data_cmd.commandText = "UPDATE DLK_T_MaterialReceiptD2 SET MR_Qtysatuan = "& ckqty("qty") &" WHERE MR_ID = '"& strid &"' AND MR_Transaksi = '"& trans2 &"'"

            set updateqty = data_cmd.execute

            detail2 = ","& """MASSAGE2""" & ":" & """BERHASIL DIUPDATE""" &""
         else
            detail2 = ","& """MASSAGE2""" & ":" & """NO TRANSAKSI TIDAK SESUAI DENGAN NOMOR FAKTUR""" &""
         end if
      end if
   else
      detail2 = ""
   end if
   response.write "[{" & head & detail1 & detail2 &"}]"
%>