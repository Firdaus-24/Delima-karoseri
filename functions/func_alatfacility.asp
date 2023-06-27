<%
sub tambah()
  agen = trim(Request.Form("agen"))
  nama = UCase(trim(Request.Form("nama")))
  kategori = trim(Request.Form("kategori"))
  jenis = trim(Request.Form("jenis"))
  tgl = trim(Request.Form("tgl"))
  minstok = trim(Request.Form("minstok"))
  typebrg = trim(Request.Form("typebrg"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_Nama = '"& nama &"' AND KategoriId = '"&  kategori &"' AND JenisID = '"& jenis &"' AND Brg_AktifYN = 'Y'"
  set data = data_cmd.execute

  if data.eof then
    call query("exec sp_AddDLK_M_Barang '"& agen &"','"& nama &"', '"& tgl &"', '"& jenis &"','"& kategori &"','Y','N','', "& minstok &", '"& typebrg &"'")
    call alert("MATER ALAT & FACILITY", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
  else
    call alert("MATER ALAT & FACILITY", "sudah terdaftar", "error",Request.ServerVariables("HTTP_REFERER")) 
  end if
end sub
sub update()
    id = trim(Request.Form("id"))
    nama = UCase(trim(Request.Form("nama")))
    kategori = trim(Request.Form("kategori"))
    jenis = trim(Request.Form("jenis"))
    minstok = trim(Request.Form("minstok"))
    typebrg = trim(Request.Form("typebrg"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_ID = '"& id &"' AND Brg_AktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
      call query("UPDATE DLK_M_Barang SET Brg_Nama = '"& nama &"', KategoriId = '"& kategori &"', JenisID = '"& jenis &"', Brg_minstok = "& minstok &", Brg_Type = '"& typebrg &"' WHERE Brg_ID = '"& id &"'")
      call alert("MATER ALAT & FACILITY", "berhasil di update", "success",Request.ServerVariables("HTTP_REFERER")) 
    else
      call alert("MATER ALAT & FACILITY", "sudah terdaftar", "error",Request.ServerVariables("HTTP_REFERER")) 
    end if
end sub 
%>