<% 
   sub incomePo()
      id = trim(Request.Form("mrid"))
      str = Split(trim(Request.Form("opdophid")),",")
      acpdate = trim(Request.Form("acpdate"))
      qty = trim(Request.Form("qtyincomed"))
      satuan = trim(Request.Form("satuan"))
      rak = trim(Request.Form("rak"))

      ophid = left(str(0),13) 
      opdophid = trim(str(0))
      brgid = trim(str(1))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' AND OPH_ID = '"& ophid &"'"
      ' Response.Write data_cmd.commandTExt & "<br>"
      set data = data_cmd.execute


      if not data.eof then
         ' cek berapa item yang di beli di header
         data_cmd.commandTExt = "SELECT OPD_OPHID FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("OPH_ID") &"'"
         set ckdatadetail = data_cmd.execute 

         datadetail = 0 'untuk cek ada berapa item yang di beli lalu di bagi ke asuransi dan lain2
         do while not ckdatadetail.eof 
            datadetail = datadetail + 1
         response.flush
         ckdatadetail.movenext
         loop

         ' setting pembagi lain2 dan asuransi 
         asuransilain = (data("OPH_asuransi") + data("OPH_Lain")) / datadetail

         ' cek header MR
         data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_ID = '"& id &"'"
         ' response.write data_cmd.commandText
         set ckheader = data_cmd.execute

         if not ckheader.eof then
            ' cek detail 1
            data_cmd.commandText = "SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD1 WHERE MR_Transaksi = '"& ophid &"' AND MR_ID = '"& ckheader("MR_ID") &"'"
            set document = data_cmd.execute

            ' cek stok barang
            data_cmd.commandText = "SELECT Brg_Nama, ISNULL((SELECT MR_Harga as harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID GROUP BY MR_Harga),0) as harga,ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& brgid &"'"
            ' response.write data_cmd.commandText
            set stokMaster = data_cmd.execute

            ' cek harga & qty di po 
            data_cmd.commandTExt = "SELECT OPD_Harga, OPD_Qtysatuan FROM DLK_T_OrpemD WHERE OPD_OPHID = '"& opdophid &"'"
            set ckharga = data_cmd.execute

            if document.eof then
               ' insert detail 1
               call query("INSERT INTO DLK_T_MaterialREceiptD1 (MR_ID,MR_Transaksi,MR_UpdateID) VALUES ('"& ckheader("MR_ID") &"', '"& data("OPH_ID") &"','"& session("userID") &"')")

               if Cint(stokMaster("stok")) = 0 then
                  ' cek harga baru
                  hppawal = Round(ckharga("OPD_Harga") * qty) + asuransilain

                  hargabaru = hppawal / qty

                  call query("INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID, MR_AcpDate, MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& acpdate &"','"& opdophid &"','"& brgid &"', "& qty &",'"& hargabaru &"','"& satuan &"', '"& rak &"')")
               else

                  hppmr = stokMaster("harga") * stokMaster("stok")
                  hpppo = ckharga("OPD_Harga") * qty

                  hargabaru = Round((hppmr + hpppo + asuransilain) / (qty + stokMaster("stok")))
                  
                  call query("INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID, MR_AcpDate, MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& acpdate &"','"& opdophid &"','"& brgid &"', "& qty &",'"& hargabaru &"','"& satuan &"', '"& rak &"')") 

                  ' update smua harga di MR
                  call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '"& hargabaru &"' WHERE MR_Item = '"& brgid &"'")
               end if
            else
               if Cint(stokMaster("stok")) = 0 then
                  ' cek harga baru
                  hppawal = Round(ckharga("OPD_Harga") * qty) + asuransilain
                  hargabaru = hppawal / qty

                  call query("INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID, MR_AcpDate, MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& acpdate &"','"& opdophid &"','"& brgid &"', "& qty &",'"& hargabaru &"','"& satuan &"', '"& rak &"')")
               else
                  hppmr = stokMaster("harga") * stokMaster("stok")
                  hpppo = ckharga("OPD_Harga") * qty

                  hargabaru = Round((hppmr + hpppo + asuransilain) / (qty + stokMaster("stok")))
                  
                  call query("INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID, MR_AcpDate, MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& acpdate &"','"& opdophid &"','"& brgid &"', "& qty &",'"& hargabaru &"','"& satuan &"', '"& rak &"')")
                  ' update smua harga di MR
                  call query("UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '"& hargabaru &"' WHERE MR_Item = '"& brgid &"'")
               end if
            end if
            call alert("DATA TRANSAKSI INCOMMING", "Berhasil Ditambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
         else
            call alert("DATA HEADER TIDAK TERDAFTAR", "Erorr", "error",Request.ServerVariables("HTTP_REFERER")) 
         end if

      end if

   end sub


   sub updateincomepo()
      id = trim(Request.Form("id"))
      fakturH = trim(Request.Form("fakturH"))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' AND OPH_ID = '"& fakturH &"'"

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
               call query("INSERT INTO DLK_T_MaterialREceiptD1 (MR_ID,MR_Transaksi,MR_UpdateID) VALUES ('"& ckheader("MR_ID") &"', '"& data("OPH_ID") &"','"& session("userID") &"')")

               ' cek data detail barang yang di terima
               data_cmd.commandTExt = "SELECT * FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("OPH_ID") &"'"

               set ckurut2 = data_cmd.execute

               do while not ckurut2.eof
                  ' cek stok barang
                  data_cmd.commandText = "SELECT Brg_Nama, ISNULL((SELECT MR_Harga as harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID GROUP BY MR_Harga),0) as harga,ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0) as stok FROM DLK_M_Barang WHERE Brg_ID =  '"& ckurut2("OPD_Item") &"'"
                  ' response.write data_cmd.commandText
                  set stokMaster = data_cmd.execute
                  
                  ' total pembelian peritem by tanggal pembelian
                  data_cmd.commandText = "SELECT DLK_T_OrPemD.OPD_QtySatuan, SUM(dbo.DLK_T_OrPemD.OPD_Harga * dbo.DLK_T_OrPemD.OPD_qtysatuan) AS pembelian FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OphID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemD.OPD_OphID = '"& ckurut2("OPD_OPHID") &"') GROUP BY  DLK_T_OrPemD.OPD_QtySatuan"

                  set ckpembelian = data_cmd.execute

                  ' cek total pembelian pertanggal
                  data_cmd.commandText = "SELECT SUM(dbo.DLK_T_OrPemD.OPD_Harga * dbo.DLK_T_OrPemD.OPD_QtySatuan) AS tpembelian, dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_Lain, dbo.DLK_T_OrPemH.OPH_Asuransi FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OphID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemH.OPH_ID = '"& LEFT(ckurut2("OPD_OPHID"),13) &"') GROUP BY dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_Lain, dbo.DLK_T_OrPemH.OPH_Asuransi"
                  ' response.write data_cmd.commandText
                  set tpembelian = data_cmd.execute

                  ' cek hpp barang
                  if Cint(stokMaster("stok")) = 0 then
                     cksaldo = 0
                     saldoawal = 0
                     qtysaldo = 0
                     
                     thpp = Round((ckpembelian("pembelian") / tpembelian("tpembelian")) * (tpembelian("OPH_Lain") + tpembelian("OPH_asuransi")))
                     hpp = Round((ckpembelian("pembelian") + thpp) / ckpembelian("OPD_Qtysatuan"))
                  else
                     cksaldo = stokMaster("harga") * stokMaster("stok")
                     saldoawal = cksaldo + ckpembelian("pembelian")

                     qtysaldo = stokMaster("stok") + ckpembelian("OPD_QtySatuan")

                     hpp = Round(saldoawal / qtysaldo)

                  end if                  
                  ' input data barang masuk
                  data_cmd.commandText = "INSERT INTO DLK_T_MaterialREceiptD2 (MR_ID,MR_AcpDate,MR_Transaksi,MR_Item,MR_Qtysatuan,MR_Harga,MR_JenisSat, MR_RakID) VALUES ('"& id &"', '"& now &"', '"& ckurut2("OPD_OPHID") &"','"& ckurut2("OPD_Item") &"', "& ckurut2("OPD_Qtysatuan") &",'"& hpp &"','"& ckurut2("OPD_Jenissat") &"', '"& rak &"')"

                  set dtrans2 = data_cmd.execute

                  ' update harga sisa stok by hpp
                  if stokMaster("stok") <> 0 then
                     ' get harga baru
                     data_cmd.commandText = "SELECT MR_Harga FROM DLK_T_MaterialREceiptD2 WHERE MR_ID = '"& id &"' AND MR_Item = '"& ckurut2("OPD_Item") &"'"

                     set hargabaru = data_cmd.execute

                     ' update harga smua item sisa stok
                     data_cmd.commandText = "UPDATE DLK_T_MaterialReceiptD2 SET MR_Harga = '"& hargabaru("MR_Harga") &"' WHERE MR_Item = '"& ckurut2("OPD_Item") &"'"

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