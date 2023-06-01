<!--#include file="../../init.asp"-->
<% 
        if session("INV4C") = false then
                Response.Redirect("index.asp")
        end if
        id = trim(Request.QueryString("id"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_MaterialOutH SET MO_AktifYN = 'N' WHERE MO_ID = '"& id &"'")
        call alert("FAKTUR HEADER ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>