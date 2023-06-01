<!--#include file="../../init.asp"-->
<% 
   if session("GL2A") = false then
      Response.Redirect("catitem.asp")
   end if
   name = trim(ucase(Request.Form("name")))

   call header("Tambah Kategori Item") 

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM GL_M_CategoryItem WHERE UPPER(Cat_Name) = '"& name &"'"

   set data = data_cmd.execute

   if not data.eof then
      call alert("KATEGORI ITEM", "Sudah Terdaftar", "error","catitem.asp")
   else
      call query("exec sp_AddGL_M_CategoryItem '"& name &"', '"& session("Userid") &"', '"& now &"' ")
      call alert("KATEGORI ITEM", "Berhasil Di tambahkan", "success","catitem.asp")
   end if
%>
<!--#include file="../../navbar.asp"-->
<% call footer() %>