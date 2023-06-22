<!--#include file="../../init.asp"-->
<% 
  if session("PP7C") = false then 
    Response.Redirect("anggaran.asp")
  end if

  id = trim(Request.QueryString("id"))
  strid = left(id,17)
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE DLK_T_Memo_D WHERE MemoId = '"& id &"'")
  call alert("BARANG DENGAN ID "&id&" ", "berhasil hapus", "success",Request.ServerVariables("HTTP_REFERER"))
call footer() 
%>