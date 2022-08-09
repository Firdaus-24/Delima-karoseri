<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        nama = Request.QueryString("nama")
        str = split(id , ",")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_OrPemD SET OPD_AktifYN = 'N' WHERE OPD_OPHID = '"& trim(str(0)) &"' AND OPD_Item = '"& trim(str(1)) &"' AND OPD_QtySatuan = '"& trim(str(2)) &"' AND OPD_JenisSat = '"& trim(str(3)) &"' AND OPD_Harga = "& trim(str(4)) &" AND OPD_Disc1 = "& trim(str(5)) &" AND OPD_Disc2 = "& trim(str(6)) &"")
        call alert("PURCHASE ORDER DETAIL ITEM "&trim(str(1))&" ", "berhasil non aktifkan", "success","purce_d.asp?id="&trim(str(0))) 
call footer() 
%>