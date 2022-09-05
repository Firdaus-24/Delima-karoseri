<% 
' function getHari
sub getHari(e)
    if e = 1 then
        response.write "Senin"
    elseIf e = 2 then
        response.write "Selasa"
    elseIf e = 3 then
        response.write "Rabu"
    elseIf e = 4 then
        response.write "Kamis"
    elseIf e = 5 then
        response.write "Jum'at"
    elseIf e = 6 then
        response.write "Sabtu"
    else
        response.write "Minggu"
    end if
end sub
'kategori
sub getKategori(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT KategoriNama FROM DLK_M_Kategori WHERE KategoriID = '"& id &"'"
    set kategori = kategori.execute

    response.write kategori("KategoriNama")
end sub
' jenis
sub getJenis(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT JenisNama FROM DLK_M_JenisBarang WHERE JenisID = '"& id &"'"
    set jenis = kategori.execute

    response.write jenis("JenisNama")
end sub
' vendor
sub getVendor(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT Ven_Nama FROM DLK_M_Vendor WHERE Ven_ID = '"& id &"'"
    set jenis = kategori.execute

    response.write jenis("Ven_Nama")
end sub
' satuan berat
sub getSatBerat(id)
    set satberat =  Server.CreateObject ("ADODB.Command")
    satberat.ActiveConnection = mm_delima_string

    satberat.commandText = "SELECT Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_ID = '"& id &"'"
    set satberat = satberat.execute

    response.write satberat("Sat_Nama")
end sub
' divisi
sub getDivisi(id)
    set getDivisi_cmd =  Server.CreateObject ("ADODB.Command")
    getDivisi_cmd.ActiveConnection = mm_delima_string

    getDivisi_cmd.commandText = "SELECT DivNama FROM DLK_M_Divisi where DivID = '"& id &"'"
    ' response.write getDivisi_cmd.commandText
    set getDiv = getDivisi_cmd.execute

    response.write getDiv("divNama")
end sub
' agen untuk permintaan barang
sub getAgen(id,name)
    set getagen_cmd =  Server.CreateObject ("ADODB.Command")
    getagen_cmd.ActiveConnection = mm_delima_string

    getagen_cmd.commandText = "SELECT AgenName FROM GLB_M_Agen where agenID = '"& id &"'"
    ' response.write getagen_cmd.commandText
    set gAgen = getagen_cmd.execute

    if name = "" then
        pbarang = trim(replace(gAgen("agenName"),"PT.",""))
        e = split(pbarang," ")
        realname = ""
        For Each x In e 
            realname = left(x,1) 
            response.write realname
        next
    else
        response.write gAgen("agenName")
    end if
end sub
%>