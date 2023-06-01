<!--#include file="../../init.asp"-->
<%  
  if session("HR8A") = false OR session("HR8B") then
    Response.Redirect("index.asp")
  end if
  call header("Form jenis usaha") %>
<!--#include file="../../navbar.asp"-->
<% 

  initialush = trim(Request.Form("initialush"))
  id = trim(Request.Form("id"))
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  if initialush = "add" then

    data_cmd.commandText = "SELECT Ush_nama FROM HRD_M_JnsUsaha WHERE UPPER(Ush_Nama) = '"& ucase(nama) &"'"
    set data = data_cmd.execute

    if data.eof then
      call query("INSERT INTO HRD_M_JnsUsaha (Ush_Nama,Ush_updatetime,ush_updateid,ush_aktifYN) VALUES ('"& nama &"', '"& now &"', '"& session("userid") &"', 'Y') ")
      call alert("MASTER JENIS USAHA", "berhasil di tambahkan", "success","index.asp") 
    else
      call alert("MASTER JENIS USAHA", "sudah terdaftar", "error","index.asp") 
    end if
  elseIf initialush = "update" then
    data_cmd.commandText = "SELECT * FROM HRD_M_Jnsusaha WHERE Ush_ID = "& id &" "
    set data = data_cmd.execute

    if not data.eof then
      data_cmd.commandText = "SELECT Ush_nama FROM HRD_M_JnsUsaha WHERE UPPER(Ush_Nama) = '"& ucase(nama) &"'"
      set ckdata = data_cmd.execute

        if ckdata.eof then
          call query("UPDATE HRD_M_JnsUsaha SET Ush_nama = '"& nama &"', Ush_updatetime = '"& now &"', ush_updateid = '"& session("userid") &"' WHERE Ush_id = '"& id &"'")
          call alert("MASTER JENIS USAHA", "berhasil di update", "success","index.asp")
        else  
          call alert("MASTER JENIS USAHA", "daftar nama sudah terdaftar", "error","index.asp")
        end if
    else
      call alert("MASTER JENIS USAHA", "data tidak terdaftar", "error","index.asp")
    end if
  else
    call alert("ERROR", "data tidak terdaftar", "error","index.asp")
  end if

  call footer()
%>