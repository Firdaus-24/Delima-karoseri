<!--#include file="../../init.asp"-->
<% 
  if session("M11C") = false then 
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_M_satuanPanjang SET SP_AktifYN = 'N' WHERE SP_ID = '"& id &"'")
  call alert("SATUAN PANJANG ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>