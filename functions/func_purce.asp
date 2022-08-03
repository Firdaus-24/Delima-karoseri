<% 
sub tambahPurce()
    appid = trim(Request.Form("appid"))
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    vendor = trim(Request.Form("vendor"))
    tgljt = trim(Request.Form("tgljt"))
    metpem = trim(Request.Form("metpem"))
    diskon = trim(Request.Form("diskon"))
    if diskon = "" then
        diskon = 0
    end if
    ppn = trim(Request.Form("ppn"))
    if ppn = "" then
        ppn = 0
    end if  

    itempo = trim(Request.Form("itempo"))
    valqtty = trim(Request.Form("valqtty"))
    valharga = trim(Request.Form("valharga"))
    valsatuan = trim(Request.Form("valsatuan"))
    valdisc1 = trim(Request.Form("valdisc1"))
    valdisc2 = trim(Request.Form("valdisc2"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AgenID = '"& agen &"' AND OPH_Date = '"& tgl &"' AND OPH_VenID = '"& vendor &"' AND OPH_JTDate = '"& tgljt &"' AND OPH_MetPem = "& metpem &" AND OPH_DiskonAll = '"& diskon &"' AND OPH_PPn = "& ppn &" AND OPH_AppID = '"& appid &"' AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    vitem = Split(valitem, ",")
    vqtty = Split(valqtty, ",")
    vharga = Split(valharga, ",")
    vsatuan = Split(valsatuan, ",")
    vdisc1 = Split(valdisc1, ",")
    vdisc2 = Split(valdisc2, ",")
    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_OrPemH '"& agen &"', '"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", '"& appid &"' "
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        ' no = 0
        for i = 0 to ubound(vitem)  
        ' no = no + 1
        ' strid = id + right("000" & no,4)
            data_cmd.commandText = "INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_ItemID,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& id &"','"& vitem(i) &"',"& vqtty(i) &", '"& vharga(i) &"', '"& vsatuan(i) &"', '"& vdisc1(i) &"', '"& vdisc2(i) &"' ) "
            ' response.write data_cmd.commandText
            data_cmd.execute
        next
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub
%>