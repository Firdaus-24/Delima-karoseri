<!--#include file="../../init.asp"-->
<% 
        if session("PR2C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_OrPemH SET OPH_AktifYN = 'N' WHERE OPH_ID = '"& id &"'")
        call alert("PURCHASE ORDER DENGAN ID "&id&" ", "berhasil non aktifkan", "success","purcesDetail.asp") 
call footer() 
%>