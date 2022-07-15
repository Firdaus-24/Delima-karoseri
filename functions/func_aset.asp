<% 
sub tambahAset()
     
    nama = UCase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Aset WHERE AsetNama = '"& nama &"' AND AsetKeterangan = '"& keterangan &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Aset '"& nama &"','"& keterangan &"','"& session("username") &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateAset()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Aset WHERE AsetId = '"& id &"' AND AsetNama = '"& oldnama &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Aset SET AsetNama = '"& nama &"', AsetKeterangan = '"& keterangan &"' WHERE AsetID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>