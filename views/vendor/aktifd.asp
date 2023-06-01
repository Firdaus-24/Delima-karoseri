<!--#include file="../../init.asp"-->
<% 
        if session("M8C") = false then  
                Response.Redirect("index.asp")
        end if

        id = Request.QueryString("id")
        strid = left(id,9)
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("delete FROM DLK_T_Vendord WHERE dven_VenId = '"& id &"'")
        call alert("DETAIL VENDOR DENGAN ID "&id&" ", "berhasil hapus", "success","vn_u.asp?id="&strid) 
call footer() 
%>