<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        p = trim(Request.QueryString("p"))

        strid = left(id,12)

        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_M_ProductD WHERE PDDPDID = '"& id &"'")
        call alert("BARANG DETAIL ITEM "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>