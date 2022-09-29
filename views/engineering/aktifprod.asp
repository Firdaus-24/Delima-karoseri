<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")

        strid = left(id,12)

        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_ProductD WHERE PDDPDID = '"& id &"'")
        call alert("BARANG DETAIL ITEM "&id&" ", "berhasil hapus", "success","product_u.asp?id="&strid) 
call footer() 
%>