<!--#include file="../../init.asp"-->
<% 
   if session("GL2C") = false then
      Response.Redirect("catitem.asp")
   end if 
%>