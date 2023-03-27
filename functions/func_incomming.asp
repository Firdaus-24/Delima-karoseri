<% 
   sub tambahIncome()
      id = trim(Request.Form("id"))
      fakturH = trim(Request.Form("fakturH"))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND IPH_ID = '"& fakturH &"'"

      set data = data_cmd.execute

      if not data.eof then
         data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_ID = '"& id &"'"
         ' response.write data_cmd.commandText
         set ckheader = data_cmd.execute
         ' cek ckheader MR
         if not ckheader.eof then
            data_cmd.commandText = "SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD1 WHERE MR_Transaksi = '"& fakturH &"' AND MR_ID = '"& ckheader("MR_ID") &"'"
            set document = data_cmd.execute
            ' cek detail 1
            if document.eof then
               ' insert detail 1
               call query("INSERT INTO DLK_T_MaterialREceiptD1 (MR_ID,MR_Transaksi,MR_UpdateID) VALUES ('"& ckheader("MR_ID") &"', '"& data("IPH_ID") &"','"& session("userID") &"')")

               ' cek data detail barang yang di terima
               data_cmd.commandTExt = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"'"

               set ckurut2 = data_cmd.execute

               do while not ckurut2.eof
                  ' cek stok barang
                  data_cmd.commandText = "SELECT Brg_Nama, ISNULL((SELECT MR_Harga as harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID GROUP BY MR_Harga),0) as harga,ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& ckurut2("IPD_Item") &"'"
                  ' response.write data_cmd.commandText
                  set stokMaster = data_cmd.execute
                  
                  ' total pembelian peritem by tanggal pembelian
                  data_cmd.commandText = "SELECT DLK_T_InvPemD.IPD_QtySatuan, SUM(dbo.DLK_T_InvPemD.IPD_Harga * dbo.DLK_T_InvPemD.IPD_qtysatuan) AS pembelian FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_IphID = '"& ckurut2("IPD_IPHID") &"') GROUP BY  DLK_T_InvPemD.IPD_QtySatuan"

                  set ckpembelian = data_cmd.execute

                  ' cek total pembelian pertanggal
                  data_cmd.commandText = "SELECT SUM(dbo.DLK_T_InvPemD.IPD_Harga * dbo.DLK_T_InvPemD.IPD_QtySatuan) AS tpembelian, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_Lain, dbo.DLK_T_InvPemH.IPH_Asuransi FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_ID = '"& LEFT(ckurut2("IPD_IPHID"),13) &"') GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_Lain, dbo.DLK_T_InvPemH.IPH_Asuransi"
                  ' response.write data_cmd.commandText
                  set tpembelian = data_cmd.execute

                  ' cek hpp barang
                  if Cint(stokMaster("stok")) = 0 then
                     cksaldo = 0
                     saldoawal = 0
                     qtysaldo = 0
                     
                     thpp = Round((ckpembelian("pembelian") / tpembelian("tpembelian")) * (tpembelian("IPH_Lain") + tpembelian("IPH_asuransi")))
                     hpp = Round((ckpembelian("pembelian") + thpp) / ckpembelian("IPD_Qtysatuan"))
                  else
                     cksaldo = stokMaster("harga") * stokMaster("stok")
                     saldoawal = cksaldo + ckpembelian("pembelian")

                     qtysaldo = stokMaster("stok") + ckpembelian("IPD_QtySatuan")

                     hpp = Round(saldoawal / qtysaldo)

                  end if                  
                  ' input data barang masuk
                  data_cmd.commandText = "INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID, MR_AcpDate, MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& now &"','"& ckurut2("IPD_IPHID") &"','"& ckurut2("IPD_Item") &"', "& ckurut2("IPD_Qtysatuan") &",'"& hpp &"','"& ckurut2("IPD_Jenissat") &"', '"& rak &"')"

                  set dtrans2 = data_cmd.execute

                  ' update harga sisa stok by hpp
                  ' if stokMaster("stok") <> 0 then
                  '    ' get harga baru
                  '    data_cmd.commandText = "SELECT MR_Harga FROM DLK_T_MaterialREceiptD2 WHERE MR_ID = '"& id &"' AND MR_Item = '"& ckurut2("IPD_Item") &"'"

                  '    set hargabaru = data_cmd.execute

                     ' update harga smua item sisa stok
                     data_cmd.commandText = "UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '"& hpp &"' WHERE MR_Item = '"& ckurut2("IPD_Item") &"'"
                     ' response.write data_cmd.commandText & "<br>"
                     set updateharga = data_cmd.execute
                  ' end if

               response.flush
               ckurut2.movenext
               loop
               call alert("DATA TRANSAKSI INCOMMING", "Berhasil Ditambahkan", "success","incomed_add.asp?id="&id) 
            else
               call alert("DATA TRANSAKSI SUDAH TERDAFTAR", "Erorr", "error","incomed_add.asp?id="&id) 
            end if
         else
            call alert("DATA HEADER TIDAK TERDAFTAR", "Erorr", "error","index.asp") 
         end if
      else
         call alert("DATA TRANSAKSI TIDAK TERDAFTAR", "Erorr", "error","incomed_add.asp?id="&id) 
      end if
   end sub

   sub updateIncome()
      id = trim(Request.Form("id"))
      fakturH = trim(Request.Form("fakturH"))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND IPH_ID = '"& fakturH &"'"

      set data = data_cmd.execute

      if not data.eof then
         data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_ID = '"& id &"'"
         ' response.write data_cmd.commandText
         set ckheader = data_cmd.execute
         ' cek ckheader MR
         if not ckheader.eof then
            data_cmd.commandText = "SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD1 WHERE MR_Transaksi = '"& fakturH &"' AND MR_ID = '"& ckheader("MR_ID") &"'"
            set document = data_cmd.execute
            ' cek detail 1
            if document.eof then
               ' insert detail 1
               call query("INSERT INTO DLK_T_MaterialREceiptD1 (MR_ID,MR_Transaksi,MR_UpdateID) VALUES ('"& ckheader("MR_ID") &"', '"& data("IPH_ID") &"','"& session("userID") &"')")

               ' cek data detail barang yang di terima
               data_cmd.commandTExt = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"'"

               set ckurut2 = data_cmd.execute

               do while not ckurut2.eof
                  ' cek stok barang
                  data_cmd.commandText = "SELECT Brg_Nama, ISNULL((SELECT MR_Harga as harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID GROUP BY MR_Harga),0) as harga,ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& ckurut2("IPD_Item") &"'"
                  ' response.write data_cmd.commandText
                  set stokMaster = data_cmd.execute
                  
                  ' total pembelian peritem by tanggal pembelian
                  data_cmd.commandText = "SELECT DLK_T_InvPemD.IPD_QtySatuan, SUM(dbo.DLK_T_InvPemD.IPD_Harga * dbo.DLK_T_InvPemD.IPD_qtysatuan) AS pembelian FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_IphID = '"& ckurut2("IPD_IPHID") &"') GROUP BY  DLK_T_InvPemD.IPD_QtySatuan"

                  set ckpembelian = data_cmd.execute

                  ' cek total pembelian pertanggal
                  data_cmd.commandText = "SELECT SUM(dbo.DLK_T_InvPemD.IPD_Harga * dbo.DLK_T_InvPemD.IPD_QtySatuan) AS tpembelian, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_Lain, dbo.DLK_T_InvPemH.IPH_Asuransi FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_ID = '"& LEFT(ckurut2("IPD_IPHID"),13) &"') GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_Lain, dbo.DLK_T_InvPemH.IPH_Asuransi"
                  ' response.write data_cmd.commandText
                  set tpembelian = data_cmd.execute

                  ' cek hpp barang
                  if Cint(stokMaster("stok")) = 0 then
                     cksaldo = 0
                     saldoawal = 0
                     qtysaldo = 0
                     
                     thpp = Round((ckpembelian("pembelian") / tpembelian("tpembelian")) * (tpembelian("IPH_Lain") + tpembelian("IPH_asuransi")))
                     hpp = Round((ckpembelian("pembelian") + thpp) / ckpembelian("IPD_Qtysatuan"))
                  else
                     cksaldo = stokMaster("harga") * stokMaster("stok")
                     saldoawal = cksaldo + ckpembelian("pembelian")

                     qtysaldo = stokMaster("stok") + ckpembelian("IPD_QtySatuan")

                     hpp = Round(saldoawal / qtysaldo)

                  end if                  
                  ' input data barang masuk
                  data_cmd.commandText = "INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID,MR_AcpDate,MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& now &"', '"& ckurut2("IPD_IPHID") &"','"& ckurut2("IPD_Item") &"', "& ckurut2("IPD_Qtysatuan") &",'"& hpp &"','"& ckurut2("IPD_Jenissat") &"', '"& rak &"')"

                  set dtrans2 = data_cmd.execute

                  ' update harga sisa stok by hpp
                  if stokMaster("stok") <> 0 then
                     ' get harga baru
                     data_cmd.commandText = "SELECT MR_Harga FROM DLK_T_MaterialREceiptD2 WHERE MR_ID = '"& id &"' AND MR_Item = '"& ckurut2("IPD_Item") &"'"

                     set hargabaru = data_cmd.execute

                     ' update harga smua item sisa stok
                     data_cmd.commandText = "UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '"& hargabaru("MR_Harga") &"' WHERE MR_Item = '"& ckurut2("IPD_Item") &"'"

                     set updateharga = data_cmd.execute
                  end if

               response.flush
               ckurut2.movenext
               loop
               call alert("DATA TRANSAKSI INCOMMING", "Berhasil Ditambahkan", "success","income_u.asp?id="&id) 
            else
               call alert("DATA TRANSAKSI SUDAH TERDAFTAR", "Erorr", "error","income_u.asp?id="&id) 
            end if
         else
            call alert("DATA HEADER TIDAK TERDAFTAR", "Erorr", "error","index.asp") 
         end if
      else
         call alert("DATA TRANSAKSI TIDAK TERDAFTAR", "Erorr", "error","income_u.asp?id="&id) 
      end if
   end sub
%>