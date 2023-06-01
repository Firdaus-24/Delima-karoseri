<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
  if session("HR6A") = false then
    Response.Redirect("index.asp")
  end if
call header(" Tambah Jabatan")
nama = trim(request.form("nama"))
id = ucase(trim(request.form("id")))

set data_cmd = Server.CreateObject("ADODB.Command")
data_cmd.activeConnection = MM_delima_string

data_cmd.commandText ="SELECT * FROM HRD_M_Jabatan WHERE Jab_Code = '"& id &"'"

set jabatan = data_cmd.execute

if jabatan.eof then

  call query ("exec sp_AddHRD_M_jabatan '"& id &"', '"& nama &"','"& session("userid") &"'")

  call alert("MASTER JABATAN", "berhasil di tambahkan", "success","index.asp")
else 
  call alert("MASTER JABATAN", "sudah terdaftar", "error","index.asp")
end if

call footer()
%> 
