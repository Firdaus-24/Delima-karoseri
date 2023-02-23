<!-- #include file='../../init.asp' -->
<% 
  if session("HR5C") = false then
    Response.Redirect("index.asp")
  end if

  call header("Aktif Karyawan")

  dim aktif, update, nip, salary
  aktif = Request.QueryString("p")
  nip = Request.QueryString("q")

  set update = Server.CreateObject("ADODB.Command")
  update.ActiveConnection = MM_Delima_string
  if aktif = "Y" then
    update.commandText = "UPDATE HRD_M_Karyawan Set Kry_AktifYN = 'N' WHERE Kry_Nip = '"& nip &"'"
    update.execute
    call alert("DATA KARYAWAN DENGAN NIP "&nip, "berhasil di nonaktifkan", "success","index.asp")
  else
    update.commandText = "UPDATE HRD_M_Karyawan Set Kry_AktifYN = 'Y' WHERE Kry_Nip = '"& nip &"'"
    update.execute
    call alert("DATA KARYAWAN DENGAN NIP "&nip, "berhasil di aktifkan", "success","index.asp")
  end if
%>
<!--#include file="../../navbar.asp"-->
<% call footer() %>