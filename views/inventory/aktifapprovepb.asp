<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        strid = split(id,",")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_D SET MemoAktifYN = 'N' WHERE MemoId = '"& trim(strid(0)) &"' AND memoitem = '"& trim(strid(1)) &"' AND memoSpect = '"& trim(strid(2)) &"' AND memoQtty = '"& trim(strid(3)) &"' AND memoSatuan = '"& trim(strid(4)) &"' AND memoHarga = '"& trim(strid(5)) &"' AND memoKeterangan = '"& trim(strid(6)) &"'")
        call alert("BARANG DENGAN ID "&trim(strid(0))&" ", "berhasil non aktifkan", "success","dapprovepb.asp?id="&trim(strid(0))) 
call footer() 
%>