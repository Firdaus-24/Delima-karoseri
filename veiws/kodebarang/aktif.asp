<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_KodeBarang SET Kode_AktifYN = 'N' WHERE Kode_ID = '"& id &"'")
        call alert("KODE BARANG", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>