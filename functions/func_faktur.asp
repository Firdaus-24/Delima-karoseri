<% 
    Sub tambahFaktur()
        ophid = trim(Request.Form("ophid"))
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        vendor = trim(Request.Form("vendor"))
        tgljt = trim(Request.Form("tgljt"))
        keterangan = trim(Request.Form("keterangan"))
        diskon = trim(Request.Form("diskonall"))
        ppn = trim(Request.Form("ppn"))
        asuransi = trim(replace(replace(Request.Form("asuransi"),".",""),",-",""))
        lain = trim(replace(replace(Request.Form("lain"),".",""),",-",""))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_invPemH WHERE IPH_OPHID = '"& ophid &"' AND IPH_AgenID = '"& agen &"' AND IPH_Date = '"& tgl &"' AND IPH_VenID = '"& vendor &"' AND IPH_JTDate = '"& tgljt &"' AND IPH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddDLK_T_invPemH '"& agen &"', '"& ophid &"','"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', '"& diskon &"', '"& ppn &"', '"& asuransi &"', '"& lain &"', ''"
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
        iphid = trim(Request.Form("iphid"))
        ckinv = trim(Request.Form("ckinv"))
        qtty = trim(Request.Form("qtty"))
        hargainv = replace(replace(trim(Request.Form("hargainv")),".",""),",-","")
        satuan = trim(Request.Form("satuan"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))
        nol = "000"

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"' AND IPD_Item = '"& ckinv &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute
        
        if data.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(IPD_IPHID,3)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"' ORDER BY IPD_IPHID DESC"
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            if p.eof then
                data_cmd.commandTExt = "SELECT (COUNT(IPD_IPHID)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"'"
                ' response.write data_cmd.commandText & "<br>"
                set a = data_cmd.execute

                iddetail = iphid & right(nol & a("urut"),3)
                ' response.write iddetail & "<br>"
                call query ("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& ckinv &"',"& qtty &", '"& hargainv &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
            else
                iddetail = iphid & right(nol & p("urut"),3)

                call query ("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& ckinv &"',"& qtty &", '"& hargainv &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
            end if
            value = 1
        else
            value = 2
        end if

        if value = 1 then
            call alert("DETAIL FAKTUR TERHUTANG", "berhasil ditambahkan", "success","fakturd_add.asp?id="&iphid) 
        elseif value = 2 then
            call alert("DETAIL FAKTUR TERHUTANG", "sudah terdaftar", "warning","fakturd_add.asp?id="&iphid)
        else
            value = 0
        end if
    end sub

    Sub updateFaktur()
        iphid = trim(Request.Form("iphid"))
        ckinv = trim(Request.Form("ckinv"))
        qtty = trim(Request.Form("qtty"))
        hargainv = replace(replace(trim(Request.Form("hargainv")),".",""),",-","")
        satuan = trim(Request.Form("satuan"))
        disc1 = trim(Request.Form("disc1"))
        disc2 = trim(Request.Form("disc2"))
        nol = "000"

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"' AND IPD_Item = '"& ckinv &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute
        
        if data.eof then
            data_cmd.commandText = "SELECT TOP 1 (right(IPD_IPHID,3)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"' ORDER BY IPD_IPHID DESC"

            set p = data_cmd.execute

            if p.eof then
                data_cmd.commandTExt = "SELECT (COUNT(IPD_IPHID)) + 1 AS urut FROM DLK_T_InvPemD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"'"

                set a = data_cmd.execute

                iddetail = iphid & right(nol & a("urut"),3)

                call query("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& ckinv &"',"& qtty &", '"& hargainv &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
            else
                iddetail = iphid & right(nol & p("urut"),3)

                call query("INSERT INTO DLK_T_InvPemD (IPD_IPHID, IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_Disc1,IPD_Disc2) VALUES ('"& iddetail &"','"& ckinv &"',"& qtty &", '"& hargainv &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
            end if
            value = 1
        else
            value = 2
        end if

        if value = 1 then
            call alert("FAKTUR TERHUTANG", "berhasil ditambahkan", "success","faktur_u.asp?id="&id) 
        elseif value = 2 then
            call alert("FAKTUR TERHUTANG", "sudah terdaftar", "warning","faktur_u.asp?id="&id)
        else
            value = 0
        end if
    End Sub
%>