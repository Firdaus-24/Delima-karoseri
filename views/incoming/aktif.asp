<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_T_MaterialReceiptH SET MR_AktifYN = 'N' WHERE MR_ID = '"& id &"'")
   call alert("MATERIAL RECEIPT DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>