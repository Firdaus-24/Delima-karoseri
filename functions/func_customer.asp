<% 
sub tambahCust()
    tgl = trim(Request.Form("tgl"))
    nama = trim(Request.Form("nama"))
    email = trim(Request.Form("email"))
    alamat = trim(Request.Form("alamat"))
    phone1 = trim(Request.Form("phone1"))
    phone2 = trim(Request.Form("phone2"))
    kdakun = trim(Request.Form("kdakun"))
    updatetime = now()

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Customer WHERE custNama = '"& nama &"' AND custTgl = '"& tgl &"' AND custEmail = '"& email &"' AND custAlamat = '"& alamat &"' AND custPhone1 = '"& phone1 &"' AND custPhone2 = '"& phone2 &"'"
    set data = data_cmd.execute

    if data.eof then
        call query ("exec sp_AddDLK_M_customer '"& nama &"', '"& email &"', '"& alamat &"', '"& phone1 &"','"& phone2 &"','"& session("username") &"', '"& updatetime &"','"& tgl &"','"& kdakun &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

sub updateCust()
    id = trim(Request.Form("id"))
    tgl = trim(Request.Form("tgl"))
    nama = trim(Request.Form("nama"))
    email = trim(Request.Form("email"))
    alamat = trim(Request.Form("alamat"))
    phone1 = trim(Request.Form("phone1"))
    phone2 = trim(Request.Form("phone2"))
    kdakun = trim(Request.Form("kdakun"))
    updatetime = now()

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Customer WHERE custID = '"& id &"' AND custAktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query ("UPDATE DLK_M_customer SET custnama = '"& nama &"', custEmail = '"& email &"', custAlamat = '"& alamat &"', custPhone1 = '"& phone1 &"', custPhone2 = '"& phone2 &"', custUpdateId = '"& session("username") &"', custUpdateTime = '"& updatetime &"', custTgl = '"& tgl &"', custKodeAkun = '"& kdakun &"' WHERE custID  = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

%>