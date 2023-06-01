<!--#include file="Connections/cargo.asp"-->
<!--#include file="url.asp"-->
<!--#include file="functions/md5.asp"-->
<!--#include file="functions/func_query.asp"-->
<!--#include file="functions/func_alert.asp"-->
<!--#include file="functions/func_template.asp"-->
<% 
   call header("Login")

   username = Ucase(trim(Request.Form("username")))
   agen = trim(Request.Form("agen"))
   password = md5(trim(Request.Form("password")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT DLK_M_WebLogin.*, agenName FROM DLK_M_WebLogin INNER JOIN GLB_M_Agen ON DLK_M_WebLogin.serverID = GLB_M_Agen.AgenID WHERE UPPER(username) = '"& username &"' AND serverID = '"& agen &"' AND Password = '"& password &"'"

   set ckuser = data_cmd.execute

   if not ckuser.eof then
      data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& username &"') AND (ServerID = '"& agen &"')"
      ' response.write data_cmd.commandText
      set rights = data_cmd.execute
      
      do while not rights.eof
         session(rights("appIDRights")) = true
      rights.moveNext
      loop

      Session("username")= username
      session("cabang") = ckuser("agenName")
      session("server-id") = agen
      session("Userid") = ckuser("userID")
      
         if session("username") = "ADMINISTRATOR" then
            response.Redirect("\akses")
         else
            Response.redirect ("\views")
         end if
   else
      call alert("ERROR", "data yang anda masukan salah! atau tidak terdaftar", "error","login.asp") 
   end if

   call footer()
%>