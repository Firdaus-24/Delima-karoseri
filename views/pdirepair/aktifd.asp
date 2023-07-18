<!--#include file="../../init.asp"-->
<% 
  if session("MQ5C") = false then 
    Response.Redirect("./")
  end if
  dim id 
  dim fs
  id = trim(Request.QueryString("id"))

  Set fs=Server.CreateObject("Scripting.FileSystemObject")
  if fs.FileExists(pathDoc&left(id,14)&"\"&id&".jpg") then
    fs.DeleteFile(pathDoc&left(id,14)&"\"&id&".jpg")
  end if
  set fs=nothing
 
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE FROM DLK_T_PDIRepairD WHERE PDIR_ID = '"& id &"'")
  call alert("PDI REPAIR DETAIL NO : "& id &"", "berhasil dihapus", "success", Request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>