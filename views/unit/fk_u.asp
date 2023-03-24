<!--#include file="../../init.asp"-->
<% 
  if session("MQ1B") = false then  
      Response.Redirect("index.asp")
  end if

  id = trim(Request.Form("id"))
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_ItemKendaraan WHERE FK_id = '"& id &"'"

  set data = data_cmd.execute

  call header("Tambah Item")
%>
<!--#include file="../../navbar.asp"-->
<% 
  if not data.eof then  
    data_cmd.commandText = "SELECT * FROM DLK_M_ItemKendaraan WHERE UPPER(FK_Nama) = '"& ucase(nama) &"'"
    set ckdata = data_cmd.execute

    if ckdata.eof then
      call query("UPDATE DLK_M_ItemKendaraan SET FK_Nama = '"& nama &"', FK_UpdateID = '"& session("userid") &"', FK_UpdateTIme = '"& now &"' WHERE FK_ID = '"& id &"'")
      call alert("MASTER ITEM PENUNJANG KENDARAAN", "berhasil diupdate", "success","index.asp")
    else
      call alert("MASTER ITEM PENUNJANG KENDARAAN", "Nama Yang di catat sudah terdaftar!!", "warning","index.asp")
    end if
  else
    call alert("MASTER ITEM PENUNJANG KENDARAAN", "sudah terdaftar!!", "error","index.asp")
  end if
 
call footer() %>