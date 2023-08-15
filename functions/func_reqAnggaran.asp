<% 
' add header
sub tambahAnggaranH()
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    departement = trim(Request.Form("departement"))
    keterangan = trim(Request.Form("keterangan"))
    kebutuhan = trim(Request.Form("kebutuhan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoTgl = '"& tgl &"' AND MemoagenID = '"& agen &"' AND memoDepID = '"& departement &"' AND memoKeterangan = '"& keterangan &"' AND memoKebutuhan = "& kebutuhan &" AND memoApproveYN = 'N' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& departement &"', '"& divisi &"', '"& keterangan &"', '"& session("userid") &"', "& kebutuhan &", '' ,'','' ,1"
        set data = data_cmd.execute

        id = data("ID")
        call alert("PERMINTAAN ANGGARAN INVENTORY", "berhasil di tambahkan", "success","reqAnggaranD_add.asp?id="&id) 
    else
        call alert("PERMINTAAN ANGGARAN INVENTORY", "sudah terdaftar", "warning","./")
    end if

end sub

sub tambahAnggaranD()
    memoid = trim(Request.Form("memoid"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' AND memoItem = '"& brg &"'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "SELECT (COUNT(memoID)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        nol = "000"

        iddetail = memoid & right(nol & p("urut"),3)

        call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& iddetail &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"', '"& ket &"', '0')")

        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","reqAnggaranD_add.asp?id="&memoid) 
    else
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","reqAnggaranD_add.asp?id="&memoid)
    end if

end sub
sub updateAnggaran()
    memoid = trim(Request.Form("memoid"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' AND memoItem = '"& brg &"' "
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "SELECT TOP 1 (right(memoID,3)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' order by memoID desc"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        nol = "000"
            if p.eof then   
                data_cmd.commandTExt = "SELECT (COUNT(memoID)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"'"
                ' response.write data_cmd.commandText & "<br>"
                set a = data_cmd.execute

                iddetail = memoid & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& iddetail &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"','"& ket &"', '0')")
            else
                iddetail = memoid & right(nol & p("urut"),3)

                call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& iddetail &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"','"& ket &"', '0')")
            end if
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
    else
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning",Request.ServerVariables("HTTP_REFERER"))
    end if

end sub

sub updateDetail ()
    id = trim(Request.Form("iddreqanggaran"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE memoID = '"& id &"' "
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_Memo_D set memoItem = '"& brg &"', memoQtty = '"& qtty &"', memoSatuan = '"& satuan &"', memoKeterangan = '"& ket &"'  WHERE memoid = '"& id &"' ")
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di update", "success",Request.ServerVariables("HTTP_REFERER")) 
    else    
        call alert("RINCIAN PERMINTAAN BARANG", "tidak terdaftar", "error",Request.ServerVariables("HTTP_REFERER")) 
    end if
end sub
%>