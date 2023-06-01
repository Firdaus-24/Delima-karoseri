<!--#include file="../../init.asp"-->
<% 
   if session("ENG5C") = false then 
      Response.Redirect("index.asp")
   end if

   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_M_SASIS SET SASISAktifYN = 'N' WHERE SASISID = '"& id &"'")
   call alert("MASTER SASIS DENGAN ID "& LEft(id,5) &"-"& mid(id,6,4) &"-"& right(id,3)  &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>