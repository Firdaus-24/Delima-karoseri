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
%>