<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   p = Request.QueryString("p")
   if p = "Y" then
      str = "berhasil non aktifkan"
   else
      str = "berhasil diaktifkan"
   end if

   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_M_Kebutuhan SET K_aktifYN = '"& p &"', K_updateID = '"& session("userid") &"', K_Updatetime = '"& now &"' WHERE K_Id = '"& id &"'")
   call alert("KEBUTUHAN DENGAN ID "&id&" ", str, "success","index.asp") 
call footer() 
%>