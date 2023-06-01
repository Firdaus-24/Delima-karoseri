<!--#include file="../../init.asp"-->
<% 
   if session("FN2C") = false then
      Response.Redirect("index.asp")
   end if

   id = Request.QueryString("id")
   call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE GL_M_Bank SET Bank_aktifYN = 'N' WHERE Bank_Id = '"& id &"'")
   call alert("MASTER BANK DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>