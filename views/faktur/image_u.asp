<!--#include file="../../init.asp"-->
<% 
   call header("image")
   id = trim(Request.QueryString("id"))

   call query("UPDATE DLK_T_InvPemH SET IPH_Image = '"& id &"', IPH_TukarYN = 'Y' WHERE IPH_ID = '"& id &"'")

   call alert("DOCUMENT", "berhasil diupload", "success","index.asp") 

   call footer()
%>