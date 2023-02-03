<!--#include file="../../init.asp"-->
<% 
   if session("GL2B") = false then
      Response.Redirect("catitem.asp")
   end if

   id = trim(ucase(Request.Form("id")))
   lname = trim(ucase(Request.Form("lname")))
   name = trim(ucase(Request.Form("name")))

   call header("Tambah Kategori Item") 

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM GL_M_CategoryItem WHERE UPPER(Cat_Name) = '"& name &"'"

   set data = data_cmd.execute

   if not data.eof then
      call alert("KATEGORI ITEM", "Sudah Terdaftar", "error","catitem.asp")
   else
      call query("UPDATE GL_M_CategoryItem SET Cat_Name = '"& name &"', Cat_updateID = '"& session("Userid") &"', Cat_updateTime ='"& now &"' WHERE Cat_ID = '"& id &"' ")
      call alert("KATEGORI ITEM", "Berhasil Di update", "success","catitem.asp")
   end if
%>
<!--#include file="../../navbar.asp"-->
<% call footer() %>