<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        nama = Request.QueryString("nama")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_InvPemD SET IPD_AktifYN = 'N' WHERE IPD_IPHID = '"& id &"' AND IPD_Item = '"& nama &"'")
        call alert("FAKTUR BARANG DETAIL ITEM "&nama&" ", "berhasil non aktifkan", "success","detailFaktur.asp?id="&id) 
call footer() 
%>