<% 
sub tambahVendor()
    nama = UCase(trim(Request.Form("nama")))
    alamat = trim(Request.Form("alamat"))
    cabang = trim(Request.Form("cabang"))
    phone = trim(Request.Form("phone"))
    email = trim(Request.Form("email"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE Ven_Nama = '"& nama &"' AND Ven_Alamat = '"&  alamat &"' AND Ven_phone = '"& phone &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Vendor '"& cabang &"','"& nama &"','"& alamat &"','"& phone &"','"& email &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateVendor()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))
    alamat = trim(Request.Form("alamat"))
    cabang = trim(Request.Form("cabang"))
    phone = trim(Request.Form("phone"))
    email = trim(Request.Form("email"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE ven_Id = '"& id &"' AND Ven_Nama = '"& oldnama &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Vendor SET Ven_Nama = '"& nama &"', Ven_Alamat = '"& alamat &"', Ven_Phone = '"& phone &"', ven_email = '"& email &"' WHERE Ven_ID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>