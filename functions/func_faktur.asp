<% 
    Sub tambahFaktur()
        ophid = trim(Request.Form("ophid"))
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        vendor = trim(Request.Form("vendor"))
        tgljt = trim(Request.Form("tgljt"))
        metpem = trim(Request.Form("metpem"))
        diskon = trim(Request.Form("diskon"))
        keterangan = trim(Request.Form("keterangan"))
        typebelanja = trim(Request.Form("typebelanja"))
        if diskon = "" then
            diskon = 0
        end if
        ppn = trim(Request.Form("ppn"))
        if ppn = "" then
            ppn = 0
        end if  

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_invPemH WHERE IPH_OPHID = '"& ophid &"' AND IPH_AgenID = '"& agen &"' AND IPH_Date = '"& tgl &"' AND IPH_VenID = '"& vendor &"' AND IPH_JTDate = '"& tgljt &"' AND IPH_MetPem = "& metpem &" AND IPH_DiskonAll = '"& diskon &"' AND IPH_PPn = "& ppn &" AND IPH_AktifYN = 'Y' AND IPH_Belanja = '"& typebelanja &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_invPemH '"& agen &"', '"& ophid &"','"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", "&typebelanja&" "
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")

            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("FAKTUR TERHUTANG", "berhasil ditambahkan", "success","fakturd_add.asp?id="&id) 
        elseif value = 2 then
            call alert("FAKTUR TERHUTANG", "sudah terdaftar", "warning","fakturd_add.asp?id="&id)
        else
            value = 0
        end if
    End Sub

    sub tambahDetailFaktur()
        id = trim(Request.Form("id"))
        itempo = trim(Request.Form("itempo"))
        qttypo = trim(Request.Form("qttypo"))
        hargapo = trim(Request.Form("hargapo"))
        satuanpo = trim(Request.Form("satuanpo"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& id &"' AND IPD_Item = '"& itempo &"' AND IPD_QtySatuan = "& qttypo &" AND IPD_Harga = '"& hargapo &"' AND IPD_JenisSat = '"& satuanpo &"' AND IPD_Disc1 = '"& disc1 &"' AND IPD_Disc2 = '"& disc2 &"' AND IPD_AktifYN = 'Y'"

        set q = data_cmd.execute
        
        if q.eof then
            data_cmd.commandText = "INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2,IPD_AktifYN) VALUES ('"& id &"','"& itempo &"',"& qttypo &", '"& hargapo &"', '"& satuanpo &"', '"& disc1 &"', '"& disc2 &"', 'Y' ) "
            ' response.write data_cmd.commandText & "<br>"
            data_cmd.execute

            value = 1
        else
            value = 2
        end if

        if value = 1 then
            call alert("DETAIL FAKTUR TERHUTANG", "berhasil ditambahkan", "success","fakturd_add.asp?id="&id) 
        elseif value = 2 then
            call alert("DETAIL FAKTUR TERHUTANG", "sudah terdaftar", "warning","fakturd_add.asp?id="&id)
        else
            value = 0
        end if

    end sub

    Sub updateFaktur()
        id = trim(Request.Form("id"))
        ophid = trim(Request.Form("ophid"))
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        vendor = trim(Request.Form("vendor"))
        tgljt = trim(Request.Form("tgljt"))
        metpem = trim(Request.Form("metpem"))
        diskon = trim(Request.Form("diskon"))
        keterangan = trim(Request.Form("keterangan"))
        typebelanja = trim(Request.Form("typebelanja"))
        if diskon = "" then
            diskon = 0
        end if
        ppn = trim(Request.Form("ppn"))
        if ppn = "" then
            ppn = 0
        end if  

        ' detail
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
        id = trim(Request.Form("id"))
        itemf = trim(Request.Form("itemf"))
        qtty = trim(Request.Form("qtty"))
        hargaf = trim(Request.Form("hargaf"))
        satuan = trim(Request.Form("satuan"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvPemH WHERE IPH_ID = '"& id &"' AND IPH_OPHID = '"& ophid &"' AND IPH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if not data.eof then
            ' add detail barang
            if itemf <> "" then
                data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& id &"' AND IPD_Item = '"& itemf &"' AND IPD_AKtifYN = 'Y'"

                set addetail = data_cmd.execute

                if addetail.eof then
                    data_cmd.commandText = "INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2,IPD_AktifYN) VALUES ('"& id &"','"& itemf &"',"& qtty &", '"& hargaf &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"', 'Y' ) "
                    ' response.write data_cmd.commandText & "<br>"
                    data_cmd.execute

                    value = 1 'case untuk insert data
                else
                    value = 2 'case jika gagal insert 
                end if
            else
                call query("UPDATE DLK_T_InvPemH SET IPH_AgenID = '"& agen &"', IPH_Date = '"& tgl &"', IPH_VenID = '"& vendor &"', IPH_JTDate = '"& tgljt &"', IPH_MetPem = "& metpem &", IPH_DiskonAll = '"& diskon &"',IPH_PPn = "& ppn &", IPH_Keterangan = '"& keterangan &"', IPH_Belanja = "& typebelanja &" WHERE IPH_ID = '"& id &"' AND IPH_AktifYN = 'Y' ")

                for i = 0 to ubound(vitem) 
                    data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& data("IPH_ID") &"' AND IPD_Item = '"& trim(vitem(i)) &"' AND IPD_Harga = '"& trim(vharga(i)) &"' AND IPD_JenisSat = '"& trim(vsatuan(i)) &"' AND IPD_AktifYN = 'Y'"
                    ' response.write data_cmd.commandText & "<br>"
                    set q = data_cmd.execute

                    if not q.eof then
                        data_cmd.commandText = "UPDATE DLK_T_InvPemD SET IPD_QtySatuan = "& trim(vqtty(i)) &", IPD_Disc1 = '"& trim(vdisc1(i)) &"',IPD_Disc2 = '"& trim(vdisc2(i)) &"' WHERE IPD_IPHID = '"& data("IPH_ID") &"' AND IPD_Item = '"& trim(vitem(i)) &"'  AND IPD_AktifYN ='Y'"
                        ' response.write data_cmd.commandText & "<br>"
                        data_cmd.execute
                    end if
                next
            value = 1 'case untuk insert data
            end if
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("FAKTUR TERHUTANG", "berhasil di update", "success","faktur_u.asp?id="&id) 
        elseif value = 2 then
            call alert("FAKTUR TERHUTANG", "tidak terdaftar", "warning","faktur_u.asp?id="&id)
        else
            value = 0
        end if
    End Sub
%>