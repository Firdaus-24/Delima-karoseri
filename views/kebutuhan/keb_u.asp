<!--#include file="../../init.asp"-->
<!--#include file="../../navbar.asp"-->
<% 
   if session("M10B") = false then 
      Response.Redirect("index.asp")
   end if

   call header("Tambah Kebutuhan ")

   id = ucase(trim(Request.Form("id")))
   lnama = ucase(trim(Request.Form("lnama")))
   nama = ucase(trim(Request.Form("nama")))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Kebutuhan WHERE K_ID = '"& id &"' AND K_aktifYN = 'Y'"

   set data = data_cmd.execute

   if not data.eof then
      call query("UPDATE DLK_M_Kebutuhan SET K_Name = '"& nama &"', K_updateID = '"& session("UserID") &"', K_UpdateTIme = '"& now &"' WHERE K_ID = "& id &"")

      call alert("MASTER KEBUTUHAN", "berhasil diupdate", "success","index.asp") 
   else
      call alert("MASTER KEBUTUHAN", "tidak terdaftar", "error","index.asp") 
   end if   
   call footer()
%>