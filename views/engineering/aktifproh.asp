<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")

        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_ProductH SET PDAktifYN = 'N' WHERE PDID = '"& id &"'")
        call alert("MASTER PRODUKSI "&id&" ", "berhasil nonaktifkan", "success","produksi.asp") 
call footer() 
%>