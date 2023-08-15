<!--#include file="../../init.asp"-->
<%
  if session("PR3F") = false then
    Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
  end if

  id = trim(Request.QueryString("id"))  

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_MEMO_H WHERE memoid = '"& id &"'"
  set data = data_cmd.execute

  call header("Approve purchase")
%>
<!--#include file="../../navbar.asp"-->
<%      
  if not data.eof then
    call query("UPDATE DLK_T_Memo_H SET memopurchaseYN = 'Y' WHERE memoid = '"& id &"'")
    call alert("MEMO DENGAN NO : "& id &"", "berhasil berhasil diteruskan ke finance", "success",Request.ServerVariables("HTTP_REFERER")) 
  else
    call alert("MEMO DENGAN NO : "& id &"", "tidak terdaftar", "error",Request.ServerVariables("HTTP_REFERER")) 
  end if
call footer() 
%>