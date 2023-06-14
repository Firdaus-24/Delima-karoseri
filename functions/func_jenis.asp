<% 
sub tambahJenis()
     
    nama = UCase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_JenisBarang WHERE JenisNama = '"& nama &"' AND JenisKeterangan = '"& keterangan &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_JenisBarang '"& nama &"','"& keterangan &"', '"& session("userid") &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateJenis()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_JenisBarang WHERE JenisId = '"& id &"' AND JenisNama = '"& oldnama &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_JenisBarang SET JenisNama = '"& nama &"', JenisKeterangan = '"& keterangan &"', jenisUpdateID = '"& session("userid") &"' WHERE JenisID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>