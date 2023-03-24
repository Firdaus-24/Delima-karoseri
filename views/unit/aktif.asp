<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
  if session("MQ1C") = false then  
    Response.Redirect("index.asp")
  end if

call header(" Aktif Item Kendaraan")

id = ucase(trim(request.QueryString("id")))
aktif = ucase(trim(request.QueryString("aktif")))

set data_cmd = Server.CreateObject("ADODB.Command")
data_cmd.activeConnection = MM_delima_string

data_cmd.commandText ="SELECT * FROM DLK_M_ItemKendaraan WHERE FK_ID = '"& id &"'"

set jabatan = data_cmd.execute

if not jabatan.eof then

  call query ("UPDATE DLK_M_ItemKendaraan SET FK_AktifYN = '"& aktif &"', FK_updateID = '"& session("userid") &"', FK_updatetime = '"& now &"' WHERE FK_ID = '"& id &"'")

  call alert("AKTIFASI ITEM KENDARAAN", "berhasil di update", "success","index.asp")
else 
  call alert("AKTIFASI ITEM KENDARAAN", "tidak terdaftar", "error","index.asp")
end if

call footer()
%> 
