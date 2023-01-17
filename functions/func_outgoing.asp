<% 
   Sub tambahOutgoing()
      bmhid = trim(Request.Form("bmhid"))
      agen = trim(Request.Form("agen"))
      tgl = trim(Request.Form("tgl"))
      keterangan = trim(Request.Form("keterangan"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.commandText = "SELECT * FROM DLK_T_MaterialOutH WHERE MO_BMHID = '"& bmhid &"' AND MO_AgenID = '"& agen &"' AND MO_Date = '"& tgl &"' AND MO_AktifYN = 'Y'"
      ' response.write data_cmd.commandText & "<br>"
      set data = data_cmd.execute

      if data.eof then
         data_cmd.commandText = "exec sp_AddDLK_T_materialOutH '"& bmhid &"','"& agen &"', '"& tgl &"', '"& keterangan &"', '', '"& session("userid") &"', '"& now &"'"
         ' response.write data_cmd.commandText & "<br>"
         set p = data_cmd.execute

         id = p("ID")

         value = 1 'case untuk insert data
      else
         value = 2 'case jika gagal insert 
      end if

      if value = 1 then
         call alert("PROSES OUTGOIN", "berhasil ditambahkan", "success","outd_add.asp?id="&id) 
      elseif value = 2 then
         call alert("PROSES OUTGOIN", "sudah terdaftar", "warning","outd_add.asp?id="&id)
      else
         value = 0
      end if
   End Sub

   sub DetailOutgoing()
      id = trim(Request.Form("id"))
      ckbrgid = trim(Request.Form("ckbrgid"))
      harga = trim(Request.Form("harga"))
      qty = trim(Request.Form("qty"))
      dsatuan = trim(Request.Form("dsatuan"))
      rak = trim(Request.Form("rak"))
      tgl = trim(Request.Form("tgl"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.commandText = "SELECT * FROM dbo.DLK_T_MaterialOutD WHERE MO_Item = '"& ckbrgid &"' AND MO_ID = '"& id &"' AND MO_Date = '"& tgl &"'"

      set detaildata = data_cmd.execute

      if detaildata.eof then
         call query("INSERT INTO DLK_T_MAterialOutD (MO_ID,MO_Date,MO_Item,MO_Qtysatuan,MO_Harga,MO_JenisSat,MO_RakID) VALUES ('"& id &"', '"& tgl &"', '"& ckbrgid &"', "& qty &", '"& harga &"', '"& dsatuan &"', '"& rak &"')")

         call alert("DETAIL BARANG OUTGOIN", "berhasil ditambahkan", "success","outd_add.asp?id="&id) 
      else 
         call alert("DETAIL BARANG OUTGOIN", "Sudah terdaftar!", "error","outd_add.asp?id="&id) 
      end if
   end sub
   sub updateOutgoing()
      id = trim(Request.Form("id"))
      ckbrgid = trim(Request.Form("ckbrgid"))
      harga = trim(Request.Form("harga"))
      qty = trim(Request.Form("qty"))
      dsatuan = trim(Request.Form("dsatuan"))
      rak = trim(Request.Form("rak"))
      tgl = trim(Request.Form("tgl"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.commandText = "SELECT * FROM dbo.DLK_T_MaterialOutD WHERE MO_Item = '"& ckbrgid &"' AND MO_ID = '"& id &"' AND MO_Date = '"& tgl &"'"

      set detaildata = data_cmd.execute

      if detaildata.eof then
         call query("INSERT INTO DLK_T_MAterialOutD (MO_ID,MO_Date,MO_Item,MO_Qtysatuan,MO_Harga,MO_JenisSat,MO_RakID) VALUES ('"& id &"', '"& tgl &"','"& ckbrgid &"', "& qty &", '"& harga &"', '"& dsatuan &"', '"& rak &"')")

         call alert("DETAIL BARANG OUTGOIN", "berhasil ditambahkan", "success","out_u.asp?id="&id) 
      else 
         call alert("DETAIL BARANG OUTGOIN", "Sudah terdaftar!", "error","out_u.asp?id="&id) 
      end if
   end sub
%>