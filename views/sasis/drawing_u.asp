<!--#include file="../../init.asp"-->
<% 
   call header("image")
   id = trim(Request.QueryString("id"))
   db = trim(Request.QueryString("db"))

   if db = "SasisDrawing" then
      strquery = "UPDATE DLK_M_Sasis SET SasisDrawing = '"& id &"' where SasisID = '"& id &"'"
   elseIf db = "SasisSKRB" then
      strquery = "UPDATE DLK_M_Sasis SET SasisSKRB = '"& id &"' where SasisID = '"& id &"'"
   else 
      Response.Redirect("index.asp")
   end if

   call query(strquery)

   call alert("DOCUMENT STANDART PRODUCT", "berhasil diupload", "success","index.asp") 

   call footer()
%>