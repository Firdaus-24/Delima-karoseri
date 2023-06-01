<!--#include file="../../init.asp"-->
<%  
  if session("M11A") = false then
    Response.Redirect("index.asp")
  end if
  call header("Form Satuan Panjang") 
%>
<!--#include file="../../navbar.asp"-->
<% 

  nama = UCase(trim(Request.Form("nama")))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_SatuanPanjang WHERE SP_Nama = '"& nama &"'"

  set data = data_cmd.execute

  if data.eof then
    call query ("exec sp_addDLK_M_SatuanPanjang '"& nama &"','"& session("userid") &"' ")
    call alert("MASTER SATUAN PANJANG", "berhasil di tambahkan", "success","index.asp") 
  else
    call alert("MASTER SATUAN PANJANG", "sudah terdaftar", "warning","index.asp")
  end if

call footer() 
%>