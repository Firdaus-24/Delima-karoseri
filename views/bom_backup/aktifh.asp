<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_T_BomH SET BMH_AktifYN = 'N' WHERE BMH_ID = '"& id &"'")
   call alert("FORM B.O.M DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>