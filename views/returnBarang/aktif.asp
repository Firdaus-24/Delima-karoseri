<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
      call query("UPDATE DLK_T_ReturnBarangH SET RB_AktifYN = 'N' WHERE RB_ID = '"& id &"'")
   call alert("TRANSAKSI RETURN BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>