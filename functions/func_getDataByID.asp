<% 
sub getKategori(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT KategoriNama FROM DLK_M_Kategori WHERE KategoriID = '"& id &"'"
    set kategori = kategori.execute

    response.write kategori("KategoriNama")
end sub

sub getJenis(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT JenisNama FROM DLK_M_JenisBarang WHERE JenisID = '"& id &"'"
    set jenis = kategori.execute

    response.write jenis("JenisNama")
end sub

sub getVendor(id)
    set kategori =  Server.CreateObject ("ADODB.Command")
    kategori.ActiveConnection = mm_delima_string

    kategori.commandText = "SELECT Ven_Nama FROM DLK_M_Vendor WHERE Ven_ID = '"& id &"'"
    set jenis = kategori.execute

    response.write jenis("Ven_Nama")
end sub
%>