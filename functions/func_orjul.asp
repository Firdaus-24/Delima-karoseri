<% 
    sub tambahOrjulH()
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        divisi = trim(Request.Form("divisi"))
        departement = trim(Request.Form("departement"))
        kebutuhan = Cint(trim(Request.Form("kebutuhan")))
        produk = trim(Request.Form("produk"))
        keterangan = trim(Request.Form("keterangan"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulH WHERE OJH_AgenID = '"& agen &"' AND OJH_Date = '"& tgl &"' AND OJH_divID = '"& divisi &"' AND OJH_depID = '"& departement &"' AND OJH_Kebutuhan = "& kebutuhan &" AND OJH_PDID = '"& produk &"' AND OJH_Keterangan = '"& keterangan &"' AND OJH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_OrJulH '"& agen &"','"& tgl &"', '"& divisi &"', '"& departement &"', '"& keterangan &"', '"& produk &"', "& kebutuhan &""
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if
        
        if value = 1 then
            call alert("PERMINTAAN BARANG", "berhasil di tambahkan", "success","permintaand_add.asp?id="&id) 
        elseif value = 2 then
            call alert("PERMINTAAN BARANG", "sudah terdaftar", "warning","permintaand_add.asp?id="&id)
        else
            value = 0
        end if

    end sub

    sub tambahOrjulD()
        ojhid = trim(Request.Form("ojhid"))
        brg = trim(Request.Form("brg"))
        qtty = trim(Request.Form("qtty"))
        satuan = trim(Request.Form("satuan"))
        nol = "000"
        
        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID, 13) = '"& ojhid &"' AND OJD_item = '"& brg &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& ojhid &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& ojhid &"'"

                set p = data_cmd.execute

                iddetail = ojhid & right(nol & p("urut"),3)

                call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID, OJD_Item,OJD_Qtysatuan, OJD_JenisSat) VALUES ('"& iddetail &"','"& brg &"', "& qtty &",'"& satuan &"')")
            else
                iddetail = ojhid & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_Qtysatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& brg &"',"& qtty &", '"& satuan &"')")

            end if
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("PERMINTAAN DETAIL BARANG", "berhasil di tambahkan", "success","permintaand_add.asp?id="&ojhid) 
        elseif value = 2 then
            call alert("PERMINTAAN DETAIL BARANG", "sudah terdaftar", "warning","permintaand_add.asp?id="&ojhid)
        else
            value = 0
        end if
    end sub

    sub updatedetailOrjul()
        ojhid = trim(Request.Form("ojhid"))
        brg = trim(Request.Form("brg"))
        qtty = trim(Request.Form("qtty"))
        satuan = trim(Request.Form("satuan"))
        nol = "000"
        
        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID, 13) = '"& ojhid &"' AND OJD_item = '"& brg &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(OJD_OJHID,3)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& ojhid &"' ORDER BY OJD_OJHID DESC"

            set a = data_cmd.execute

            if a.eof then
                data_cmd.commandText = "SELECT (COUNT(OJD_OJHID)) + 1 AS urut FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& ojhid &"'"

                set p = data_cmd.execute

                iddetail = ojhid & right(nol & p("urut"),3)

                call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID, OJD_Item,OJD_Qtysatuan, OJD_JenisSat) VALUES ('"& iddetail &"','"& brg &"', "& qtty &",'"& satuan &"')")
            else
                iddetail = ojhid & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_Qtysatuan,OJD_JenisSat) VALUES ('"& iddetail &"', '"& brg &"',"& qtty &", '"& satuan &"')")

            end if
            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("PERMINTAAN DETAIL BARANG", "berhasil di tambahkan", "success","permintaan_u.asp?id="&ojhid) 
        elseif value = 2 then
            call alert("PERMINTAAN DETAIL BARANG", "sudah terdaftar", "warning","permintaan_u.asp?id="&ojhid)
        else
            value = 0
        end if
    end sub


%>