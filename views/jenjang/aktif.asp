<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
  if session("HR7C") = false then  
    Response.Redirect("index.asp")
  end if

call header(" Aktif Jenjang")

id = ucase(trim(request.QueryString("id")))
aktif = ucase(trim(request.QueryString("aktif")))

set data_cmd = Server.CreateObject("ADODB.Command")
data_cmd.activeConnection = MM_delima_string

data_cmd.commandText ="SELECT * FROM HRD_M_Jenjang WHERE JJ_ID = '"& id &"'"

set jabatan = data_cmd.execute

if not jabatan.eof then

  call query ("UPDATE HRD_M_jenjang SET JJ_AktifYN = '"& aktif &"', JJ_updateID = '"& session("userid") &"', JJ_updatetime = '"& now &"' WHERE JJ_ID = '"& id &"'")

  call alert("AKTIFASI JABATAN", "berhasil di update", "success","index.asp")
else 
  call alert("AKTIFASI JABATAN", "tidak terdaftar", "error","index.asp")
end if

call footer()
%> 
