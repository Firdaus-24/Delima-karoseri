<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        strid = trim(left(id,10))
        url = trim(Request.QueryString("p"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_AsetD WHERE AD_asetId = '"& id &"'")
        call alert("ASET BARANG DENGAN ID "&id&" ", "berhasil hapus", "success", url&".asp?id="&strid) 
call footer() 
%>