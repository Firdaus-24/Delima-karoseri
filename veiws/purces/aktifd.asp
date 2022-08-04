<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        nama = Request.QueryString("nama")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_OrPemD SET OPD_AktifYN = 'N' WHERE OPD_OPHID = '"& id &"' AND OPD_Item = '"& nama &"'")
        call alert("PURCHASE ORDER DETAIL ITEM "&nama&" ", "berhasil non aktifkan", "success","purce_d.asp?id="&id) 
call footer() 
%>