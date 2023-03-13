<!--#include file="../../init.asp"-->
<%  
  if session("M11B") = false then
    Response.Redirect("index.asp")
  end if
  call header("Update Satuan Panjang") 
%>
<!--#include file="../../navbar.asp"-->
<% 

  id = trim(Request.Form("id"))
  nama = UCase(trim(Request.Form("nama")))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_SatuanPanjang WHERE SP_id = "& id &""

  set data = data_cmd.execute

  if not data.eof then
    ' cek nama data yang sama
    data_cmd.commandText = "SELECT SP_Nama FROM DLK_M_SatuanPanjang WHERE SP_Nama = '"& nama &"'"
    set detail = data_cmd.execute

    if detail.eof then
      call query("UPDATE DLK_M_SatuanPanjang SET SP_Nama =  '"& nama &"', SP_UpdateID = '"& session("userid") &"' WHERE SP_ID = '"& id &"'")
      call alert("MASTER SATUAN PANJANG", "berhasil di update", "success","index.asp") 
    else
      call alert("MASTER SATUAN PANJANG", "Nama satuan sudah terdaftar", "warning","index.asp")
    end if
  else
    call alert("MASTER SATUAN PANJANG", "tidak terdaftar", "warning","index.asp")
  end if

call footer() 
%>