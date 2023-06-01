<!--#include file="../../init.asp"-->
<% 
  if session("MQ4C") = false then 
    Response.Redirect("./")
  end if
  dim id 
  dim fs
  id = trim(Request.QueryString("id"))

  Set fs=Server.CreateObject("Scripting.FileSystemObject")
  if fs.FileExists(pathDoc&id&"\"&id&"A.jpg") then
    fs.DeleteFile(pathDoc&id&"\"&id&"A.jpg")
  end if
  if fs.FileExists(pathDoc&id&"\"&id&"B.jpg") then
    fs.DeleteFile(pathDoc&id&"\"&id&"B.jpg")
  end if
  if fs.FileExists(pathDoc&id&"\"&id&"C.jpg") then
    fs.DeleteFile(pathDoc&id&"\"&id&"C.jpg")
  end if
  if fs.FileExists(pathDoc&id&"\"&id&"D.jpg") then
    fs.DeleteFile(pathDoc&id&"\"&id&"D.jpg")
  end if
  if fs.FileExists(pathDoc&id&"\"&id&"E.jpg") then
    fs.DeleteFile(pathDoc&id&"\"&id&"E.jpg")
  end if
  set fs=nothing
 
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_IncRepairH SET IRH_aktifYN = 'N' WHERE IRH_ID = '"& id &"'")
  call alert("INCOMMING REPAIR NO : "& id &"", "berhasil dihapus", "success", Request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>