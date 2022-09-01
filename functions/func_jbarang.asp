<% 
    Sub tambahPenjualan()
        ojhid = trim(Request.Form("ojhid"))
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        customer = trim(Request.Form("customer"))
        tgljt = trim(Request.Form("tgljt"))
        metpem = trim(Request.Form("metpem"))
        diskon = trim(Request.Form("diskon"))
        keterangan = trim(Request.Form("keterangan"))
        typejual = trim(Request.Form("typejual"))
        if diskon = "" then
            diskon = 0
        end if
        ppn = trim(Request.Form("ppn"))
        if ppn = "" then
            ppn = 0
        end if  

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_invJulH WHERE IJH_ojhid = '"& ojhid &"' AND IJH_AgenID = '"& agen &"' AND IJH_Date = '"& tgl &"' AND IJH_custID = '"& customer &"' AND IJH_JTDate = '"& tgljt &"' AND IJH_MetPem = "& metpem &" AND IJH_DiskonAll = '"& diskon &"' AND IJH_PPn = "& ppn &" AND IJH_AktifYN = 'Y' AND IJH_jual = "& typejual &""
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_invJulH '"& agen &"', '"& ojhid &"','"& tgl &"', '"& customer &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", "&typejual&" "
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")

            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("FAKTUR PENJUALAN", "berhasil ditambahkan", "success","jbarangd_add.asp?id="&id) 
        elseif value = 2 then
            call alert("FAKTUR PENJUALAN", "sudah terdaftar", "warning","jbarangd_add.asp?id="&id)
        else
            value = 0
        end if
    End Sub

    sub tambahDetailPenjualan()
        ckpenjualan = trim(Request.Form("ckpenjualan"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))
        qtyjual = trim(Request.Form("qtyjual"))
        nol = "000"
        
        arydata = Split(ckpenjualan, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& trim(arydata(0)) &"' AND IJD_item = '"& trim(arydata(2)) &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& trim(arydata(0)) &"' ORDER BY IJD_IJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& trim(arydata(0)) &"'"

                set p = data_cmd.execute

                iddetail = trim(arydata(0)) & right(nol & p("urut"),3)

                call query("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyjual &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            else
                iddetail = trim(arydata(0)) & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyjual &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            end if
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("ORDER DETAIL PENJUALAN", "berhasil di tambahkan", "success","jbarangd_add.asp?id="&trim(arydata(0))) 
        elseif value = 2 then
            call alert("ORDER DETAIL PENJUALAN", "sudah terdaftar", "warning","jbarangd_add.asp?id="&trim(arydata(0)))
        else
            value = 0
        end if

    end sub

    ' Sub updateFaktur()
    '     id = trim(Request.Form("id"))
    '     agen = trim(Request.Form("agen"))
    '     tgl = trim(Request.Form("tgl"))
    '     vendor = trim(Request.Form("vendor"))
    '     tgljt = trim(Request.Form("tgljt"))
    '     metpem = trim(Request.Form("metpem"))
    '     diskon = trim(Request.Form("diskon"))
    '     keterangan = trim(Request.Form("keterangan"))
    '     typebelanja = trim(Request.Form("typebelanja"))
    '     if diskon = "" then
    '         diskon = 0
    '     end if
    '     ppn = trim(Request.Form("ppn"))
    '     if ppn = "" then
    '         ppn = 0
    '     end if  

    '     ' detail
    '     valitem = trim(Request.Form("valitem"))
    '     valqtty = trim(Request.Form("valqtty"))
    '     valharga = trim(Request.Form("valharga"))
    '     valsatuan = trim(Request.Form("valsatuan"))
    '     valdisc1 = trim(Request.Form("valdisc1"))
    '     valdisc2 = trim(Request.Form("valdisc2"))

    '     vitem = Split(valitem, ",")
    '     vqtty = Split(valqtty, ",")
    '     vharga = Split(valharga, ",")
    '     vsatuan = Split(valsatuan, ",")
    '     vdisc1 = Split(valdisc1, ",")
    '     vdisc2 = Split(valdisc2, ",")

    '     ' add detail barang
    '     ' id = trim(Request.Form("id"))
    '     itemf = trim(Request.Form("itemf"))
    '     qtty = trim(Request.Form("qtty"))
    '     hargaf = trim(Request.Form("hargaf"))
    '     satuan = trim(Request.Form("satuan"))
    '     disc1 = trim(Request.Form("disc1"))
    '     disc2 = trim(Request.Form("disc2"))
    '     nol = "000"

    '     set data_cmd =  Server.CreateObject ("ADODB.Command")
    '     data_cmd.ActiveConnection = mm_delima_string

    '     data_cmd.commandText = "SELECT * FROM DLK_T_InvPemH WHERE IPH_ID = '"& id &"' AND IPH_AktifYN = 'Y'"
    '     ' response.write data_cmd.commandText & "<br>"
    '     set data = data_cmd.execute

    '     if not data.eof then
    '         ' add detail barang
    '         if itemf <> "" then
    '             data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& id &"' AND IPD_Item = '"& itemf &"'"
    '             ' response.write data_cmd.commandText & "<br>"
    '             set addetail = data_cmd.execute

    '             if addetail.eof then
    '                 data_cmd.commandText = "SELECT TOP 1 (right(IPD_IPHID,3)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& id &"' ORDER BY IPD_IPHID DESC"

    '                 set p = data_cmd.execute

    '                 if p.eof then
    '                     data_cmd.commandTExt = "SELECT (COUNT(IPD_IPHID)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& id &"'"

    '                     set a = data_cmd.execute

    '                     iddetail = id & right(nol & a("urut"),3)

    '                     call query("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& itemf &"',"& qtty &", '"& hargaf &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
    '                 else
    '                     iddetail = id & right(nol & p("urut"),3)

    '                     call query("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& itemf &"',"& qtty &", '"& hargaf &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
    '                 end if
    '                 value = 1 'case jika berhasi insert 
    '             else
    '                 value = 3 'case jika gagal insert 
    '             end if
    '         else
    '             call query("UPDATE DLK_T_InvPemH SET IPH_AgenID = '"& agen &"', IPH_Date = '"& tgl &"', IPH_VenID = '"& vendor &"', IPH_JTDate = '"& tgljt &"', IPH_MetPem = "& metpem &", IPH_DiskonAll = '"& diskon &"',IPH_PPn = "& ppn &", IPH_Keterangan = '"& keterangan &"', IPH_Belanja = "& typebelanja &" WHERE IPH_ID = '"& id &"' AND IPH_AktifYN = 'Y' ")

    '             for i = 0 to ubound(vitem) 
    '                 data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"' AND IPD_Item = '"& trim(vitem(i)) &"' AND IPD_Harga = '"& trim(vharga(i)) &"' AND IPD_JenisSat = '"& trim(vsatuan(i)) &"'"
    '                 ' response.write data_cmd.commandText & "<br>"
    '                 set q = data_cmd.execute

    '                 if not q.eof then
    '                     call query("UPDATE DLK_T_InvPemD SET IPD_QtySatuan = "& trim(vqtty(i)) &", IPD_Disc1 = '"& trim(vdisc1(i)) &"',IPD_Disc2 = '"& trim(vdisc2(i)) &"' WHERE IPD_IPHID = '"& q("IPD_IPHID") &"'")
    '                 end if
    '             next
    '         value = 1 'case untuk insert data
    '         end if
    '     else
    '         value = 2 'case jika gagal insert 
    '     end if

    '     if value = 1 then
    '         call alert("FAKTUR TERHUTANG", "berhasil di update", "success","faktur_u.asp?id="&id) 
    '     elseif value = 2 then
    '         call alert("FAKTUR TERHUTANG", "tidak terdaftar", "warning","faktur_u.asp?id="&id)
    '     elseif value = 3 then
    '         call alert("FAKTUR TERHUTANG", "Barang Sudah terdaftar", "warning","faktur_u.asp?id="&id)
    '     else
    '         value = 0
    '     end if
    ' End Sub
%>