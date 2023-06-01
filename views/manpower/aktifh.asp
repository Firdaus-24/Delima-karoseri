<!--#include file="../../init.asp"-->
<% 
  if session("PP2C") = false then
      Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  p = trim(Request.QueryString("p"))

  if p = "N" then
    str = "berhasil non aktifkan"
  else
    str = "berhasil diaktifkan"
  end if

  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_ManpowerH SET MP_AktifYN = '"& p &"' WHERE MP_ID = '"& id &"'")
  call alert("HEADER MANPOWER DENGAN ID "&id&" ", str, "success","index.asp") 
call footer() 
%>