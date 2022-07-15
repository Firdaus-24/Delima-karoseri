<% 
sub tambahDivisi()
     
    nama = UCase(trim(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Divisi WHERE DivNama = '"& nama &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Divisi '"& nama &"','"& session("username") &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateDivisi()
    id = trim(Request.Form("id"))
    nama = UCase(trim(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Divisi WHERE DivId = '"& id &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Divisi SET DivNama = '"& nama &"' WHERE DivID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>