<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   p = trim(Request.QueryString("p"))

   if p = "N" then
      str = "berhasil non aktifkan"
   else
      str = "berhasil diaktifkan"
   end if

   call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_T_ProduksiH SET PDH_AktifYN = '"& p &"' WHERE PDH_ID = '"& id &"'")
   call alert("HEADER PRODUKSI DENGAN ID "&id&" ", str, "success","index.asp") 
call footer() 
%>