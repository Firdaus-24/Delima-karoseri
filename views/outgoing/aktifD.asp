<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        brg = Request.QueryString("brg")
        p = Request.QueryString("p")

        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_MaterialOutD WHERE MO_ID = '"& id &"' AND MO_Item = '"& brg &"'")
        call alert("DETAIL BARANG "&id&" ", "berhasil hapus", "success", p&".asp?id="&id) 
call footer() 
%>