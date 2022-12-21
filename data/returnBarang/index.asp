<!--#include file="../../Connections/cargo.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   trans = trim(Request.QueryString("trans"))

   trans1 = left(trans,13)
   trans2 = left(trans,16)
   itemID = Right(trans,11)

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' cek data header return barang
   data_cmd.commandText = "SELECT * FROM DLK_T_ReturnBarangH WHERE RB_ID = '"& id &"' AND RB_aktifYN = 'Y'"
   set data = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   if not data.eof then 
      strheader = ""&"""ID""" & ":"  & """"& data("RB_ID") &""""& "," &"""SUCCESS""" & ":"  & """DATA HEADER TERDAFTAR""" &""

      if trans <> "" then
      ' cek data sudah masuk gudang apa belum
      data_cmd.commandText = "SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD2 WHERE MR_Transaksi = '"& trans2 &"' AND MR_Item = '"& itemID &"'"
      set ckmr = data_cmd.execute

      if not ckmr.eof then
         detailMR = ""&","& """ERROR MR""" & ":" & """DATA SUDAH TERDAFTAR DIINVENTORY PASTIKAN UPDATE DATA TERLEBIH DAHULU!""" &""
      else
         detailMR = ""
         ' data transaksi pembelian
         data_cmd.commandText = "SELECT dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_VenId, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemD.IPD_IphID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("RB_AgenID") &"' AND dbo.DLK_T_InvPemH.IPH_VenID = '"& data("RB_VenID") &"' AND dbo.DLK_T_InvPemD.IPD_IphID = '"& trans2 &"'"
         ' response.write data_cmd.commandText 
         set detail = data_cmd.execute
            if not detail.eof then
               detail1 = ""
               ' cek data detail
               data_cmd.commandText = "SELECT * FROM DLK_T_ReturnBarangD WHERE LEFT(RBD_RBID,12) = '"& data("RB_ID") &"' AND RBD_IPDIPHID = '"& trans2 &"' AND RBD_Item = '"& itemID &"'"
               ' response.write data_cmd.commandText & "<br>"
               set ckreturnDetail = data_cmd.execute
               
               if not ckreturnDetail.eof then
                  if cint(detail("IPD_qtysatuan")) = Cint(ckreturnDetail("RBD_Qtysatuan")) OR Cint(ckreturnDetail("RBD_Qtysatuan")) > cint(detail("IPD_qtysatuan")) then
                     detailRBD = ""&","& """ERROR""" & ":" & """QUANTITY MELEBIHI BATAS""" &""
                  else
                     data_cmd.commandText = "UPDATE DLK_T_ReturnBArangD SET RBD_Qtysatuan = RBD_Qtysatuan + 1 WHERE RBD_RBID = '"& ckreturnDetail("RBD_RBID") &"'"

                     set updatedata = data_cmd.execute

                     detailRBD = ""&","& """SUCCESS""" & ":" & """DATA BERHASIL DI UPDATE""" &""
                  end if
               else
               ' cari detail id 
               data_cmd.commandText = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(RBD_RBID),'000'),3)))+1),3)) as detailid FROM DLK_T_ReturnBarangD WHERE LEFT(RBD_RBID,12) = '"& data("RB_ID") &"'"

               set ckid = data_cmd.execute

               ' insert data detail
               data_cmd.commandText = "INSERT INTO DLK_T_ReturnBarangD (RBD_RBID,RBD_IPDIPHID,RBD_Item,RBD_QtySatuan,RBD_Harga,RBD_JenisSat,RBD_PPN,RBD_Disc1,RBD_Disc2) VALUES ('"& ckid("detailid") &"', '"& detail("IPD_IPHID") &"', '"& detail("IPD_Item") &"', 1 , '"& detail("IPD_Harga") &"', '"& detail("IPD_JenisSat") &"', '"& detail("IPH_PPN") &"', '"& detail("IPD_Disc1") &"', '"& detail("IPD_Disc2") &"')"

               set insert = data_cmd.execute

               detailRBD = ""&","& """SUCCESS""" & ":" & """DATA BERHASIL DI DITAMBAHKAN""" &""
               end if
            else
               detail1 = ""&","& """ERROR""" & ":" & """NOMOR TRANSAKSI TIDAK TERDAFTAR / VENDOR TIDAK SESUAI""" &""
            end if
         end if
      end if
   else
      strheader = ""& """ERROR""" & ":" & """DATA HEADER TIDAK TERDAFTAR"""&""
   end if

   response.write "[{" & strheader & detailMR & detail1 & detailRBD &"}]"
%>