<!--#include file="../../init.asp"-->
<% 
        if session("PR5C") = false then
                Response.Redirect("index.asp")
        end if

        id = Request.QueryString("id")
        strapi = Request.QueryString("p")

        str = left(id,12)
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE FROM DLK_T_ReturnBarangD WHERE RBD_RBID = '"& id &"'")
        call alert("RETURN BARANG DENGAN ITEM "&id&" ", "berhasil non aktifkan", "success", strapi &".asp?id="&str) 
call footer() 
%>