<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        p = Request.QueryString("p")
        strid = left(id,13)

        if p = "" then
                p = "detailFaktur"
        end if
        
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_InvJulD WHERE IJD_IJHID = '"& id &"'")
        call alert("FAKTUR BARANG DETAIL ITEM "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>