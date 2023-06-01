<!--#include file="../../init.asp"-->
<% 
   if session("ENG4C") = false then 
      Response.Redirect("index.asp")
   end if

   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_M_BRAND SET BRANDAktifYN = 'N' WHERE BRANDID = '"& id &"'")
   call alert("MASTER BRAND DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>