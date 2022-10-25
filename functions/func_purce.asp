<% 
sub tambahdetailpo()
    poid = trim(Request.Form("poid"))
    ckbrgpo = trim(Request.Form("ckbrgpo"))
    hargapo = trim(replace(replace(Request.Form("hargapo"),",",""),".00",""))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    strbrg = split(ckbrgpo,",")
    ckbrgpo = trim(strbrg(0))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"' AND OPD_Item = '"& ckbrgpo &"'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "SELECT (COUNT(OPD_OPHID)) + 1 AS urut FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        nol = "000"

        iddetail = poid & right(nol & p("urut"),3)

        call query ("INSERT INTO DLK_T_OrpemD (OPD_OPHID, OPD_Item, OPD_QtySatuan, OPD_Harga, OPD_JenisSat, OPD_Disc1, OPD_Disc2) VALUES ( '"& iddetail &"','"& ckbrgpo &"', "& qtty &", "& hargapo &",'"& satuan &"', '"& disc1 &"', '"& disc2 &"')")

        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","purcesd_add.asp?id="&poid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","purcesd_add.asp?id="&poid)
    else
        value = 0
    end if
end sub

sub updatePurce()
    poid = trim(Request.Form("poid"))
    ckbrgpo = trim(Request.Form("ckbrgpo"))
    hargapo = trim(replace(replace(Request.Form("hargapo"),",",""),".00",""))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    strbrg = split(ckbrgpo,",")
    ckbrgpo = trim(strbrg(0))

    nol = "000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"' AND OPD_Item = '"& ckbrgpo &"'"
    ' response.write data_cmd.commandText & "<br>"
    set addetail = data_cmd.execute

    if addetail.eof then
        data_cmd.commandText = "SELECT TOP 1 (right(OPD_OPHID,3)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& poid &"' order by OPD_OPHID DESC"

        set a = data_cmd.execute
        if a.eof then
            data_cmd.commandText = "SELECT (COUNT(OPD_OPHID)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& poid &"'"

            set p = data_cmd.execute

            iddetail = poid & right(nol & p("urut"),3)

            call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& ckbrgpo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
        else
            iddetail = poid & right(nol & a("urut"),3)

            call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& ckbrgpo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
        end if
        value = 1 'case untuk insert data
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","purc_u.asp?id="&poid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","purc_u.asp?id="&poid)
    else
        value = 0
    end if
end sub

sub updateInvoice()
    iphid = trim(Request.Form("iphid"))
    tgljt = trim(Request.Form("tgljt"))
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    ppn = trim(Request.Form("ppn"))
    ' detail
    ipdiphid = trim(Request.Form("ipdiphid"))
    harga = trim(Request.Form("harga"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    did = split(ipdiphid,",")
    dharga = split(harga,",")
    ddisc1 = split(disc1,",")
    ddisc2 = split(disc2,",")

    

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_InvPemH WHERE IPH_ID = '"& iphid &"' AND IPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_InvPemH SET IPH_JTDate = '"& tgljt &"', IPH_DiskonAll = "& diskon &", IPH_PPn = "& ppn &", IPH_Keterangan = '"& keterangan &"' where IPH_ID = '"& iphid &"'")

        for m = 0 to Ubound(did)
            data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& trim(did(m)) &"'"

            set detaildata = data_cmd.execute
            
            if not detaildata.eof then
                call query("UPDATE DLK_T_InvPemD SET IPD_Harga = '"& trim(dharga(m)) &"', IPD_Disc1 = "& trim(ddisc1(m)) &", IPD_Disc2 = "& trim(ddisc2(m)) &" WHERE IPD_IPHID = '"& detaildata("IPD_IPHID") &"'")
            end if
        next    
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
    if value = 1 then
        call alert("INVOICES RESERVE", "berhasil di update", "success","invoReserve.asp") 
    elseif value = 2 then
        call alert("INVOICES RESERVE", "tidak terdaftar", "warning", "invoReserve.asp")
    else
        value = 0
    end if
end sub
%>