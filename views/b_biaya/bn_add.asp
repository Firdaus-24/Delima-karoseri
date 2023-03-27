<!--#include file="../../init.asp"-->
<%  
  ' if session("HR2A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  call header("Tambah beban") %>
<!--#include file="../../navbar.asp"-->
<% 
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_BebanBiaya WHERE UPPER(BN_Nama) = '"& ucase(nama) &"'"
  set data = data_cmd.execute

  if data.eof then
    call query ("INSERT INTO DLK_M_BebanBiaya (BN_Nama,BN_UpdateID,BN_UpdateTime,BN_aktifYN) VALUES ('"& nama &"', '"& session("userid") &"','"& now &"','Y')")
    call alert("MASTER BEBAN BIAYA PRODUKSI", "berhasil di tambahkan", "success","index.asp") 
  else
    call alert("MASTER BEBAN BIAYA PRODUKSI", "sudah terdaftar", "error","index.asp") 
  end if

 
call footer() 
%>