<% 
  sub karyawanAdd()
    'koneksi data
    set tambah_cmd = server.createObject("ADODB.Command")
    tambah_cmd.ActiveConnection = MM_delima_string

    nama = trim(Ucase(request.form("nama")))
    bpjskes = trim(request.form("bpjskes")) ' kesehatan
    bpjs = trim(request.form("bpjs")) 'keternaga kerjaan
    alamat = trim(request.form("alamat"))
    kelurahan = trim(request.form("kelurahan"))
    tlp1 = trim(request.form("tlp1"))
    tlp2 = trim(request.form("tlp2"))
    pos = trim(request.form("pos"))
    kota = trim(request.form("kota"))
    tmpt = trim(request.form("tempat"))
    tglL = trim(Cdate(request.form("tglL")))
    email = trim(request.form("email"))
    agama = trim(request.form("agama"))
    cabang = trim(request.form("cabang"))
    jkelamin = trim(request.form("jkelamin"))
    ssosial = trim(request.form("ssosial"))
    divisi = trim(request.form("divisi"))
    janak = trim(request.form("janak"))
    tanggungan = trim(request.form("tanggungan"))
    jabatan = trim(request.form("jabatan"))
    pendidikan = trim(request.form("pendidikan"))
    spegawai = trim(request.form("spegawai"))
    jenjang = trim(request.form("jenjang"))
    saudara = trim(request.form("saudara"))
    anakke = trim(request.form("anakke"))
    departement = trim(request.form("departement"))
    bank = trim(request.form("bankID"))
    norek = trim(request.form("norek"))
    jcuti = trim(request.form("jcuti"))
    kesehatan = trim(request.form("kesehatan"))
    tenagakerja = trim(request.form("tenagakerja"))
    ktp = trim(request.form("ktp"))
    npwp = trim(request.form("npwp"))
    tglmasuk = trim(Cdate(request.form("tglmasuk")))
    tglkeluar = trim(request.form("tglkeluar"))
    nsim = trim(request.form("nsim"))
    vaksin = trim(request.form("vaksin"))
    tglagaji = trim(request.form("tglagaji"))
    tglegaji = trim(request.form("tglegaji"))
    noJp = "0" 'ini ga tau apa datanya, nnti tanya ke HRD aja
    berlakusim = trim(request.form("berlakuSIM"))
    jsim = trim(request.form("jsim"))
    atasan1 = trim(request.form("atasan1"))
    atasan2 = trim(request.form("atasan2"))
    goldarah = trim(request.form("goldarah"))

    tambah_cmd.commandText = "SELECT * FROM HRD_M_Karyawan WHERE Kry_Nama = '"& nama &"' and Kry_Addr1 = '"& alamat &"' And Kry_Addr2 = '"& kelurahan &"' And Kry_kota = '"& kota &"' AND Kry_TglMasuk = '"& tglmasuk &"' AND Kry_Telp1 = '"& tlp1 &"' AND Kry_Telp2 = '"& tlp2 &"' AND Kry_TglLahir = '"& tglL &"' AND Kry_TmpLahir = '"& tmpt &"' AND Kry_AgamaID = '"& agama &"' AND Kry_JabCode = '"& jabatan &"' AND Kry_DivID = '"& divisi &"'"
    set tambah = tambah_cmd.execute

    if tambah.eof then
      
      tambah_cmd.commandText = "exec sp_AddHrd_M_Karyawan '"& divisi &"','"& departement &"','"& cabang &"','"& jabatan &"',"& jenjang &",'"& nama &"','"& alamat &"','"& kelurahan &"','"& kota &"','"& pos &"','"& tlp1 &"','"& tlp2 &"','"& email &"','"& jkelamin &"','"& tmpt &"','"& tglL &"',"& ssosial &","& janak &","& saudara &","& anakke &","& agama &","& pendidikan &",'"& ktp &"', '"& nsim &"',"& jsim &",'"& berlakusim &"',0,"& tanggungan &","& jcuti &",'"& tglmasuk &"','','"& tglagaji &"','', 0,'',"& bank &",'"& norek &"','',"& spegawai &",0,'','','','"& session("userid") &"','"& npwp &"','','"& bpjs &"','"&tenagakerja &"','"& bpjskes &"','"& kesehatan &"','"& atasan1 &"','"& atasan2 &"','"& goldarah &"','"& vaksin &"'"
        ' Response.Write tambah_cmd.commandText
      set result = tambah_cmd.execute
      data = result("ID")
       
      call alert("DATA KARYAWAN BARU DENGAN NIP"&data, "berhasil di tambahkan", "success","kary_add.asp")
    else 
      call alert("DATA KARYAWAN ", "sudah terdaftar", "error","kary_add.asp")
    end if
  end sub
  sub karyawanupdate()
    'koneksi data
    set tambah_cmd = server.createObject("ADODB.Command")
    tambah_cmd.ActiveConnection = MM_delima_string

    nip = trim(Ucase(request.form("nip")))
    nama = trim(Ucase(request.form("nama")))
    bpjskes = trim(request.form("bpjskes")) ' kesehatan
    bpjs = trim(request.form("bpjs")) 'keternaga kerjaan
    alamat = trim(request.form("alamat"))
    kelurahan = trim(request.form("kelurahan"))
    tlp1 = trim(request.form("tlp1"))
    tlp2 = trim(request.form("tlp2"))
    pos = trim(request.form("pos"))
    kota = trim(request.form("kota"))
    tmpt = trim(request.form("tempat"))
    tglL = trim(Cdate(request.form("tglL")))
    email = trim(request.form("email"))
    agama = trim(request.form("agama"))
    cabang = trim(request.form("cabang"))
    jkelamin = trim(request.form("jkelamin"))
    ssosial = trim(request.form("ssosial"))
    divisi = trim(request.form("divisi"))
    janak = trim(request.form("janak"))
    tanggungan = trim(request.form("tanggungan"))
    jabatan = trim(request.form("jabatan"))
    pendidikan = trim(request.form("pendidikan"))
    spegawai = trim(request.form("spegawai"))
    jenjang = trim(request.form("jenjang"))
    saudara = trim(request.form("saudara"))
    anakke = trim(request.form("anakke"))
    departement = trim(request.form("departement"))
    bank = trim(request.form("bankID"))
    norek = trim(request.form("norek"))
    jcuti = trim(request.form("jcuti"))
    kesehatan = trim(request.form("kesehatan"))
    tenagakerja = trim(request.form("tenagakerja"))
    ktp = trim(request.form("ktp"))
    npwp = trim(request.form("npwp"))
    tglmasuk = trim(Cdate(request.form("tglmasuk")))
    tglkeluar = trim(request.form("tglkeluar"))
    nsim = trim(request.form("nsim"))
    vaksin = trim(request.form("vaksin"))
    tglagaji = trim(request.form("tglagaji"))
    tglegaji = trim(request.form("tglegaji"))
    noJp = "0" 'ini ga tau apa datanya, nnti tanya ke HRD aja
    berlakusim = trim(request.form("berlakuSIM"))
    jsim = trim(request.form("jsim"))
    atasan1 = trim(request.form("atasan1"))
    atasan2 = trim(request.form("atasan2"))
    goldarah = trim(request.form("goldarah"))

    tambah_cmd.commandText = "SELECT * FROM HRD_M_Karyawan WHERE Kry_Nip = '"& nip &"'"
    set tambah = tambah_cmd.execute

    if not tambah.eof then
    ' "     
    '   ,[Kry_JmlHariKerja]
    '   ,[Kry_PIN]
    '   ,[Kry_CurrentStt]
    '   ,[Kry_MasaPercobaan]
    '   ,[Kry_TglPercobaanStart]
    '   ,[Kry_TglPercobaanEnd]
    '   ,[Kry_AktifYN]
    '   ,[Kry_UpdateTime]
    '   ,[Kry_password]
    '   ,[Kry_AndroidReadyYN]
    '   "
      
      call query("UPDATE Hrd_M_Karyawan SET Kry_DivID ='"& divisi &"',Kry_DepID ='"& departement &"',Kry_AgenID ='"& cabang &"', Kry_JabCOde ='"& jabatan &"', Kry_JJID ="& jenjang &", Kry_Nama ='"& nama &"', Kry_addr1 ='"& alamat &"', Kry_addr2 ='"& kelurahan &"', Kry_Kota ='"& kota &"', Kry_Kdpos ='"& pos &"', Kry_Telp1 ='"& tlp1 &"', Kry_Telp2 ='"& tlp2 &"', Kry_Email ='"& email &"', Kry_Sex ='"& jkelamin &"', Kry_TmpLahir ='"& tmpt &"', Kry_TglLahir ='"& tglL &"', Kry_SttSosial = "& ssosial &", Kry_JmlAnak ="& janak &", Kry_JmlSaudara = "& saudara &", Kry_AnakKe = "& anakke &", Kry_AgamaID ="& agama &", Kry_JDdkID = "& pendidikan &", Kry_NoID ='"& ktp &"', Kry_NoSIM = '"& nsim &"', Kry_JnsSIM = "& jsim &", Kry_SIMValidDate = '"& berlakusim &"', Kry_JmlTanggungan = "& tanggungan &",Kry_JmlCuti = "& jcuti &", Kry_TglMasuk ='"& tglmasuk &"',Kry_TglKeluar = '"& tglkeluar &"',Kry_TglStartGaji = '"& tglagaji &"',Kry_TglEndGaji = '"& tglegaji &"', Kry_BankID = "& bank &", Kry_NoRekening ='"& norek &"',Kry_SttKerja ="& spegawai &",Kry_UpdateID = '"& session("userid") &"',Kry_NPWP = '"& npwp &"',Kry_BPJSKetYN ='"& bpjs &"', Kry_NoBPJSKet = '"&tenagakerja &"',Kry_BPJSKesYN = '"& bpjskes &"',Kry_NoBPJSKes = '"& kesehatan &"', Kry_AtasanNip1 ='"& atasan1 &"', Kry_AtasanNip2 = '"& atasan2 &"', Kry_golDarah = '"& goldarah &"',Kry_JenisVaksin = '"& vaksin &"' WHERE Kry_Nip = '"& nip &"'")
    
       
      call alert("DATA KARYAWAN DENGAN NIP "&nip, "berhasil di update", "success","kry_u.asp?nip="&nip)
    else 
      call alert("DATA KARYAWAN DENGAN NIP "&nip, "tidak terdaftar", "error","kry_u.asp?nip="&nip)
    end if
  end sub
%>