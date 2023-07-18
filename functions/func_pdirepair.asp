<%
sub tambah
  cabang = trim(Request.Form("cabang"))
  tgl = trim(Request.Form("tgl"))
  divisi = trim(Request.Form("divisi"))
  departement = trim(Request.Form("departement"))
  pdrid = trim(Request.Form("pdrid"))
  tfkid = trim(Request.Form("tfkid"))
  irhid = trim(Request.Form("irhid"))
  brandid = trim(Request.Form("brandid"))
  typepdirepair = trim(Request.Form("typepdirepair"))
  nopol = trim(Request.Form("nopol"))
  ranka = trim(Request.Form("ranka"))
  mesin = trim(Request.Form("mesin"))
  warna = trim(Request.Form("warna"))
  keterangan = trim(Request.Form("keterangan"))

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT * FROM DLK_T_PDIRepairH WHERE PDIR_Agenid = '"& cabang &"' AND PDIR_Divid = '"& divisi &"' AND PDIR_Depid = '"& departement &"' AND PDIR_PDRID = '"& pdrid &"'"
  set data = data_cmd.execute

 if data.eof then
    data_cmd.commandTExt = "exec sp_AddDLK_T_PDIRepairH '"& cabang &"', '"& tgl &"', '"& pdrid &"', '"& divisi &"', '"& departement &"', '"& tfkid &"', '"& irhid &"', '"& brandid &"', '"& typepdirepair &"', '"& nopol &"', '"& ranka &"', '"& mesin &"', '"& warna &"', '"& session("userid") &"', '"& keterangan &"'"

    set p = data_cmd.execute

    id = p("ID")
    call alert("PRE DELIVERY INSPECTIONS REPAIR", "berhasil di tambahkan", "success","pdird_add.asp?id="&id)
  else
    call alert("PRE DELIVERY INSPECTIONS REPAIR", "sudah terdaftar", "error",Request.ServerVariables("HTTP_REFERER"))
  end if
end sub

sub detail()
  id = trim(Request.Form("id"))
  irdirhid = trim(Request.Form("irdirhid"))
  desc = trim(Request.Form("desc"))
  remaks = trim(Request.Form("remaks"))
  condition = trim(Request.Form("conditionPdiRepair"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_PDIRepairD WHERE LEFT(PDIR_ID,14) = '"& id &"' AND PDIR_IRDIRHID = '"& irdirhid &"'"

  set data = data_cmd.execute


  if data.eof then  
    data_cmd.commandTExt = "SELECT ( '"& id &"' + Right('00' + Convert(varchar,Convert(int,(Right(isnull(Max(PDIR_ID),'00'),2)))+1),2)) as newid FROM DLK_T_PDIrepairD WHERE LEFT(PDIR_ID,14) = '"& id &"'"

    set p = data_cmd.execute
    
    call query("INSERT INTO DLK_T_PDIRepairD (PDIR_ID, PDIR_IRDIRHID, PDIR_Description, PDIR_Remaks, PDIR_img, PDIR_condition, PDIR_UpdateID) VALUES ('"& p("newid") &"', '"& irdirhid &"','"& desc &"','"& remaks &"', '', '"& condition &"', '"& session("userid") &"') ")

    call alert("DETAIL PRE DELIVERY INSPECTIONS REPAIR", "berhasil di tambahkan", "success", Request.ServerVariables("HTTP_REFERER"))
  else
    call alert("DETAIL PRE DELIVERY INSPECTIONS REPAIR", "sudah terdaftar", "error", Request.ServerVariables("HTTP_REFERER"))
  end if

end sub

sub updatedetail()
  idh = trim(Request.Form("id"))
  idd = trim(Request.Form("idpdirdrepair"))
  irdirhid = trim(Request.Form("irdirhid"))
  desc = trim(Request.Form("desc"))
  remaks = trim(Request.Form("remaks"))
  condition = trim(Request.Form("conditionPdiRepair"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_PDIRepairD WHERE PDIR_ID = '"& idd &"' "

  set data = data_cmd.execute


  if not data.eof then  
      call query("UPDATE DLK_T_PDIRepairD SET PDIR_IRDIRHID = '"& irdirhid &"', PDIR_Description = '"& desc &"', PDIR_Remaks = '"& remaks &"', PDIR_condition = '"& condition &"',PDIR_UpdateID = '"& session("userid") &"' WHERE PDIR_ID = '"& idd &"'")

      call alert("DETAIL PRE DELIVERY INSPECTIONS REPAIR", "berhasil di update", "success", Request.ServerVariables("HTTP_REFERER"))
  else
    call alert("DETAIL PRE DELIVERY INSPECTIONS REPAIR", "tidak terdaftar", "error", Request.ServerVariables("HTTP_REFERER"))
  end if
end sub
%>