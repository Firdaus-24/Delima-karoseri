<% 
sub tambahCust()
    tgl = trim(Request.Form("tgl"))
    nama = trim(Request.Form("nama"))
    email = trim(Request.Form("email"))
    alamat = trim(Request.Form("alamat"))
    phone = trim(Request.Form("phone"))
    typet = trim(Request.Form("typet"))
    kdakun = trim(Request.Form("kdakun"))
    bank = trim(Request.Form("bank"))
    norek = trim(Request.Form("norek"))
    rekName = trim(Request.Form("rekName"))
    updatetime = now()

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Customer WHERE custNama = '"& nama &"' AND custEmail = '"& email &"' AND custAlamat = '"& alamat &"' AND custPhone1 = '"& phone &"' AND CustTypeTransaksi = '"& typet &"'"
    set data = data_cmd.execute

    if data.eof then
        call query ("exec sp_AddDLK_M_customer '"& nama &"', '"& email &"', '"& alamat &"', '"& phone &"', '"& session("username") &"', '"& updatetime &"','"& tgl &"', '"& typet &"','"& norek &"', '"& bank &"', '"& rekName &"', '"& kdakun &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

sub updateCust()
    id = trim(Request.Form("id"))
    nama = trim(Request.Form("nama"))
    email = trim(Request.Form("email"))
    alamat = trim(Request.Form("alamat"))
    phone = trim(Request.Form("phone"))
    typet = trim(Request.Form("typet"))
    kdakun = trim(Request.Form("kdakun"))
    bank = trim(Request.Form("bank"))
    norek = trim(Request.Form("norek"))
    rekName = trim(Request.Form("rekName"))
    updatetime = now()

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Customer WHERE custID = '"& id &"' AND custAktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query ("UPDATE DLK_M_customer SET custnama = '"& nama &"', custEmail = '"& email &"', custAlamat = '"& alamat &"', custPhone1 = '"& phone &"', custUpdateId = '"& session("username") &"', custUpdateTime = '"& updatetime &"', custKodeAkun = '"& kdakun &"', custTypetransaksi = '"& typet &"', custBankID = '"& bank &"', custNorek = '"& norek &"', custRekName = '"& rekName &"' WHERE custID  = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

%>