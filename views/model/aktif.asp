<!--#include file="../../init.asp"-->
<% 
  if session("MDL1C") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_M_Barang SET Brg_AktifYN = 'N' WHERE Brg_ID = '"& id &"'")
  call alert("MASTER MODEL DENGAN ID "& id &"", "berhasil non aktifkan", "success","./") 
  call footer() 
%>