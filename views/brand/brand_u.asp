<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
   if session("ENG4B") = false then 
      Response.Redirect("index.asp")
   end if

   call header("UPDATE BRAND")

   id = trim(Request.Form("id"))
   nama = Ucase(trim(Request.Form("nnama")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT * FROM DLK_M_Brand WHERE BrandID = '"& id &"'"

   set data = data_cmd.execute

   if not data.eof then
      data_cmd.CommandText = "SELECT * FROM DLK_M_Brand WHERE BrandName = '"& nama &"'"
      set ckdata = data_cmd.execute

      if ckdata.eof then
         call query ("UPDATE DLK_M_Brand SET BrandName = '"& nama &"', BrandUpdateID = '"& session("userid") &"' WHERE BrandID = '"& id &"'")
         call alert("MATER BRAND", "berhasil di update", "success","index.asp")
      else
         call alert("MATER BRAND", "Nama sudah pernah terdaftar", "error","index.asp")
      end if 
   else
      call alert("MATER BRAND", "tidak terdaftar", "error","index.asp") 
   end if

   call footer()
%>