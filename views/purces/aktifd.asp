<!--#include file="../../init.asp"-->
<% 
        if session("PR2C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        str = left(id,13)
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE FROM DLK_T_OrPemD WHERE OPD_OPHID = '"& id &"'")
        call alert("PURCHASE ORDER DETAIL ITEM "&id&" ", "berhasil non aktifkan", "success","purc_u.asp?id="&str) 
call footer() 
%>