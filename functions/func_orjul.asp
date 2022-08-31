<% 
    sub tambahOrjul()
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

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulH WHERE OJH_AgenID = '"& agen &"' AND OJH_Date = '"& tgl &"' AND OJH_custID = '"& customer &"' AND OJH_JTDate = '"& tgljt &"' AND OJH_MetPem = "& metpem &" AND OJH_DiskonAll = '"& diskon &"' AND OJH_PPn = "& ppn &" AND OJH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_OrJulH '"& agen &"', '"& tgl &"', '"& customer &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &""
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if
        
        if value = 1 then
            call alert("ORDER PENJUALAN", "berhasil di tambahkan", "success","orjuld_add.asp?id="&id) 
        elseif value = 2 then
            call alert("ORDER PENJUALAN", "sudah terdaftar", "warning","orjuld_add.asp?id="&id)
        else
            value = 0
        end if

    end sub

    sub detailOrjul()
        ckdorjul = trim(Request.Form("ckdorjul"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))
        qtyorjul = trim(Request.Form("qtyorjul"))
        nol = "000"
        
        arydata = Split(ckdorjul, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' AND OJD_item = '"& trim(arydata(2)) &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"'"

                set p = data_cmd.execute

                iddetail = trim(arydata(0)) & right(nol & p("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyorjul &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            else
                iddetail = trim(arydata(0)) & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyorjul &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            end if
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("ORDER DETAIL PENJUALAN", "berhasil di tambahkan", "success","orjuld_add.asp?id="&trim(arydata(0))) 
        elseif value = 2 then
            call alert("ORDER DETAIL PENJUALAN", "sudah terdaftar", "warning","orjuld_add.asp?id="&trim(arydata(0)))
        else
            value = 0
        end if
    end sub

    sub updatedetailOrjul()
        ckdorjul = trim(Request.Form("ckdorjul"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))
        qtyorjul = trim(Request.Form("qtyorjul"))
        nol = "000"
        
        arydata = Split(ckdorjul, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' AND OJD_item = '"& trim(arydata(2)) &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"'"

                set p = data_cmd.execute

                iddetail = trim(arydata(0)) & right(nol & p("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyorjul &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            else
                iddetail = trim(arydata(0)) & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_IPDIPHID) VALUES ('"& iddetail &"', '"& trim(arydata(2)) &"', "& qtyorjul &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"')")

            end if
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("ORDER DETAIL PENJUALAN", "berhasil di tambahkan", "success","orjul_u.asp?id="&trim(arydata(0))) 
        elseif value = 2 then
            call alert("ORDER DETAIL PENJUALAN", "sudah terdaftar", "warning","orjul_u.asp?id="&trim(arydata(0)))
        else
            value = 0
        end if
    end sub


%>