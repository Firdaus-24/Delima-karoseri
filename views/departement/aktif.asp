<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Departement SET DepaktifYN = 'N' WHERE DepId = '"& id &"'")
        call alert("KEBUTUHAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>