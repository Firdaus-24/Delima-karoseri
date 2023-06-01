<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        str = left(id,13)
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE FROM DLK_T_OrJulD WHERE OJD_OJHID = '"& id &"'")
        call alert("ORDER PENJUALAN DETAIL ITEM "&id&" ", "berhasil hapus", "success","orjul_u.asp?id="&str) 
call footer() 
%>