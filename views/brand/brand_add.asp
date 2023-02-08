<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
   if session("ENG4A") = false then 
      Response.Redirect("index.asp")
   end if

   call header("TAMBAH BRAND")

   nama = Ucase(trim(Request.Form("nnama")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM DLK_M_Brand WHERE UPPER(BrandName) = '"& nama &"'"

   set data = data_cmd.execute

   if data.eof then
      call query ("exec sp_addDLK_M_Brand '"& nama &"', '"& session("userid") &"'")
      call alert("MATER BRAND", "berhasil di tambahkan", "success","index.asp") 
   else
      call alert("MATER BRAND", "sudah terdaftar", "error","index.asp") 
   end if

   call footer()
%>