<% 
sub tambahKdBarang()
    nama = UCase(trim(Request.Form("nama")))
    deskripsi = UCase(trim(Request.Form("deskripsi")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_KodeBarang WHERE Kode_Nama = '"& nama &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_KodeBarang '"& nama &"','"& deskripsi &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateKdBarang()
    nama = UCase(trim(Request.Form("nama")))
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    deskripsi = UCase(trim(Request.Form("deskripsi")))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_KodeBarang WHERE Kode_Id = '"& id &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_KodeBarang SET Kode_Nama = '"& nama &"', Kode_keterangan = '"& deskripsi &"' WHERE Kode_ID = '"& id &"'")
        value = 1 'case untuk udate data
    else
        value = 2 'case jika gagal update
    end if

end sub 
%>