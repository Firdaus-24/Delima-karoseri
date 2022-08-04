<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Kategori SET KategoriaktifYN = 'N' WHERE KategoriId = '"& id &"'")
        call alert("KATEGORI DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>