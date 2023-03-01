<% 
sub ManpowerH()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    produksi = trim(Request.Form("produksi"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ManpowerH WHERE MP_AgenID = '"& agen &"' AND MP_PDHID = '"& produksi &"' AND MP_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddDLK_T_ManPowerH '"& produksi &"','"& agen &"','"& tgl &"', '"& session("userid") &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      value = 1 'case untuk insert data
    else
      value = 2 'case jika gagal insert 
    end if
    
    if value = 1 then
      call alert("TRANSAKSI MANPOWER", "berhasil di tambahkan", "success","mpd_add.asp?id="&id) 
    elseif value = 2 then
      call alert("TRANSAKSI MANPOWER", "sudah terdaftar", "warning","mp_add.asp")
    else
      value = 0
    end if

end sub

sub manpowerD()
  id = trim(Request.Form("id"))
  kryNip = trim(Request.Form("kryNip"))
  salary = trim(Request.Form("salary"))
  deskripsi = trim(Request.Form("deskripsi"))
  
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_ManpowerD WHERE LEFT(MP_ID, 4) = '"& left(id,4) &"' AND RIGHT(MP_ID,7) = '"& right(id,7) &"' AND MP_Nip = '"& kryNip &"'"
  ' response.write data_cmd.commandText & "<br>"
  set powerd = data_cmd.execute
  
  if powerd.eof then
    
    data_cmd.commandTExt = "SELECT '"& left(id,4) &"' + Right('00' + Convert(varchar,Convert(int,(SUBSTRING(isnull(Max(MP_ID),'00'),5,2)))+1),2) + '"&right(id,7)&"' as id FROM DLK_T_ManPowerD WHERE LEFT(MP_ID, 4) = '"& left(id,4) &"' AND RIGHT(MP_ID,7) = '"& right(id,7) &"'"
    ' response.write data_cmd.commandText & "<br>"
    set a = data_cmd.execute

    call query  ("INSERT INTO DLK_T_ManpowerD (MP_ID, MP_Nip,MP_Salary, MP_Deskripsi, MP_UpdateID,MP_Updatetime) VALUES ('"& a("id") &"','"& kryNip &"', '"& salary &"', '"& deskripsi &"', '"& session("userid") &"','"& now &"')")

    value = 1 'case untuk insert data
  else
    value = 2 'case jika gagal insert 
  end if

  if value = 1 then
    call alert("DETAIL MANPOWER", "berhasil di tambahkan", "success","mpd_add.asp?id="&id) 
  elseif value = 2 then
    call alert("DETAIL MANPOWER", "sudah terdaftar", "warning","mpd_add.asp?id="&id)
  else
    value = 0
  end if
end sub

sub updatemanpowerD()
  id = trim(Request.Form("id"))
  kryNip = trim(Request.Form("kryNip"))
  salary = trim(Request.Form("salary"))
  deskripsi = trim(Request.Form("deskripsi"))
  
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_ManpowerD WHERE LEFT(MP_ID, 4) = '"& left(id,4) &"' AND RIGHT(MP_ID,7) = '"& right(id,7) &"' AND MP_Nip = '"& kryNip &"'"
  ' response.write data_cmd.commandText & "<br>"
  set powerd = data_cmd.execute
  
  if powerd.eof then
    
    data_cmd.commandTExt = "SELECT '"& left(id,4) &"' + Right('00' + Convert(varchar,Convert(int,(SUBSTRING(isnull(Max(MP_ID),'00'),5,2)))+1),2) + '"&right(id,7)&"' as id FROM DLK_T_ManPowerD WHERE LEFT(MP_ID, 4) = '"& left(id,4) &"' AND RIGHT(MP_ID,7) = '"& right(id,7) &"'"
    ' response.write data_cmd.commandText & "<br>"
    set a = data_cmd.execute

    call query  ("INSERT INTO DLK_T_ManpowerD (MP_ID, MP_Nip,MP_Salary, MP_Deskripsi, MP_UpdateID,MP_Updatetime) VALUES ('"& a("id") &"','"& kryNip &"', '"& salary &"', '"& deskripsi &"','"& session("userid") &"','"& now &"')")

    value = 1 'case untuk insert data
  else
    value = 2 'case jika gagal insert 
  end if

  if value = 1 then
    call alert("DETAIL MANPOWER", "berhasil di tambahkan", "success","mpd_u.asp?id="&id) 
  elseif value = 2 then
    call alert("DETAIL MANPOWER", "sudah terdaftar", "warning","mpd_u.asp?id="&id)
  else
    value = 0
  end if
end sub


%>