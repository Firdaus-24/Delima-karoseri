<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
  if session("HR7B") = false then  
    Response.Redirect("index.asp")
  end if

call header(" Update Jenjang")

nama = ucase(trim(request.form("nama")))
code = trim(request.form("code"))

set data_cmd = Server.CreateObject("ADODB.Command")
data_cmd.activeConnection = MM_delima_string

data_cmd.commandText ="SELECT * FROM HRD_M_Jenjang WHERE JJ_ID = '"& code &"'"

set jenjang = data_cmd.execute

if not jenjang.eof then

  call query ("UPDATE HRD_M_jenjang SET JJ_Nama = '"& nama &"', JJ_updateID = '"& session("userid") &"', JJ_updatetime = '"& now &"' WHERE JJ_ID = '"& code &"'")

  call alert("MASTER JENJANG", "berhasil di update", "success","index.asp")
else 
  call alert("MASTER JENJANG", "tidak terdaftar", "error","index.asp")
end if

call footer()
%> 
