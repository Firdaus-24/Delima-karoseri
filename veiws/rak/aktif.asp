<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Rak SET Rak_AktifYN = 'N' WHERE Rak_ID = '"& id &"'")
        call alert("RAK BARANG ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>