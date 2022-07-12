<% 
sub tambahVendor()
    nama = UCase(trim(Request.Form("nama")))
    alamat = trim(Request.Form("alamat"))
    cabang = trim(Request.Form("cabang"))
    phone = trim(Request.Form("phone"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE Ven_Nama = '"& nama &"' AND Ven_Alamat = '"&  alamat &"' AND Ven_phone = '"& phone &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Vendor '"& cabang &"','"& nama &"','"& alamat &"','"& phone &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

' sub updateCabang()
'     id = trim(Request.Form("id"))
'     nama = UCase(trim(Request.Form("nama")))
'     kdpos = trim(Request.Form("kdpos"))
'     alamat = trim(Request.Form("alamat"))
'     contact = trim(Request.Form("contact"))
'     phone1 = trim(Request.Form("phone1"))
'     phone2 = trim(Request.Form("phone2"))
'     email = trim(Request.Form("email"))

'     if Len(kdpos) > 10 then
'         kdpos = left(kdpos,10)
'     end if

'     set data_cmd =  Server.CreateObject ("ADODB.Command")
'     data_cmd.ActiveConnection = mm_delima_string

'     data_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenID = '"& id &"' AND AgenName = '"& nama &"' AND agenAlamat = '"&  alamat &"' AND AgenKodepos = '"& kdpos &"' AND AgenPhone1 = '"& phone1 &"' AND AgenPhone2 = '"& phone2 &"' AND AgenEmail = '"& email &"' AND AgenContactPerson = '"& contact &"'"
'     set data = data_cmd.execute

'     if data.eof then
'         call query("UPDATE GLB_M_Agen SET AgenName = '"& nama &"', AgenAlamat = '"& alamat &"', AgenKodePos = '"& kdpos &"', AgenPhone1 = '"& phone1 &"', AgenPhone2 = '"& phone2 &"', AgenEmail = '"& email &"', AgenContactPerson = '"& contact &"' WHERE AgenID = '"& id &"'")
'         value = 1 'case untuk insert data
'     else
'         value = 2 'case jika gagal insert 
'     end if

' end sub 
%>