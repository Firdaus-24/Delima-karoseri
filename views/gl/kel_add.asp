<!--#include file="../../init.asp"-->
<% call header("FORM KELOMPOK") %>
<!--#include file="../../navbar.asp"-->   
<% 
   kode = trim(Ucase(Request.Form("kode")))
   name = trim(Ucase(Request.Form("name")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM GL_M_Kelompok WHERE UPPER(K_ID) = '"& kode &"' OR UPPER(K_Name) = '"& name &"' AND K_AktifYN = 'Y'"

   set data = data_cmd.execute   

   if not data.eof then
      call alert("FORM KELOMPOK", "Sudah Terdaftar", "error","kelompok.asp")
   else
      call query("INSERT INTO GL_M_Kelompok (K_ID,K_Name,K_updateID,K_UpdateTime,K_AktifYN) VALUES ('"& kode &"', '"& name &"', '"& session("Userid") &"', '"& Now &"', 'Y')")
      call alert("FORM KELOMPOK", "Berhasil Di tambahkan", "success","kelompok.asp")
   end if

call footer()
%>