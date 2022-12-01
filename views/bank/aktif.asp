<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE GL_M_Bank SET Bank_aktifYN = 'N' WHERE Bank_Id = '"& id &"'")
   call alert("MASTER BANK DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>