<!--#include file="../../init.asp"-->
<% 
   if session("ENG3C") = false then 
      Response.Redirect("index.asp")
   end if 

   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_M_Class SET ClassAktifYN = 'N' WHERE ClassID = '"& id &"'")
   call alert("MASTER CLASS DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>