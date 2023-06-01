<% 
sub tambahSasis()
   idclass = trim(Request.Form("idclass"))
   brand = trim(Request.Form("brand"))
   ttype = Ucase(trim(Request.Form("type")))
   dlong = trim(Request.Form("long"))
   height = trim(Request.Form("height"))
   widht = trim(Request.Form("widht"))
   keterangan = trim(Request.Form("keterangan"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Sasis WHERE SasisCLassID = '"& idclass &"' AND SasisBrandID = '"& brand &"' AND SasisType = '"& ttype &"' AND SasisL = '"& dlong &"' AND SasisH = '"& height &"' AND SasisW = '"& widht &"'"

   set data= data_cmd.execute

   if data.eof then
      call query("exec sp_AddDLK_M_Sasis '"& idclass &"', '"& brand &"','"& ttype &"','"& dlong &"', '"& widht &"', '"& height &"', '"& keterangan &"', '', '', '"& session("userID") &"'")
      call alert("MATER SASIS", "berhasil di tambahkan", "success","sasis_add.asp") 
   else
      call alert("MATER SASIS", "sudah terdaftar!!", "error","sasis_add.asp") 
      value = 2
   end if
end sub
sub updateSasis()
   id = trim(Request.Form("id"))
   idclass = trim(Request.Form("idclass"))
   brand = trim(Request.Form("brand"))
   ttype = Ucase(trim(Request.Form("type")))
   dlong = trim(Request.Form("long"))
   height = trim(Request.Form("height"))
   widht = trim(Request.Form("widht"))
   keterangan = trim(Request.Form("keterangan"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Sasis WHERE SasisID = '"& id &"' AND SasisAktifYN = 'Y'"

   set data= data_cmd.execute

   if not data.eof then
      call query("UPDATE DLK_M_Sasis SET SasisClassID = '"& idclass &"', SasisBrandID = '"& brand &"', SasisType = '"& ttype &"', SasisL = '"& dlong &"', SasisW = '"& widht &"', SasisH = '"& height &"', SasisKeterangan ='"& keterangan &"', SasisUpdateID = '"& session("userID") &"', SasisUpdateTIme = '"& now &"' WHERE SasisID = '"& id &"'")
      call alert("MATER SASIS", "berhasil di update", "success","index.asp") 
   else
      call alert("MATER SASIS", "tidak terdaftar!!", "error","index.asp") 
      value = 2
   end if
end sub
%>