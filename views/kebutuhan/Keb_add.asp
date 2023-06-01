<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
   if session("M10A") = false then 
      Response.Redirect("index.asp")
    end if

   call header("Tambah Kebutuhan ")
   nama = ucase(trim(Request.Form("nama")))
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Kebutuhan WHERE UPPER(K_Name) = '"& nama &"'"

   set data = data_cmd.execute

   if data.eof then
      call query("INSERT INTO DLK_M_Kebutuhan (K_Name,K_updateID,K_UpdateTIme,K_AktifYN) VALUES ('"& nama &"','"& session("UserID") &"','"& now &"','Y')")
      call alert("MASTER KEBUTUHAN", "berhasil di tambahkan", "success","index.asp") 
   else
      call alert("MASTER KEBUTUHAN", "sudah terdaftar", "error","index.asp") 
   end if   
   call footer()
%>