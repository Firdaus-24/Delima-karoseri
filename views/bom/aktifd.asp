<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   strurl = trim(Request.QueryString("p"))
   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("DELETE DLK_T_BomD WHERE BMD_ID = '"& id &"'")
   call alert("FORM B.O.M DENGAN ID "& id &"", "berhasil non aktifkan", "success", strurl &".asp?id="& left(id,13)) 
call footer() 
%>