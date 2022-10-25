<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_AsetH SET asetaktifYN = 'N' WHERE asetId = '"& id &"'")
        call alert("ASET BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>