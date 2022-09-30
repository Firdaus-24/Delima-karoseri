<% 
sub tambahProduksiH()
    barang = trim(Request.Form("barang"))
    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    kdakun = trim(Request.Form("kdakun"))
    capacityday = trim(Request.Form("capacityday"))
    capacitymonth = trim(Request.Form("capacitymonth"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ProductH WHERE PDBrgID = '"& barang &"' AND PDAgenID = '"& cabang &"'"

    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec SP_AddDLK_T_ProductH '"& barang &"', '"& tgl &"', '"& cabang &"', '"& kdakun &"', "& capacityday &", "& capacitymonth &", '"& keterangan &"'"

        set p = data_cmd.execute

        id = p("ID")

        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("MATER PRODUKSI", "berhasil di tambahkan", "success","productd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("MATER PRODUKSI", "sudah terdaftar", "warning", "product_add.asp")
    else
        value = 0
    end if
end sub

sub tambahProduksiD()
    pdid = trim(Request.Form("pdid"))
    ckproduckd = trim(Request.Form("ckproduckd"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    nol = "000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ProductD WHERE PDDItem = '"& ckproduckd &"' AND LEFT(PDDPDID,12) = '"& pdid &"'"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "SELECT (COUNT(PDDPDID)) + 1 AS urut FROM DLK_T_ProductD WHERE left(PDDPDID,12) = '"& pdid &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        iddetail = pdid & right(nol & p("urut"),3)

        call query("INSERT INTO DLK_T_ProductD (PDDPDID, PDDItem, PDDSpect, PDDQtty, PDDjenissat) VALUES ( '"& iddetail &"','"& ckproduckd &"', '"& spect &"', "& qtty &",'"& satuan &"')")

        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN DETAIL PRODUKSI", "berhasil di tambahkan", "success","productd_add.asp?id="&pdid) 
    elseif value = 2 then
        call alert("RINCIAN DETAIL PRODUKSI", "sudah terdaftar", "warning","productd_add.asp?id="&pdid)
    else
        value = 0
    end if
end sub

sub updateProduksi()
    pdid = trim(Request.Form("pdid"))
    ckproduckd = trim(Request.Form("ckproduckd"))
    spect = trim(Request.Form("spect"))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    nol = "000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ProductD WHERE LEFT(PDDPDID,12) = '"& pdid &"' AND PDDItem = '"& ckproduckd &"'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
    
    if data.eof then
        data_cmd.commandText = "SELECT TOP 1 (right(PDDPDID,3)) + 1 AS urut FROM DLK_T_ProductD WHERE LEFT(PDDPDID,12) = '"& pdid &"' ORDER BY PDDPDID DESC"

        set p = data_cmd.execute

        if p.eof then
            data_cmd.commandTExt = "SELECT (COUNT(PDDPDID)) + 1 AS urut FROM DLK_T_ProductD WHERE LEFT(PDDPDID,12) = '"& pdid &"'"

            set a = data_cmd.execute

            iddetail = pdid & right(nol & a("urut"),3)

            call query("INSERT INTO DLK_T_ProductD (PDDPDID, PDDItem, PDDSpect, PDDQtty, PDDJenisSat) VALUES ('"& iddetail &"','"& ckproduckd &"', '"& spect &"', "& qtty &", '"& satuan &"') ")
        else
            iddetail = pdid & right(nol & p("urut"),3)

            call query("INSERT INTO DLK_T_ProductD (PDDPDID, PDDItem, PDDSpect, PDDQtty, PDDJenisSat) VALUES ('"& iddetail &"','"& ckproduckd &"', '"& spect &"', "& qtty &", '"& satuan &"') ")
        end if
        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("DETAIL BARANG PRODUKSI", "berhasil ditambahkan", "success","product_u.asp?id="&pdid) 
    elseif value = 2 then
        call alert("DETAIL BARANG PRODUKSI", "sudah terdaftar", "warning","product_u.asp?id="&pdid)
    else
        value = 0
    end if
end sub
%>