<!--#include file="../Connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<!--#include file="../functions/func_alert.asp"-->
<!--#include file="../functions/func_query.asp"-->
<% 
   id = trim(Request.QueryString("id"))
   server.Execute("../header.asp")
   response.write "<title>Aktif</title><body>"
 %>
<!--#include file="../navbar.asp"-->
<%      
   call query("UPDATE DLK_M_WebLogin SET userAktifYN = 'N' WHERE userID = '"& id &"'")
   call alert("USER DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
   server.execute("../footer.asp")
%>