<% 
sub tambahPbarang()
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    brg = trim(Request.Form("brg"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    harga = trim(Request.Form("harga"))
    satuan = trim(Request.Form("satuan"))
    ket = trim(Request.Form("ket"))

    strbrg = Split(brg, ",")
    strspect = Split(spect, ",")
    strharga = Split(harga, ",")
    strqtty = Split(qtty, ",")
    strsatuan = Split(satuan, ",")
    strket = Split(ket, ",")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoTgl = '"& tgl &"' AND MemoagenID = '"& agen &"' AND memoDivID = '"& divisi &"' AND memoAktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& divisi &"'"
        set data = data_cmd.execute

        id = data("ID")
        ' set looping barang 
        no = 0
        for i = 0 to ubound(strbrg)
        no = no + 1
        strno = right("000" & no,3)
            data_cmd.commandText = "INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoHarga, memoKeterangan, memoAktifYN) VALUES ( '"& id + strno &"','"& trim(strbrg(i)) &"', '"& trim(strspect(i)) &"', "& trim(strqtty(i)) &", '"& trim(strsatuan(i)) &"', "& trim(strharga(i)) &", '"& trim(strket(i)) &"', 'Y')"
            ' response.write data_cmd.commandText & "<br>"
            data_cmd.execute
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updatePtambahPbarang()
    nama = UCase(trim(Request.Form("nama")))
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    deskripsi = UCase(trim(Request.Form("deskripsi")))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_KodeBarang WHERE Kode_Id = '"& id &"'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_KodeBarang SET Kode_Nama = '"& nama &"', Kode_keterangan = '"& deskripsi &"' WHERE Kode_ID = '"& id &"'")
        value = 1 'case untuk udate data
    else
        value = 2 'case jika gagal update
    end if

end sub 
%>