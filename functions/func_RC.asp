<% 
sub tambahRC()
   tgl = trim(Request.Form("tgl"))
   pddid = trim(Request.Form("pddid"))
   mp = trim(Request.Form("mp"))
   keterangan = trim(Request.Form("keterangan"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_T_RCProdH WHERE RC_Date = '"& tgl &"' AND RC_PDDID = '"& pddid &"' AND RC_MP = "& mp &""

   set data = data_cmd.execute

   if data.eof then
      data_cmd.commandText = "exec sp_AddDLK_T_RCProdH '"& pddid &"', '"& tgl &"', "& mp &", '"& session("userid") &"', '"& keterangan &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      call alert("TRANSAKSI PENERIMAAN BARANG", "berhasil di tambahkan", "success","rcd_add.asp?id="&id)
   else 
      call alert("TRANSAKSI PENERIMAAN BARANG", "sudah terdaftar!!", "error","rc_add.asp")
   end if
end sub

sub detailrc()
   rcid = trim(Request.Form("rcid"))
   tgl = Cdate(trim(Request.Form("tgl")))
   brg = trim(Request.Form("item"))
   qtty = trim(Request.Form("qtty"))
   satuan = trim(Request.Form("satuan"))
   harga = trim(Request.Form("harga"))
   penerima = trim(Request.Form("penerima"))

   data_cmd.commandText = "SELECT * FROM DLK_T_RCProdD WHERE LEFT(RCD_ID,10) = '"&rcid&"' AND RCD_Date = '"& tgl &"' AND RCD_Item = '"& brg &"'"

   set data = data_cmd.execute

   if data.eof then
      ' cek nomor buntut
      data_cmd.commandText = "Select ('"& rcid &"' + Right('0000' + Convert(varchar,Convert(int,(Right(isnull(Max(RCD_ID),'0000'),4)))+1),4)) as newid From DLK_T_RCProdD Where Left(RCD_ID,10)= '"& rcid &"'"

      set p = data_cmd.execute

      call query ("INSERT INTO DLK_T_RCProdD (RCD_ID, RCD_Date, RCD_Item, RCD_Qtysatuan,RCD_SatID,RCD_Received, RCD_Harga) VALUES ('"& p("newid") &"', '"& tgl &"', '"& brg &"', "& qtty &", '"& satuan &"', '"& penerima &"', '"& harga &"')")
      call alert("DETAIL TRANSAKSI PENERIMAAN BARANG", "berhasil di tambahkan", "success","rcd_add.asp?id="&rcid)
   else
      call alert("DETAIL TRANSAKSI PENERIMAAN BARANG", "sudah terdaftar!!", "error","rcd_add.asp?id="&rcid)
   end if
end sub

sub updaterc()
   rcid = trim(Request.Form("rcid"))
   tgl = Cdate(trim(Request.Form("tgl")))
   brg = trim(Request.Form("item"))
   qtty = trim(Request.Form("qtty"))
   harga = trim(Request.Form("harga"))
   satuan = trim(Request.Form("satuan"))
   penerima = trim(Request.Form("penerima"))

   data_cmd.commandText = "SELECT * FROM DLK_T_RCProdD WHERE LEFT(RCD_ID,10) = '"&rcid&"' AND RCD_Date = '"& tgl &"' AND RCD_Item = '"& brg &"'"

   set data = data_cmd.execute

   if data.eof then
      ' cek nomor buntut
      data_cmd.commandText = "Select ('"& rcid &"' + Right('0000' + Convert(varchar,Convert(int,(Right(isnull(Max(RCD_ID),'0000'),4)))+1),4)) as newid From DLK_T_RCProdD Where Left(RCD_ID,10)= '"& rcid &"'"

      set p = data_cmd.execute

      call query ("INSERT INTO DLK_T_RCProdD (RCD_ID, RCD_Date, RCD_Item, RCD_Qtysatuan,RCD_SatID,RCD_Received, RC_harga) VALUES ('"& p("newid") &"', '"& tgl &"', '"& brg &"', "& qtty &", '"& satuan &"', '"& penerima &"', '"& harga &"')")
      call alert("DETAIL TRANSAKSI PENERIMAAN BARANG", "berhasil di tambahkan", "success","rcd_u.asp?id="&rcid)
   else
      call alert("DETAIL TRANSAKSI PENERIMAAN BARANG", "sudah terdaftar!!", "error","rcd_u.asp?id="&rcid)
   end if
end sub
%>