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
        
        arydata = Split(ckdorjul, ",")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE OJD_OJHID = '"& trim(arydata(0)) &"' AND OJD_OPHID = '"& trim(arydata(1)) &"' AND OJD_item = '"& trim(arydata(2)) &"' AND OJD_Harga = '"& trim(arydata(3)) &"' AND OJD_JenisSat = '"& trim(arydata(4)) &"' AND OJD_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            call query("INSERT INTO DLK_T_OrjulD (OJD_OJHID,OJD_Item,OJD_QtySatuan,OJD_Harga,OJD_JenisSat,OJD_Disc1,OJD_Disc2,OJD_OPHID,OJD_AktifYN) VALUES ('"& trim(arydata(0)) &"', '"& trim(arydata(2)) &"', "& qtyorjul &", '"& trim(arydata(3)) &"', '"& trim(arydata(4)) &"', "& disc1 &", "& disc2 &", '"& trim(arydata(1)) &"' ,'Y')")

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


%>