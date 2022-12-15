<!--#include file="../../Connections/cargo.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   trans = trim(Request.QueryString("trans"))

   idtrans = left(trans,16)
   idbarang = right(trans,11)

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' cek data header outgoing
   data_cmd.commandText = "SELECT * FROM DLK_T_MaterialOutH WHERE MO_ID = '"& id &"' AND MO_AktifYN = 'Y'"

   set data = data_cmd.execute

   ' cek stok barang
   data_cmd.commandText = "SELECT Brg_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& idbarang &"'"
   ' response.write data_cmd.commandText
   set stokMaster = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   if not data.eof then
      head = ""&"""ID""" & ":"  & """"& data("MO_ID") &""""& "," &"""SUCCESS""" & ":"  & """DATA HEAD TERDAFTAR""" &""

      ' cek detail barang by stok
      data_cmd.commandText = "SELECT * FROM dbo.DLK_T_MaterialOutD WHERE MO_Item = '"& idbarang &"' AND MO_ID = '"& id &"'"

      set detaildata = data_cmd.execute

      if detaildata.eof then
         ' cek hpp barang
         if stokMaster("stok") = 0  OR stokMaster("stok") < 0 then
            lstok = ","& """ERROR""" & ":" & """STOK SUDAH HABIS""" &""
         else
            lstok = ""
            ' cek barang runtutan
            data_cmd.commandText = "SELECT TOP "& stokMaster("stok") &" * FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = '"& idbarang &"' ORDER BY MR_ID ASC"
            set ckurutbarang = data_cmd.execute

            ' insert data
            data_cmd.commandText = "INSERT INTO DLK_T_MAterialOutD (MO_ID,MO_Item,MO_Qtysatuan,MO_Harga,MO_JenisSat,MO_RakID) VALUES ('"& data("MO_ID") &"', '"& ckurutbarang("MR_Item") &"', 1, '"& ckurutbarang("MR_harga") &"', '"& ckurutbarang("MR_JenisSat") &"', '"& ckurutbarang("MR_Rakid") &"')"

            set inputdata = data_cmd.execute

            masage1 = ","& """MASSAGE1""" & ":" & """DATA BERHASIL DI TAMBAHKAN""" &""
         end if   
      else
         if stokMaster("stok") = 0  OR stokMaster("stok") < 0 then
            lstok = ","& """ERROR""" & ":" & """STOK SUDAH HABIS""" &""
         else
            lstok = ""
            ' cek barang runtutan
            data_cmd.commandText = "SELECT TOP "& stokMaster("stok") &" * FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = '"& idbarang &"' ORDER BY MR_ID ASC"
            set ckurutbarang = data_cmd.execute
            
            ' update data
            data_cmd.commandText = "UPDATE DLK_T_MAterialOutD SET MO_Qtysatuan = MO_Qtysatuan + 1 where MO_ID = '"& data("MO_ID") &"' AND MO_Item = '"& ckurutbarang("MR_Item") &"'"

            set updatedata = data_cmd.execute
            masage1 = ","& """MASSAGE1""" & ":" & """DATA BERHASIL DI UPDATE""" &""
         end if 
      end if
   else
      head = ""& """ERROR""" & ":" & """DATA TIDAK TERDAFTAR""" &""
   end if

   response.write "[{" & head & lstok & masage1 &"}]"
%>