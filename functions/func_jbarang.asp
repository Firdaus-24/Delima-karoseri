<% 
    Sub tambahPenjualan()
        ojhid = trim(Request.Form("ojhid"))
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        tgljt = trim(Request.Form("tgljt"))
        produksi = trim(Request.Form("produksi"))
        kebutuhan = trim(Request.Form("kebutuhan"))
        keterangan = trim(Request.Form("keterangan"))
        diskon = 0
        ppn = 0

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_invJulH WHERE IJH_ojhid = '"& ojhid &"' AND IJH_AgenID = '"& agen &"' AND IJH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_invJulH '"& agen &"', '"& ojhid &"','"& tgl &"', '"& produksi &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& kebutuhan &" "
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
        id = trim(Request.Form("id"))
        ckpenjualan = trim(Request.Form("ckpenjualan"))
        satuan = trim(Request.Form("satuan"))
        qtyjual = Cint(trim(Request.Form("qtyjual")))
        nol = "000"

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' AND IJD_item = '"& ckpenjualan &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        ' get data stok 
        data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_Ppn FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemD.IPD_Item = '"& ckpenjualan &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("IJH_AgenID") &"') ORDER BY dbo.DLK_T_InvPemH.IPH_Date ASC"
        ' response.write data_cmd.commandText & "<br>"
        set datastok = data_cmd.execute

        angka = 0
        if orjul.eof then
            do while not datastok.eof
            ' cek data barang keluar 
            data_cmd.commandText = "SELECT SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan) as qty, dbo.DLK_T_InvJulD.IJD_Item, dbo.DLK_T_InvJulD.IJD_IPDIPHID FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"&data("IJH_AgenID")&"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_IPDIPHID = '"& datastok("IPD_IphID") &"') GROUP BY dbo.DLK_T_InvJulD.IJD_Item, dbo.DLK_T_InvJulD.IJD_IPDIPHID "
            ' response.write data_cmd.commandText & "<br>"
            set brgkeluar = data_cmd.execute

            if not brgkeluar.eof then
                getdatastok = Cint(datastok("IPD_QtySatuan")) - Cint(brgkeluar("qty"))
                if getdatastok > 0 then
                    if getdatastok > qtyjual then
                    data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                    set a = data_cmd.execute

                        if a.eof then
                            tharga = datastok("IPD_Harga")
                            tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))

                            data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                            set p = data_cmd.execute

                            iddetail = id & right(nol & p("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = getdatastok - qtyjual
                        else
                            iddetail = id & right(nol & a("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = getdatastok - qtyjual
                        end if
                    else
                    data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                    set a = data_cmd.execute

                        if a.eof then
                            tharga = datastok("IPD_Harga")
                            tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))

                            data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                            set p = data_cmd.execute

                            iddetail = id & right(nol & p("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& getdatastok &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = qtyjual - getdatastok
                        else
                            iddetail = id & right(nol & a("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& getdatastok &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = qtyjual - getdatastok
                        end if
                    end if
                end if
            else
                tharga = datastok("IPD_Harga")
                tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))
                
                data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                set a = data_cmd.execute

                if a.eof then
                    data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                    set p = data_cmd.execute

                    iddetail = id & right(nol & p("urut"),3)
                    
                    if qtyjual > Cint(datastok("IPD_QtySatuan")) then
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& datastok("IPD_QtySatuan") &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = qtyjual - Cint(datastok("IPD_QtySatuan"))
                    else
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = 0
                    end if
                else
                    iddetail = id & right(nol & a("urut"),3)
                    
                    if qtyjual > Cint(datastok("IPD_QtySatuan")) then
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& datastok("IPD_QtySatuan") &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = qtyjual - Cint(datastok("IPD_QtySatuan"))
                    else
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = 0
                    end if
                end if
            end if
            if qtyjual <= 0 then
                exit do
            end if
            response.flush
            datastok.movenext
            loop
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("ORDER DETAIL PENJUALAN", "berhasil di tambahkan", "success","jbarangd_add.asp?id="&id) 
        elseif value = 2 then
            call alert("ORDER DETAIL PENJUALAN", "sudah terdaftar", "warning","jbarangd_add.asp?id="&id)
        else
            value = 0
        end if

    end sub

    Sub updatePenjualan()
        id = trim(Request.Form("id"))
        ckpenjualan = trim(Request.Form("ckpenjualan"))
        satuan = trim(Request.Form("satuan"))
        qtyjual = Cint(trim(Request.Form("qtyjual")))
        nol = "000"

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' AND IJD_item = '"& ckpenjualan &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        ' get data stok 
        data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_Ppn FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemD.IPD_Item = '"& ckpenjualan &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("IJH_AgenID") &"') ORDER BY dbo.DLK_T_InvPemH.IPH_Date ASC"
        ' response.write data_cmd.commandText & "<br>"
        set datastok = data_cmd.execute

        if orjul.eof then
            do while not datastok.eof
            ' cek data barang keluar 
            data_cmd.commandText = "SELECT SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan) as qty, dbo.DLK_T_InvJulD.IJD_Item, dbo.DLK_T_InvJulD.IJD_IPDIPHID FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"&data("IJH_AgenID")&"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_IPDIPHID = '"& datastok("IPD_IphID") &"') GROUP BY dbo.DLK_T_InvJulD.IJD_Item, dbo.DLK_T_InvJulD.IJD_IPDIPHID "
            ' response.write data_cmd.commandText & "<br>"
            set brgkeluar = data_cmd.execute

            if not brgkeluar.eof then
                getdatastok = Cint(datastok("IPD_QtySatuan")) - Cint(brgkeluar("qty"))
                if getdatastok > 0 then
                    if getdatastok > qtyjual then
                    data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                    set a = data_cmd.execute

                        if a.eof then
                            tharga = datastok("IPD_Harga")
                            tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))

                            data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                            set p = data_cmd.execute

                            iddetail = id & right(nol & p("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = getdatastok - qtyjual
                        else
                            iddetail = id & right(nol & a("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = getdatastok - qtyjual
                        end if
                    else
                    data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                    set a = data_cmd.execute

                        if a.eof then
                            tharga = datastok("IPD_Harga")
                            tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))

                            data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                            set p = data_cmd.execute

                            iddetail = id & right(nol & p("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& getdatastok &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = qtyjual - getdatastok
                        else
                            iddetail = id & right(nol & a("urut"),3)

                            call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& getdatastok &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                            qtyjual = qtyjual - getdatastok
                        end if
                    end if
                end if
            else
                tharga = datastok("IPD_Harga")
                tppn = Round(tharga + (tharga * datastok("IPH_PPN") / 100))
                
                data_cmd.commandText = "SELECT TOP 1 (right(IJD_IJHID,3)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"' ORDER BY IJD_IJHID DESC"

                set a = data_cmd.execute

                if a.eof then
                    data_cmd.commandText = "SELECT (COUNT(IJD_IJHID)) + 1 AS urut FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& id &"'"

                    set p = data_cmd.execute

                    iddetail = id & right(nol & p("urut"),3)
                    
                    if qtyjual > Cint(datastok("IPD_QtySatuan")) then
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& datastok("IPD_QtySatuan") &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = qtyjual - Cint(datastok("IPD_QtySatuan"))
                    else
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = 0
                    end if
                else
                    iddetail = id & right(nol & a("urut"),3)
                    
                    if qtyjual > Cint(datastok("IPD_QtySatuan")) then
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& datastok("IPD_QtySatuan") &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = qtyjual - Cint(datastok("IPD_QtySatuan"))
                    else
                        call query ("INSERT INTO DLK_T_InvJulD (IJD_IJHID,IJD_Item,IJD_QtySatuan,IJD_Harga,IJD_JenisSat,IJD_Disc1,IJD_Disc2,IJD_IPDIPHID, IJD_RakID) VALUES ('"& iddetail &"', '"& ckpenjualan &"', "& qtyjual &", '"& tppn &"', '"& satuan &"', 0, 0, '"& datastok("IPD_IPHID") &"', '"& datastok("IPD_Rakid") &"')") 

                        qtyjual = 0
                    end if
                end if
            end if
            if qtyjual <= 0 then
                exit do
            end if
            response.flush
            datastok.movenext
            loop
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("ORDER DETAIL PENJUALAN", "berhasil di tambahkan", "success","jbarang_u.asp?id="&id) 
        elseif value = 2 then
            call alert("ORDER DETAIL PENJUALAN", "sudah terdaftar", "warning","jbarang_u.asp?id="&id)
        else
            value = 0
        end if
    End Sub
%>