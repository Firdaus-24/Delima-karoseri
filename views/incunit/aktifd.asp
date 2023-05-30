<!--#include file="../../init.asp"-->
<% 
  if session("MQ4C") = false then 
    Response.Redirect("./")
  end if
  dim id 
  dim fs
  id = trim(Request.QueryString("id"))

  Set fs=Server.CreateObject("Scripting.FileSystemObject")
  if fs.FileExists(pathDoc&"\views\incunit\img\"&id&".jpg") then
    fs.DeleteFile(pathDoc&"\views\incunit\img\"&id&".jpg")
  end if
  set fs=nothing
 
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE FROM DLK_T_IncRepairD WHERE IRD_IRHID = '"& id &"'")
  call alert("KERUSAKAN DENGAN NO : "& id &"", "berhasil dihapus", "success", Request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>