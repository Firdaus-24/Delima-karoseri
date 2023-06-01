<!--#include file="../../init.asp"-->
<% 
  if session("MQ1A") = false then  
    Response.Redirect("index.asp")
  end if
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_ItemKendaraan WHERE UPPER(FK_Nama) = '"& ucase(nama) &"'"

  set data = data_cmd.execute

  call header("Tambah Item")
%>
<!--#include file="../../navbar.asp"-->
<% 
  if data.eof then  
    call query("exec sp_addDLK_M_ItemKendaraan '"& nama &"', '"& session("userid") &"'")
    call alert("MASTER ITEM PENUNJANG KENDARAAN", "berhasil ditambahkan!!", "success","index.asp")
  else
    call alert("MASTER ITEM PENUNJANG KENDARAAN", "sudah terdaftar!!", "error","index.asp")
  end if
 
call footer() %>