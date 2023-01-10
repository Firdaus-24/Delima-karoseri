<% 
sub tambahPerkiraan()
   kode = trim(Ucase(Request.Form("kode")))
   nama = trim(Ucase(Request.Form("nama")))
   upacount = trim(Ucase(Request.Form("upacount")))
   kelompok = trim(Ucase(Request.Form("kelompok")))
   jenis = trim(Ucase(Request.Form("jenis")))
   tipe = trim(Ucase(Request.Form("tipe")))
   golongan = trim(Ucase(Request.Form("golongan")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM GL_M_ChartAccount WHERE UPPER(CA_ID) = '"& kode &"' AND UPPER(CA_Name) = '"& nama &"' AND UPPER(CA_UpID) = '"& upacount &"' AND UPPER(CA_Jenis) = '"& jenis &"' AND UPPER(CA_Type) = '"& tipe &"' AND UPPER(CA_Golongan) = '"& golongan &"' AND UPPER(CA_Kelompok) = '"& kelompok &"' AND CA_AktifYN = 'Y'"

   set data = data_cmd.execute   

   if not data.eof then
      call alert("DATA KODE PERKIRAAN", "Sudah Terdaftar", "error","perkiraan_add.asp")
   else
      call query("INSERT INTO GL_M_ChartAccount (CA_ID,CA_Name,CA_UpID,CA_Jenis,CA_Type,CA_Golongan,CA_Kelompok,CA_AktifYN,CA_UpdateID,CA_UpdateTime) VALUES ('"& kode &"', '"& nama &"', '"& upacount &"', '"& jenis &"', '"& tipe &"', '"& golongan &"', '"& kelompok &"', 'Y', '"& session("Userid") &"', '"& Now &"')")
      call alert("KODE PERKIRAAN", "Berhasil Di tambahkan", "success","perkiraan_add.asp")
   end if
end sub
sub updatePerkiraan()
   kode = trim(Ucase(Request.Form("kode")))
   nama = trim(Ucase(Request.Form("nama")))
   upacount = trim(Ucase(Request.Form("upacount")))
   kelompok = trim(Ucase(Request.Form("kelompok")))
   jenis = trim(Ucase(Request.Form("jenis")))
   tipe = trim(Ucase(Request.Form("tipe")))
   golongan = trim(Ucase(Request.Form("golongan")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM GL_M_ChartAccount WHERE UPPER(CA_ID) = '"& kode &"' AND CA_AktifYN = 'Y'"

   set data = data_cmd.execute   

   if data.eof then
      call alert("DATA KODE PERKIRAAN", "Tidak Terdaftar", "error","perkiraan.asp")
   else
      call query("UPDATE GL_M_ChartAccount SET CA_Name = '"& nama &"', CA_UpID = '"& upacount &"', CA_Jenis = '"& jenis &"', CA_Type = '"& tipe &"',CA_Golongan = '"& golongan &"', CA_Kelompok = '"& kelompok &"', CA_UpdateID = '"& session("Userid") &"', CA_UpdateTime = '"& Now &"' WHERE CA_ID = '"& kode &"'")
      call alert("KODE PERKIRAAN", "Berhasil Di update", "success","perkiraan.asp")
   end if
end sub
%>