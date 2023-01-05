<!--#include file="../../init.asp"-->
<% call header("FORM KELOMPOK") %>
<!--#include file="../../navbar.asp"-->   
<% 
   lkode = trim(Ucase(Request.Form("lkode")))
   lname = trim(Ucase(Request.Form("lname")))
   kode = trim(Ucase(Request.Form("kode")))
   name = trim(Ucase(Request.Form("name")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM GL_M_Kelompok WHERE K_AktifYN = 'Y' AND UPPER(K_ID) = '"& kode &"' AND UPPER(K_Name) = '"& name &"'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute   

   if not data.eof then
      call alert("FORM KELOMPOK", "Sudah Terdaftar", "error","kelompok.asp")
   else
      call query("UPDATE GL_M_Kelompok SET K_ID = '"& kode &"', K_Name = '"& name &"', K_updateID = '"& session("Userid") &"', K_UpdateTime = '"& Now &"' WHERE K_Id = '"& lkode &"' AND K_Name = '"& lname &"'")
      call alert("FORM KELOMPOK", "Berhasil Di Update", "success","kelompok.asp")
   end if

call footer()
%>