<!--#include file="../../init.asp"-->
<% 
        if session("HR3C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE HRD_M_Departement SET DepaktifYN = 'N' WHERE DepId = '"& id &"'")
        call alert("KEBUTUHAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>