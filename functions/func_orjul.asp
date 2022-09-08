<% 
    sub tambahOrjul()
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        div = trim(Request.Form("div"))
        departement = trim(Request.Form("departement"))
        keterangan = trim(Request.Form("keterangan"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulH WHERE OJH_AgenID = '"& agen &"' AND OJH_Date = '"& tgl &"' AND OJH_divID = '"& div &"' AND OJH_depID = '"& departement &"' AND OJH_Keterangan = '"& keterangan &"' AND OJH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_OrJulH '"& agen &"', '"& tgl &"', '"& div &"', '"& departement &"', '"& keterangan &"'"
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
        agen = trim(Request.Form("agen"))
        ckdorjul = trim(Request.Form("ckdorjul"))
        qtyorjul = trim(Request.Form("qtyorjul"))
        satuan = trim(Request.Form("satuan"))
        nol = "000"
        
        arydata = Split(ckdorjul, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' AND OJD_item = '"& trim(arydata(1)) &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"'"

                set p = data_cmd.execute

                iddetail = trim(arydata(0)) & right(nol & p("urut"),3)

                call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& trim(arydata(1)) &"', "& qtyorjul &",'"& satuan &"')")
            else
                iddetail = trim(arydata(0)) & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& trim(arydata(1)) &"',"& qtyorjul &", '"& satuan &"')")

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
        qtyorjul = trim(Request.Form("qtyorjul"))
        satuan = trim(Request.Form("satuan"))
        nol = "000"
        
        arydata = Split(ckdorjul, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' AND OJD_item = '"& trim(arydata(1)) &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& trim(arydata(0)) &"'"

                set p = data_cmd.execute

                iddetail = trim(arydata(0)) & right(nol & p("urut"),3)

                call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& trim(arydata(1)) &"', "& qtyorjul &",'"& satuan &"')")
            else
                iddetail = trim(arydata(0)) & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& trim(arydata(1)) &"',"& qtyorjul &", '"& satuan &"')")

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