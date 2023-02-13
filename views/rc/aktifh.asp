<!--#include file="../../init.asp"-->
<% 
   if session("PP1C") = false then
      Response.Redirect("index.asp")
   end if
   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_T_RCProdH SET RC_AktifYN = 'N' WHERE RC_ID = '"& id &"'")
   call alert("TRANSAKSI DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>