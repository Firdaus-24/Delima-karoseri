<% 
sub tambahPbarang()
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    kebutuhan = trim(Request.Form("kebutuhan"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))
    if ket = "" then
        ket = "null"
    end if

    strbrg = Split(brg, ",")
    strspect = Split(spect, ",")
    strharga = Split(harga, ",")
    strqtty = Split(qtty, ",")
    strsatuan = Split(satuan, ",")
    strket = Split(ket, ",")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoTgl = '"& tgl &"' AND MemoagenID = '"& agen &"' AND memoKebID = '"& kebutuhan &"' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& kebutuhan &"', '"& divisi &"'"
        set data = data_cmd.execute

        id = data("ID")
        ' set looping barang
        no = 0
        for i = 0 to ubound(strbrg)
        no = no + 1

        strno = right("000" & no,3)
            data_cmd.commandText = "INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoHarga, memoKeterangan, memoAktifYN) VALUES ( '"& id + strno &"','"& trim(strbrg(i)) &"', '"& trim(strspect(i)) &"', "& trim(strqtty(i) ) &",'"& trim(strsatuan(i)) &"', "& trim(strharga(i)) &",'"& trim(strket(i)) &"','Y')"
            ' response.write data_cmd.commandText & "<br>"
            data_cmd.execute
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateUPbarang()
    id = trim(Request.Form("id"))
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    kebutuhan = trim(Request.Form("kebutuhan"))

    did = trim(Request.Form("did"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    strid = Split(did, ",")
    strbrg = Split(brg, ",")
    strspect = Split(spect, ",")
    strharga = Split(harga, ",")
    strqtty = Split(qtty, ",")
    strsatuan = Split(satuan, ",")
    strket = Split(ket, ",")
    
    set pdata_cmd =  Server.CreateObject ("ADODB.Command")
    pdata_cmd.ActiveConnection = mm_delima_string

    set ddata_cmd =  Server.CreateObject ("ADODB.Command")
    ddata_cmd.ActiveConnection = mm_delima_string

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoId = '"& id &"' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_Memo_H SET memoTgl = '"& tgl &"', memoAgenId = '"& agen &"', memoKebId = '"& kebutuhan &"', memoDivID = '"& divisi &"' WHERE memoID = '"& id &"'")

        angka = 0
        for x = 0 to ubound(strid)
        angka = angka + 1
        strno = right("000" & angka,3)

            ddata_cmd.commandText = "SELECT * FROM DLK_T_Memo_D WHERE memoId = '"& trim(strid(x)) &"' AND MemoAktifYN = 'Y'"
            ' response.write ddata_cmd.commandTExt & "<br>"
            set ddata = ddata_cmd.execute

            if not ddata.eof then
                call query("UPDATE DLK_T_Memo_D SET memoItem = '"& trim(strbrg(x)) &"', memospect = '"& trim(strspect(x)) &"', memoQtty = '"& trim(strqtty(x)) &"', memoSatuan = '"& trim(strsatuan(x)) &"', memoHarga = '"& trim(strharga(x)) &"', memoKeterangan = '"& trim(strket(x)) &"' WHERE memoID = '"& trim(strid(x)) &"'")
            else
                call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoHarga, memoKeterangan, memoAktifYN) VALUES ( '"& id + strno &"','"& trim(strbrg(x)) &"', '"& trim(strspect(x)) &"', "& trim(strqtty(x) ) &", '"& trim(strsatuan(x)) &"', "& trim(strharga(x)) &", '"& trim(strket(x)) &"', 'Y')")
            end if
        next
        value = 1 'case untuk udate data
    else
        value = 2 'case jika gagal update
    end if

end sub 

' update detail barang
sub updateDPbarang()
    id = trim(Request.Form("nbrg"))
    dbrg = trim(Request.Form("dbrg"))
    dspect = trim(Request.Form("dspect"))
    dqtty = trim(Request.Form("dqtty"))
    dharga = trim(Request.Form("dharga"))
    dsatuan = trim(Request.Form("dsatuan"))
    dket = trim(Request.Form("dket"))

    set pdata_cmd =  Server.CreateObject ("ADODB.Command")
    pdata_cmd.ActiveConnection = mm_delima_string

    pdata_cmd.commandText = "SELECT * FROM DLK_T_Memo_D WHERE MemoID = '"& id &"' AND memoAktifYN = 'Y'"
    ' response.write pdata_cmd.commandText
    set pdata = pdata_cmd.execute

    if not pdata.eof then
        call query("UPDATE DLK_T_Memo_D SET memoItem = '"& dbrg &"', memoSpect = '"& dspect &"', memoQtty = '"& dqtty &"', memoSatuan = '"& dsatuan &"', memoHarga = '"& dharga &"', memoKeterangan = '"& dket &"' WHERE memoId = '"& id &"'")
        value = 1
    else
        value = 2
    end if
end sub
%>