<!--#include file="../../init.asp"-->
<% 
   if session("GL3C") = false then
      Response.Redirect("perkiraan.asp")
   end if
   id = Request.QueryString("id")
   p = Request.QueryString("p")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE GL_M_ChartAccount SET CA_aktifYN = '"& p &"', CA_UpdateTime = '"& now &"' WHERE CA_Id = '"& id &"'")
   call alert("KODE PERKIRAAN DENGAN ID "&id&" ", "berhasil update", "success","perkiraan.asp") 
call footer() 
%>