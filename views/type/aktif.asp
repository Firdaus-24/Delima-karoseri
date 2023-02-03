<!--#include file="../../init.asp"-->
<% 
        if session("M7C") = false then 
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_TypeBarang SET T_aktifYN = 'N' WHERE T_Id = '"& id &"'")
        call alert("TypeBarang ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>