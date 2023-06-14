<% 
sub tambahBarang()
    agen = trim(Request.Form("agen"))
    nama = UCase(trim(Request.Form("nama")))
    kategori = trim(Request.Form("kategori"))
    jenis = trim(Request.Form("jenis"))
    tgl = trim(Request.Form("tgl"))
    minstok = 0
    jual = "Y"
    stok = "N"
    typebrg = trim(Request.Form("typebrg"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE UPPER(Brg_Nama) = '"& UCase(nama) &"' AND KategoriId = '"&  kategori &"' AND JenisID = '"& jenis &"' AND Brg_type = '"& typebrg &"' AND Brg_AktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Barang '"& agen &"','"& nama &"', '"& tgl &"', '"& jenis &"','"& kategori &"','"& stok &"','"& jual &"','', "& minstok &", '"& typebrg &"'")
        call alert("MASTER MODEL", "berhasil di tambahkan", "success", "m_add.asp")
    else
        call alert("MASTER MODEL", "sudah terdaftar", "error", "m_add.asp")
    end if
end sub

sub updateBarang()
    id = trim(Request.Form("id"))
    nama = UCase(trim(Request.Form("nama")))
    kategori = trim(Request.Form("kategori"))
    jenis = trim(Request.Form("jenis"))
    typebrg = trim(Request.Form("typebrg"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_ID = '"& id &"' AND Brg_AktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Barang SET Brg_Nama = '"& nama &"', KategoriId = '"& kategori &"', JenisID = '"& jenis &"', Brg_Type = '"& typebrg &"' WHERE Brg_ID = '"& id &"'")
        call alert("MASTER MODEL", "berhasil di update", "success", Request.ServerVariables("HTTP_REFERER"))
    else
        call alert("MASTER MODEL", "data tidak terdaftar", "error", Request.ServerVariables("HTTP_REFERER"))
    end if
end sub 
%>