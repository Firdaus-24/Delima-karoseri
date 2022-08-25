<% 
' add header
sub tambahPbarang()
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    kebutuhan = trim(Request.Form("kebutuhan"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoTgl = '"& tgl &"' AND MemoagenID = '"& agen &"' AND memoKebID = '"& kebutuhan &"' AND memoKeterangan = '"& keterangan &"' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& kebutuhan &"', '"& divisi &"', '"& keterangan &"' "
        set data = data_cmd.execute

        id = data("ID")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

    if value = 1 then
        call alert("PERMINTAAN BARANG", "berhasil di tambahkan", "success","pbd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("PERMINTAAN BARANG", "sudah terdaftar", "warning","pbd_add.asp?id="&id)
    else
        value = 0
    end if
end sub

sub tambahdetailPBarang ()
    memoid = trim(Request.Form("memoid"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE memoID = '"& memoid &"' AND memoItem = '"& brg &"' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoHarga, memoKeterangan, memoAktifYN) VALUES ( '"& memoid &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"', "& harga &",'"& ket &"','Y')"
            ' response.write data_cmd.commandText & "<br>"
        data_cmd.execute
        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","pbd_add.asp?id="&memoid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","pbd_add.asp?id="&memoid)
    else
        value = 0
    end if

end sub
sub tambahdetailPBarang ()
    memoid = trim(Request.Form("memoid"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE memoID = '"& memoid &"' AND memoItem = '"& brg &"' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoHarga, memoKeterangan, memoAktifYN) VALUES ( '"& memoid &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"', "& harga &",'"& ket &"','Y')"
            ' response.write data_cmd.commandText & "<br>"
        data_cmd.execute
        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","pb_u.asp?id="&memoid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","pb_u.asp?id="&memoid)
    else
        value = 0
    end if

end sub
%>