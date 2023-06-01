<!--#include file="url.asp"-->
<% 
   ' Session.Timeout=1
   ' Server.ScriptTimeout=5
   if session("username") = "" then
      Response.Redirect(url&"logout.asp")
   end if
%>
<!--#include file="Connections/cargo.asp"-->
<!--#include file="functions/md5.asp"-->
<!--#include file="functions/func_query.asp"-->
<!--#include file="functions/func_alert.asp"-->
<!--#include file="functions/func_getDataByID.asp"-->
<!--#include file="functions/func_template.asp"-->