<% 
sub tambahSatuanBarang()
    nama = UCase(trim(Request.Form("nama")))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_SatuanBarang WHERE Sat_Nama = '"& nama &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_SatuanBarang '"& nama &"','"& session("username") &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateSatuanBarang()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_SatuanBarang WHERE Sat_Id = '"& id &"' AND Sat_Nama = '"& oldnama &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_SatuanBarang SET Sat_Nama = '"& nama &"', Sat_updateID = '"& session("username") &"' WHERE Sat_ID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>