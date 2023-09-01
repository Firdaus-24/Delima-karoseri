<% 
    sub tambahOrjulH()
        agen = trim(Request.Form("agen"))
        tgl = trim(Request.Form("tgl"))
        customer = trim(Request.Form("customer"))
        tgljt = trim(Request.Form("tgljt"))
        diskon = trim(Request.Form("diskon"))
        ppn = trim(Request.Form("ppn"))
        timeWork = trim(Request.Form("timeWork"))
        keterangan = trim(Request.Form("keterangan"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM MKT_T_OrJulH WHERE OJH_AgenID = '"& agen &"' AND OJH_Date = '"& tgl &"' AND OJH_custID = '"& customer &"' AND OJH_JTDate = '"& tgljt &"' AND OJH_Keterangan = '"& keterangan &"' AND OJH_AktifYN = 'Y'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if data.eof then
            data_cmd.commandText = "exec sp_AddMKT_T_OrJulH '"& agen &"','"& tgl &"', '"& customer &"', '"& tgljt &"', '"& keterangan &"', '"& diskon &"', '"& ppn &"', '"& timeWork &"'"
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            id = p("ID")
            call alert("SALES ORDER HEADER", "berhasil di tambahkan", "success","sod_add.asp?id="&id) 
        else
            call alert("SALES ORDER HEADER", "sudah terdaftar", "warning","sod_add.asp")
        end if
    end sub

    sub tambahOrjulD()
        id = trim(Request.Form("id"))
        itemSo = trim(Request.Form("itemSo"))
        qty = trim(Request.Form("qty"))
        satuan = trim(Request.Form("satuan"))
        harga = replace(replace(replace(trim(Request.Form("harga")),",",""),".",""),"-","")
        diskon = trim(Request.Form("diskon"))
        keterangan = trim(Request.Form("keterangan"))
        
        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM MKT_T_OrJulD WHERE LEFT(OJD_OJHID, 13) = '"& id &"' AND OJD_item = '"& itemSo &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(OJD_OJHID),'000'),3)))+1),3)) as id From MKT_T_OrjulD Where Left(OJD_OJHID,13) = '"& id &"'"

            set a = data_cmd.execute

            call query  ("INSERT INTO MKT_T_OrjulD (OJD_OJHID, OJD_Item,OJD_Qtysatuan, OJD_JenisSat,OJD_Harga,OJD_Diskon,OJD_Keterangan,OJD_Updatetime,OJD_Updateid) VALUES ('"& a("id") &"','"& itemSo &"', "& qty &",'"& satuan &"','"& harga &"','"& diskon &"','"& keterangan &"','"& now &"','"& session("userid") &"')")

            call alert("DETAIL SALES ORDER", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
        else
        call alert("DETAIL SALES ORDER", "sudah terdaftar", "warning",Request.ServerVariables("HTTP_REFERER"))
        end if
    end sub
%>