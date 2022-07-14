<% 
sub tambahRak()
    cabang = trim(Request.Form("cabang"))
    nama = UCase(trim(Request.Form("nama")))
    updatetime = trim(Request.Form("updatetime"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Rak WHERE left(Rak_ID,3) = '"& cabang &"' AND  Rak_nama = '"& nama &"' AND Rak_Keterangan = '"& keterangan &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Rak '"& cabang &"','"& nama &"','"& updatetime &"','"& keterangan &"','admin'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateRak()
    id = trim(Request.Form("id"))
    cabang = trim(Request.Form("cabang"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))
    updatetime = trim(Request.Form("updatetime"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Rak WHERE Rak_ID = '"& id &"' AND  Rak_nama = '"& oldnama &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Rak SET Rak_Nama = '"& nama &"', Rak_Keterangan = '"& keterangan &"', Rak_updateTime = '"& updatetime &"' WHERE Rak_Id = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>