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

        for i = 0 to ubound(vitem)  
            data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE OPD_OPHID = '"& id &"' AND OPD_Item = '"& vitem(i) &"' AND OPD_QtySatuan = "& vqtty(i) &" AND OPD_Harga = '"& vharga(i) &"' AND OPD_JenisSat = '"& vsatuan(i) &"' AND OPD_Disc1 = '"& vdisc1(i) &"' AND OPD_Disc2 = '"& vdisc2(i) &"'"
            ' response.write data_cmd.commandText & "<br>"
            set q = data_cmd.execute
            
            if q.eof then
                data_cmd.commandText = "INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2, OPD_AktifYN) VALUES ('"& id &"','"& vitem(i) &"',"& vqtty(i) &", '"& vharga(i) &"', '"& vsatuan(i) &"', '"& vdisc1(i) &"', '"& vdisc2(i) &"', 'Y' ) "

                data_cmd.execute
            end if
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub

sub tambahPurce2()
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

    ' detail
    itempo = trim(Request.Form("itempo"))
    qttypo = trim(Request.Form("qttypo"))
    hargapo = trim(Request.Form("hargapo"))
    satuanpo = trim(Request.Form("satuanpo"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    vitem = Split(itempo, ",")
    vqtty = Split(qttypo, ",")
    vharga = Split(hargapo, ",")
    vsatuan = Split(satuanpo, ",")
    vdisc1 = Split(disc1, ",")
    vdisc2 = Split(disc2, ",")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AgenID = '"& agen &"' AND OPH_Date = '"& tgl &"' AND OPH_VenID = '"& vendor &"' AND OPH_JTDate = '"& tgljt &"' AND OPH_MetPem = "& metpem &" AND OPH_DiskonAll = '"& diskon &"' AND OPH_PPn = "& ppn &" AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_OrPemH '"& agen &"', '"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", '' "
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        for i = 0 to ubound(vitem)  
            data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE OPD_OPHID = '"& id &"' AND OPD_Item = '"& vitem(i) &"' AND OPD_QtySatuan = "& vqtty(i) &" AND OPD_Harga = '"& vharga(i) &"' AND OPD_JenisSat = '"& vsatuan(i) &"' AND OPD_Disc1 = '"& vdisc1(i) &"' AND OPD_Disc2 = '"& vdisc2(i) &"' AND OPD_AktifYN = 'Y'"

            set q = data_cmd.execute
            
            if q.eof then
                data_cmd.commandText = "INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2,OPD_AktifYN) VALUES ('"& id &"','"& trim(vitem(i)) &"',"& trim(vqtty(i)) &", '"& trim(vharga(i)) &"', '"& trim(vsatuan(i)) &"', '"& trim(vdisc1(i)) &"', '"& trim(vdisc2(i)) &"', 'Y' ) "
                ' response.write data_cmd.commandText & "<br>"
                data_cmd.execute
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

    ' detail
    itempo = trim(Request.Form("itempo"))
    qttypo = trim(Request.Form("qttypo"))
    hargapo = trim(Request.Form("hargapo"))
    satuanpo = trim(Request.Form("satuanpo"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    vitem = Split(itempo, ",")
    vqtty = Split(qttypo, ",")
    vharga = Split(hargapo, ",")
    vsatuan = Split(satuanpo, ",")
    vdisc1 = Split(disc1, ",")
    vdisc2 = Split(disc2, ",")

    ' item lama
    olditempo = trim(Request.Form("olditempo"))
    oldqttypo = trim(Request.Form("oldqttypo"))
    oldhargapo = trim(Request.Form("oldhargapo"))
    oldsatuanpo = trim(Request.Form("oldsatuanpo"))
    olddisc1 = trim(Request.Form("olddisc1"))
    olddisc2 = trim(Request.Form("olddisc2"))

    oldvitem = Split(olditempo, ",")
    oldvqtty = Split(oldqttypo, ",")
    oldvharga = Split(oldhargapo, ",")
    oldvsatuan = Split(oldsatuanpo, ",")
    oldvdisc1 = Split(olddisc1, ",")
    oldvdisc2 = Split(olddisc2, ",")
    

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_OrPemH SET OPH_AgenID = '"& agen &"', OPH_Date = '"& tgl &"', OPH_VenID = '"& vendor &"', OPH_JTDate = '"& tgljt &"', OPH_MetPem = "& metpem &", OPH_DiskonAll = '"& diskon &"',OPH_PPn = "& ppn &", OPH_Keterangan = '"& keterangan &"' WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y' ")

        for i = 0 to ubound(vitem)  
            data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE OPD_OPHID = '"& id &"' AND OPD_Item = '"& trim(oldvitem(i)) &"' AND OPD_QtySatuan = "& trim(oldvqtty(i)) &" AND OPD_Harga = '"& trim(oldvharga(i)) &"' AND OPD_JenisSat = '"& trim(oldvsatuan(i)) &"' AND OPD_Disc1 = '"& trim(oldvdisc1(i)) &"' AND OPD_Disc2 = '"& trim(oldvdisc2(i)) &"' AND OPD_AktifYN = 'Y'"
            ' response.write data_cmd.commandText
            set q = data_cmd.execute
            
            if not q.eof then
                data_cmd.commandText = "UPDATE DLK_T_OrPemD SET OPD_Item ='"& trim(vitem(i)) &"', OPD_QtySatuan = "& trim(vqtty(i)) &", OPD_Harga = '"& trim(vharga(i)) &"', OPD_JenisSat = '"& trim(vsatuan(i)) &"', OPD_Disc1 = '"& trim(vdisc1(i)) &"',OPD_Disc2 = '"& trim(vdisc2(i)) &"' WHERE OPD_OPHID = '"& id &"' AND OPD_AktifYN ='Y'"
                ' response.write data_cmd.commandText & "<br>"
                data_cmd.execute
            else
                data_cmd.commandText = "INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2,OPD_AktifYN) VALUES ('"& id &"','"& trim(vitem(i)) &"',"& trim(vqtty(i)) &", '"& trim(vharga(i)) &"', '"& trim(vsatuan(i)) &"', '"& trim(vdisc1(i)) &"', '"& trim(vdisc2(i)) &"', 'Y' ) "
                ' response.write data_cmd.commandText & "<br>"
                data_cmd.execute
            end if
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub
%>