<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        nama = Request.QueryString("nama")
        str = split(id , ",")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_OrJulD SET OJD_AktifYN = 'N' WHERE OJD_OJHID = '"& trim(str(0)) &"' AND OJD_Item = '"& trim(str(1)) &"' AND OJD_QtySatuan = '"& trim(str(2)) &"' AND OJD_JenisSat = '"& trim(str(3)) &"' AND OJD_Harga = "& trim(str(4)) &" AND OJD_Disc1 = "& trim(str(5)) &" AND OJD_Disc2 = "& trim(str(6)) &"")
        call alert("ORDER PENJUALAN DETAIL ITEM "&trim(str(1))&" ", "berhasil non aktifkan", "success","orjul_d.asp?id="&trim(str(0))) 
call footer() 
%>