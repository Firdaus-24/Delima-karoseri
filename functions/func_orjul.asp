<% 
sub tambahOrjul()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    customer = trim(Request.Form("customer"))
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

    data_cmd.commandText = "SELECT * FROM DLK_T_OrJulH WHERE OJH_AgenID = '"& agen &"' AND OJH_Date = '"& tgl &"' AND OJH_custID = '"& customer &"' AND OJH_JTDate = '"& tgljt &"' AND OJH_MetPem = "& metpem &" AND OJH_DiskonAll = '"& diskon &"' AND OJH_PPn = "& ppn &" AND OJH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_OrJulH '"& agen &"', '"& tgl &"', '"& customer &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &" "
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        for i = 0 to ubound(vitem)  
            data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE OJD_OJHID = '"& id &"' AND OJD_Item = '"& vitem(i) &"' AND OJD_QtySatuan = "& vqtty(i) &" AND OJD_Harga = '"& vharga(i) &"' AND OJD_JenisSat = '"& vsatuan(i) &"' AND OJD_Disc1 = '"& vdisc1(i) &"' AND OJD_Disc2 = '"& vdisc2(i) &"' AND OJD_AktifYN = 'Y'"

            set q = data_cmd.execute
            
            if q.eof then
                data_cmd.commandText = "INSERT INTO DLK_T_OrJulD (OJD_OJHID, OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_AktifYN) VALUES ('"& id &"','"& trim(vitem(i)) &"',"& trim(vqtty(i)) &", '"& trim(vharga(i)) &"', '"& trim(vsatuan(i)) &"', '"& trim(vdisc1(i)) &"', '"& trim(vdisc2(i)) &"', 'Y' ) "
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