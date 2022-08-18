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

        data_cmd.commandText = "SELECT * FROM DLK_T_invPemH WHERE IPH_OPHID = '"& ophid &"' AND IPH_AgenID = '"& agen &"' AND IPH_Date = '"& tgl &"' AND IPH_VenID = '"& vendor &"' AND IPH_JTDate = '"& tgljt &"' AND IPH_MetPem = "& metpem &" AND IPH_DiskonAll = '"& diskon &"' AND IPH_PPn = "& ppn &" AND IPH_AktifYN = 'Y' AND IPH_Belanja = '"& typebelanja &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_invPemH '"& agen &"', '"& ophid &"','"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", "&typebelanja&" "
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")

            for i = 0 to ubound(vitem)  
                data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& id &"' AND IPD_Item = '"& vitem(i) &"' AND IPD_QtySatuan = "& vqtty(i) &" AND IPD_Harga = '"& vharga(i) &"' AND IPD_JenisSat = '"& vsatuan(i) &"' AND IPD_Disc1 = '"& vdisc1(i) &"' AND IPD_Disc2 = '"& vdisc2(i) &"' AND IPD_AktifYN = 'Y'"

                set q = data_cmd.execute
                
                if q.eof then
                    data_cmd.commandText = "INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2,IPD_AktifYN) VALUES ('"& id &"','"& trim(vitem(i)) &"',"& trim(vqtty(i)) &", '"& trim(vharga(i)) &"', '"& trim(vsatuan(i)) &"', '"& trim(vdisc1(i)) &"', '"& trim(vdisc2(i)) &"', 'Y' ) "
                    ' response.write data_cmd.commandText & "<br>"
                    data_cmd.execute
                end if
            next
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if
    End Sub

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

        data_cmd.commandText = "SELECT * FROM DLK_T_InvPemH WHERE IPH_ID = '"& id &"' AND IPH_OPHID = '"& ophid &"' AND IPH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if not data.eof then
            call query("UPDATE DLK_T_InvPemH SET IPH_AgenID = '"& agen &"', IPH_Date = '"& tgl &"', IPH_VenID = '"& vendor &"', IPH_JTDate = '"& tgljt &"', IPH_MetPem = "& metpem &", IPH_DiskonAll = '"& diskon &"',IPH_PPn = "& ppn &", IPH_Keterangan = '"& keterangan &"', IPH_Belanja = "& typebelanja &" WHERE IPH_ID = '"& id &"' AND IPH_AktifYN = 'Y' ")

            for i = 0 to ubound(vitem) 
                data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE IPD_IPHID = '"& data("IPH_ID") &"' AND IPD_Item = '"& trim(oldvitem(i)) &"' AND IPD_QtySatuan = "& trim(oldvqtty(i)) &" AND IPD_Harga = '"& trim(oldvharga(i)) &"' AND IPD_JenisSat = '"& trim(oldvsatuan(i)) &"' AND IPD_Disc1 = '"& trim(oldvdisc1(i)) &"' AND IPD_Disc2 = '"& trim(oldvdisc2(i)) &"' AND IPD_AktifYN = 'Y'"
                ' response.write data_cmd.commandText & "<br>"
                set q = data_cmd.execute

                if not q.eof then
                    data_cmd.commandText = "UPDATE DLK_T_InvPemD SET IPD_Item ='"& trim(vitem(i)) &"', IPD_QtySatuan = "& trim(vqtty(i)) &", IPD_Harga = '"& trim(vharga(i)) &"', IPD_JenisSat = '"& trim(vsatuan(i)) &"', IPD_Disc1 = '"& trim(vdisc1(i)) &"',IPD_Disc2 = '"& trim(vdisc2(i)) &"' WHERE IPD_IPHID = '"& data("IPH_ID") &"' AND IPD_Item = '"& trim(oldvitem(i)) &"'  AND IPD_AktifYN ='Y'"
                    ' response.write data_cmd.commandText & "<br>"
                    data_cmd.execute
                else
                    data_cmd.commandText = "INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2,IPD_AktifYN) VALUES ('"& id &"','"& trim(vitem(i)) &"',"& trim(vqtty(i)) &", '"& trim(vharga(i)) &"', '"& trim(vsatuan(i)) &"', '"& trim(vdisc1(i)) &"', '"& trim(vdisc2(i)) &"', 'Y' ) "
                    ' response.write data_cmd.commandText & "<br>"
                    data_cmd.execute
                end if
            next
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if
    End Sub
%>