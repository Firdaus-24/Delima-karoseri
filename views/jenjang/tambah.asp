<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
  if session("HR7A") = false then  
    Response.Redirect("index.asp")
  end if

call header(" Tambah Jenjang")
nama = Ucase(trim(request.form("nama")))

set data_cmd = Server.CreateObject("ADODB.Command")
data_cmd.activeConnection = MM_delima_string

data_cmd.commandText ="SELECT * FROM HRD_M_Jenjang WHERE UPPER(JJ_Nama) = '"& nama &"'"

set jenjang = data_cmd.execute

if jenjang.eof then

  call query ("exec sp_AddHRD_M_Jenjang '"& nama &"','"& session("userid") &"' ")

  call alert("MASTER JABATAN", "berhasil di tambahkan", "success","index.asp")
else 
  call alert("MASTER JABATAN", "sudah terdaftar", "error","index.asp")
end if

call footer()
%> 
