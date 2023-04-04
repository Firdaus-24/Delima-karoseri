<!--#include file="../../init.asp"-->
<%  
  if session("M12B") = false then
    Response.Redirect("index.asp")
  end if

  call header("Update beban") %>
<!--#include file="../../navbar.asp"-->
<% 
  id = trim(Request.Form("id"))
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_BebanBiaya WHERE BN_ID = "& id &""
  set data = data_cmd.execute

  if not data.eof then
    data_cmd.commandText = "SELECT BN_Nama FROM DLK_M_BebanBiaya WHERE UPPER(BN_Nama) = '"& ucase(nama) &"'"

    set ckdata = data_cmd.execute

    if ckdata.eof then
      call query ("UPDATE DLK_M_BebanBiaya SET BN_Nama = '"& nama &"', BN_UpdateID = '"& session("userid") &"',BN_UpdateTime = '"& now &"' WHERE BN_ID = "& id &" ")

      call alert("MASTER BEBAN BIAYA PRODUKSI", "berhasil di Update", "success","index.asp") 
    else
      call alert("DESKRIPSI NAMA!!", "Sudah pernah di pakai", "error","index.asp") 
    end if
  else
    call alert("MASTER BEBAN BIAYA PRODUKSI", "tidak terdaftar", "error","index.asp") 
  end if

 
call footer() 
%>