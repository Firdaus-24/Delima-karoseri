<!--#include file="../../functions/func_uploadjpg.asp"-->
<%
  if session("MQ4E") = false then
    Response.Redirect("./")
  end if
  
  dim id, responback
  id = trim(Request.QueryString("id"))
  responback = Request.ServerVariables("HTTP_REFERER") 'kembali ke halaman sebelumnya
  ' cek nomor id
  

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
  diagnostics = TestEnvironment()
  if diagnostics<>"" then
    response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
    response.write diagnostics
    response.write "<p>After you correct this problem, reload the page."
    response.write "</div>"
  else
    OutputForm()
  end if
else
  call query("UPDATE DLK_T_IncRepairD SET IRD_Img = '"& id &"' WHERE IRD_IRHID = '"& id &"'")

  OutputForm()
  response.write SaveFiles()
end if
%>