<% 
sub tambahVendor()
    cabang = trim(Request.Form("cabang"))
    kdakun = trim(Request.Form("kdakun"))
    nama = UCase(trim(Request.Form("nama")))
    typet = trim(Request.Form("typet"))
    email = trim(Request.Form("email"))
    phone = trim(Request.Form("phone"))
    provinsi = trim(split(Request.Form("provinsi"),",")(1))
    kota = trim(split(Request.Form("kota"),",")(1))
    alamat = trim(Request.Form("alamat"))
    top = trim(Request.Form("top"))
    bank = trim(Request.Form("bank"))
    norek = trim(Request.Form("norek"))
    rekName = trim(Request.Form("rekName"))
    cp = trim(Request.Form("cp"))
    phonecp = trim(Request.Form("phonecp"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE Ven_Nama = '"& nama &"' AND Ven_Alamat = '"&  alamat &"' AND Ven_phone = '"& phone &"' AND Ven_Typetransaksi = "& typet &""
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_M_Vendor '"& cabang &"','"& nama &"','"& alamat &"','"& phone &"','"& email &"','"& kdakun &"',"& typet &", "& norek &", "& bank &", '"& rekName &"','"& kota &"','"& provinsi &"', "& top &", '"& phonecp &"', '"& cp &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
    if value = 1 then
        call alert("MASTER VENDOR", "berhasil di tambahkan", "success","vend_add.asp?id="&id) 
    elseif value = 2 then
        call alert("MASTER VENDOR", "sudah terdaftar", "warning","vend_add.asp?id="&id)
    else
        value = 0
    end if
end sub

sub tambahdetailVendor()
    id = trim(Request.Form("id"))
    ckdvendor = trim(Request.Form("ckdvendor"))
    spesification = trim(Request.Form("spesification"))
    harga = trim(Request.Form("harga"))
    nol = "0000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_VendorD WHERE LEFT(DVen_VenID,9) = '"& id &"' AND DVen_BrgID = '"&  ckdvendor &"'"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "SELECT TOP 1 (right(Dven_venID,4)) + 1 AS urut FROM DLK_T_VendorD WHERE LEFT(Dven_venID,9) = '"& id &"' ORDER BY Dven_venID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(Dven_venID)) + 1 AS urut FROM DLK_T_VendorD WHERE LEFT(Dven_venID,9) = '"& id &"'"

                set p = data_cmd.execute

                iddetail = id & right(nol & p("urut"),4)

                call query ("INSERT INTO DLK_T_VendorD (dven_Venid,Dven_BrgID,Dven_Spesification,Dven_Harga) VALUES ('"& iddetail &"', '"& ckdvendor &"', '"& spesification &"','"& harga &"')")
            else
                iddetail = id & right(nol & a("urut"),4)

                call query("INSERT INTO DLK_T_VendorD (dven_Venid,Dven_BrgID,Dven_Spesification,Dven_Harga) VALUES ('"& iddetail &"', '"& ckdvendor &"','"& spesification &"', '"& harga &"')")

            end if
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

    if value = 1 then
        call alert("RINCIAN BARANG VENDOR", "berhasil di tambahkan", "success","vend_add.asp?id="&id) 
    elseif value = 2 then
        call alert("RINCIAN BARANG VENDOR", "sudah terdaftar", "warning","vend_add.asp?id="&id)
    else
        value = 0
    end if
end sub

sub updateVendor()
    id = trim(Request.Form("id"))
    ckdvendor = trim(Request.Form("ckdvendor"))
    spesification = trim(Request.Form("spesification"))
    harga = trim(Request.Form("harga"))
    nol = "0000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_VendorD WHERE LEFT(DVen_VenID,9) = '"& id &"' AND DVen_BrgID = '"&  ckdvendor &"'"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "SELECT TOP 1 (right(Dven_venID,4)) + 1 AS urut FROM DLK_T_VendorD WHERE LEFT(Dven_venID,9) = '"& id &"' ORDER BY Dven_venID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(Dven_venID)) + 1 AS urut FROM DLK_T_VendorD WHERE LEFT(Dven_venID,9) = '"& id &"'"

                set p = data_cmd.execute

                iddetail = id & right(nol & p("urut"),4)

                call query ("INSERT INTO DLK_T_VendorD (dven_Venid,Dven_BrgID,Dven_Spesification,Dven_Harga) VALUES ('"& iddetail &"', '"& ckdvendor &"', '"& spesification &"','"& harga &"')")
            else
                iddetail = id & right(nol & a("urut"),4)

                call query("INSERT INTO DLK_T_VendorD (dven_Venid,Dven_BrgID,Dven_Spesification,Dven_Harga) VALUES ('"& iddetail &"', '"& ckdvendor &"','"& spesification &"', '"& harga &"')")

            end if
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

    if value = 1 then
        call alert("RINCIAN BARANG VENDOR", "berhasil di tambahkan", "success","vn_u.asp?id="&id) 
    elseif value = 2 then
        call alert("RINCIAN BARANG VENDOR", "sudah terdaftar", "warning","vn_u.asp?id="&id)
    else
        value = 0
    end if

end sub 
%>