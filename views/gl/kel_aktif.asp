<!--#include file="../../init.asp"-->
<% 
   if session("GL3C") = false then
      Response.Redirect("../index.asp")
   end if
   id = trim(Ucase(Request.QueryString("id")))
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE GL_M_Kelompok SET K_AktifYN = 'N' WHERE K_ID = '"& id &"'")
   call alert("KELOMPOK PERKIRAAN DENGAN ID "&id&" ", "berhasil non aktifkan", "success","kelompok.asp") 
call footer() 
%>