<% 
Sub tambahProduksiH()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))
    keterangan = trim(Request.Form("keterangan"))
    prototype = trim(Request.Form("prototype"))
    model = trim(Request.Form("model"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiH WHERE PDH_AgenID = '"& agen &"' AND PDH_Date = '"& tgl &"' AND PDH_StartDate = '"& tgla &"' AND PDH_EndDate = '"& tgle &"' AND PDH_ProtoTypeYN = '"& prototype &"' AND PDH_Model = '"& model &"'"

    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_ProduksiH '"& agen &"', '"& tgl &"', '"& tgla &"', '"& tgle &"', '"& keterangan &"', '"& prototype &"', '"& model &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
    if value = 1 then
        call alert("FORM PRODUKSI", "berhasil ditambahkan", "success","prodd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("FORM PRODUKSI", "sudah terdaftar", "warning","prod_add.asp")
    else
        value = 0
    end if
End Sub
sub tambahProduksiD()
    id = trim(Request.Form("id"))
    bomid = trim(Request.Form("bomid"))
    picname = trim(Request.Form("picname"))
    capacity = Cint(trim(Request.Form("capacity")))

    a = split(bomid,",")

    ' set id bom
    strbomid = a(0)
    ' set brg id
    strbrgid = a(1)

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiD WHERE LEFT(PDD_ID,13) = '"& id &"' AND PDD_BMID = '"& strbomid &"'"

    set data = data_cmd.execute

    if not data.eof then
        call alert("FORM DETAIL PRODUKSI", "sudah terdaftar", "error","prodd_add.asp?id="&id)
    else
        dim i
        for i=1 to capacity 
            data_cmd.commandTExt = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(PDD_ID),'000'),3)))+1),3)) as id From DLK_T_ProduksiD Where Left(PDD_ID,13) = '"& id &"'"

            set getID = data_cmd.execute

            call query("INSERT INTO DLK_T_ProduksiD (PDD_ID,PDD_BMID,PDD_Item,PDD_PICName) VALUES ('"& getID("id") &"','"& strbomid &"', '"& strbrgid &"', '"& picname &"') ")
        response.flush
        next
        call alert("FORM DETAIL PRODUKSI", "berhasil didaftarkan", "success","prodd_add.asp?id="&id)
    end if 
end sub
sub updateProduksiD()
    id = trim(Request.Form("id"))
    bomid = trim(Request.Form("bomid"))
    picname = trim(Request.Form("picname"))
    capacity = Cint(trim(Request.Form("capacity")))

    a = split(bomid,",")

    ' set id bom
    strbomid = a(0)
    ' set brg id
    strbrgid = a(1)

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiD WHERE LEFT(PDD_ID,13) = '"& id &"' AND PDD_BMID = '"& strbomid &"'"

    set data = data_cmd.execute

    if not data.eof then
        call alert("FORM DETAIL PRODUKSI", "sudah terdaftar", "error","prod_u.asp?id="&id)
    else
        dim i
        for i=1 to capacity 
            data_cmd.commandTExt = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(PDD_ID),'000'),3)))+1),3)) as id From DLK_T_ProduksiD Where Left(PDD_ID,13) = '"& id &"'"

            set getID = data_cmd.execute

            call query("INSERT INTO DLK_T_ProduksiD (PDD_ID,PDD_BMID,PDD_Item,PDD_PICName) VALUES ('"& getID("id") &"','"& strbomid &"', '"& strbrgid &"','"& picname &"') ")
        response.flush
        next
        call alert("FORM DETAIL PRODUKSI", "berhasil didaftarkan", "success","prod_u.asp?id="&id)
    end if 
end sub
%>
