<!--#include file="../../init.asp"-->
<% 
        if session("INV4C") = false then
                Response.Redirect("../index.asp")
        end if

        id = Request.QueryString("id")
        brg = Request.QueryString("brg")
        tgl = Request.QueryString("tgl")
        p = Request.QueryString("p")

        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_MaterialOutD WHERE MO_ID = '"& id &"' AND MO_Item = '"& brg &"' AND MO_Date = '"& tgl &"'")
        call alert("DETAIL BARANG "&id&" ", "berhasil hapus", "success", p&".asp?id="&id) 
call footer() 
%>