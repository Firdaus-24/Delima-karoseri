<% 
sub tambahBarang()
    agen = trim(Request.Form("agen"))
    nama = UCase(trim(Request.Form("nama")))
    kategori = trim(Request.Form("kategori"))
    jenis = trim(Request.Form("jenis"))
    tgl = trim(Request.Form("tgl"))
    jual = trim(Request.Form("jual"))
    stok = trim(Request.Form("stok"))
    harga = replace(replace(Request.Form("harga"),".00",""),",","")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_Nama = '"& nama &"' AND KategoriId = '"&  kategori &"' AND JenisID = '"& jenis &"' AND Brg_tanggal = '"& tgl &"' AND Brg_Harga = "& harga &""
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_AddDLK_M_Barang '"& agen &"','"& nama &"', '"& tgl &"', "& harga &", '"& jenis &"','"& kategori &"','"& stok &"','"& jual &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateBarang()
    id = trim(Request.Form("id"))
    nama = UCase(trim(Request.Form("nama")))
    kategori = trim(Request.Form("kategori"))
    jenis = trim(Request.Form("jenis"))
    tgl = trim(Request.Form("tgl"))
    jual = trim(Request.Form("jual"))
    stok = trim(Request.Form("stok"))
    harga = replace(replace(Request.Form("harga"),".00",""),",","")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_ID = '"& id &"' AND Brg_Nama = '"& nama &"' AND KategoriId = '"&  kategori &"' AND JenisID = '"& jenis &"' AND Brg_tanggal = '"& tgl &"' AND Brg_StokYN = '"& stok &"' AND Brg_jualYN = '"& jual &"' AND Brg_Harga = "& harga &" AND Brg_AktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then
        call query("UPDATE DLK_M_Barang SET Brg_Nama = '"& nama &"', KategoriId = '"& kategori &"', JenisID = '"& jenis &"', Brg_tanggal = '"& tgl &"', Brg_StokYN = '"& stok &"', Brg_jualYN = '"& jual &"', brg_harga = "& harga &" WHERE Brg_ID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub 
%>