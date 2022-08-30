<% 
sub tambahPurce()
    memoId = trim(Request.Form("memoId"))
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    vendor = trim(Request.Form("vendor"))
    tgljt = trim(Request.Form("tgljt"))
    metpem = trim(Request.Form("metpem"))
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    if diskon = "" then
        diskon = 0
    end if
    ppn = trim(Request.Form("ppn"))
    if ppn = "" then
        ppn = 0
    end if  

    valitem = trim(Request.Form("valitem"))
    valqtty = trim(Request.Form("valqtty"))
    valharga = trim(Request.Form("valharga"))
    valsatuan = trim(Request.Form("valsatuan"))
    valdisc1 = trim(Request.Form("valdisc1"))
    valdisc2 = trim(Request.Form("valdisc2"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AgenID = '"& agen &"' AND OPH_Date = '"& tgl &"' AND OPH_VenID = '"& vendor &"' AND OPH_JTDate = '"& tgljt &"' AND OPH_MetPem = "& metpem &" AND OPH_DiskonAll = '"& diskon &"' AND OPH_PPn = "& ppn &" AND OPH_memoId = '"& memoId &"' AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    vitem = Split(valitem, ",")
    vqtty = Split(valqtty, ",")
    vharga = Split(valharga, ",")
    vsatuan = Split(valsatuan, ",")
    vdisc1 = Split(valdisc1, ",")
    vdisc2 = Split(valdisc2, ",")

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_OrPemH '"& agen &"', '"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", '"& memoId &"' "
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        nol = "000"
        no = 0
        for i = 0 to ubound(vitem)  
        no = no + 1
            data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE left(OPD_OPHID,13) = '"& id &"' AND OPD_Item = '"& vitem(i) &"' AND OPD_QtySatuan = "& vqtty(i) &" AND OPD_Harga = '"& vharga(i) &"' AND OPD_JenisSat = '"& vsatuan(i) &"' AND OPD_Disc1 = '"& vdisc1(i) &"' AND OPD_Disc2 = '"& vdisc2(i) &"'"
            ' response.write data_cmd.commandText & "<br>"
            set q = data_cmd.execute
            
            if q.eof then
                
                iddetail = id & right(nol & no,3)

                call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& vitem(i) &"',"& vqtty(i) &", '"& vharga(i) &"', '"& vsatuan(i) &"', '"& vdisc1(i) &"', '"& vdisc2(i) &"')")

            end if
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

sub updatePurce()
    id = trim(Request.Form("id"))
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    vendor = trim(Request.Form("vendor"))
    tgljt = trim(Request.Form("tgljt"))
    metpem = trim(Request.Form("metpem"))
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    if diskon = "" then
        diskon = 0
    end if
    ppn = trim(Request.Form("ppn"))
    if ppn = "" then
        ppn = 0
    end if  

    ' detail barang
    valitem = trim(Request.Form("valitem"))
    valqtty = trim(Request.Form("valqtty"))
    valharga = trim(Request.Form("valharga"))
    valsatuan = trim(Request.Form("valsatuan"))
    valdisc1 = trim(Request.Form("valdisc1"))
    valdisc2 = trim(Request.Form("valdisc2"))

    vitem = Split(valitem, ",")
    vqtty = Split(valqtty, ",")
    vharga = Split(valharga, ",")
    vsatuan = Split(valsatuan, ",")
    vdisc1 = Split(valdisc1, ",")
    vdisc2 = Split(valdisc2, ",")

    ' add detail barang
    ' id = trim(Request.Form("id"))
    itempo = trim(Request.Form("itempo"))
    qtty = trim(Request.Form("qtty"))
    hargapo = trim(Request.Form("hargapo"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    nol = "000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        if itempo <> "" then
            data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("OPH_ID") &"' AND OPD_Item = '"& itempo &"'"
            set addetail = data_cmd.execute

            if addetail.eof then
                data_cmd.commandText = "SELECT TOP 1 (right(OPD_OPHID,3)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("OPH_ID") &"' order by OPD_OPHID DESC"

                set a = data_cmd.execute
                if a.eof then
                    data_cmd.commandText = "SELECT (COUNT(OPD_OPHID)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("OPH_ID") &"'"

                    set p = data_cmd.execute

                    iddetail = data("OPH_ID") & right(nol & p("urut"),3)

                    call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& itempo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
                else
                    iddetail = data("OPH_ID") & right(nol & a("urut"),3)

                    call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& itempo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
                end if
                value = 1 'case untuk insert data
            else
                value = 2 'case jika gagal insert 
            end if

        else 
            call query("UPDATE DLK_T_OrPemH SET OPH_VenID = '"& vendor &"', OPH_JTDate = '"& tgljt &"', OPH_MetPem = "& metpem &", OPH_DiskonAll = '"& diskon &"',OPH_PPn = "& ppn &", OPH_Keterangan = '"& keterangan &"' WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y' ")

            for i = 0 to ubound(vitem)  
                data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& id &"' AND OPD_Item = '"& trim(vitem(i)) &"' AND OPD_Harga = '"& trim(vharga(i)) &"' AND OPD_JenisSat = '"& trim(vsatuan(i)) &"'"
                ' response.write data_cmd.commandText & "<br>"
                set q = data_cmd.execute
                
                if not q.eof then
                    call query("UPDATE DLK_T_OrPemD SET OPD_QtySatuan = "& trim(vqtty(i)) &", OPD_Disc1 = '"& trim(vdisc1(i)) &"',OPD_Disc2 = '"& trim(vdisc2(i)) &"' WHERE OPD_OPHID = '"& q("OPD_OPHID") &"'")
                end if
            next
            value = 1 'case untuk insert data
        end if
    else
        value = 2 'case jika gagal insert 
    end if

    if value = 1 then
        call alert("PURCHES ORDER", "berhasil di update", "success","purc_u.asp?id="&id) 
    elseif value = 2 then
        call alert("PURCHES ORDER", "sudah terdaftar", "warning","purc_u.asp?id="&id)
    else
        value = 0
    end if
end sub
%>