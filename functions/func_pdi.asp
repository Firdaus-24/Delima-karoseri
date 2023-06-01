<% 
sub tambahPDI()
  cabang = trim(Request.Form("cabang"))
  tgl = trim(Request.Form("tgl"))
  pddid = trim(Request.Form("pddid"))
  ojhid = trim(Request.Form("ojhid"))
  tfkid = trim(Request.Form("tfkid"))
  divisi = trim(Request.Form("divisi"))
  departement = trim(Request.Form("departement"))
  refisi = trim(Request.Form("refisi"))
  keterangan = trim(Request.Form("keterangan"))


  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_PreDevInspectionH WHERE PDI_Agenid = '"& cabang &"' AND PDI_OJHID = '"& ojhid &"' AND PDI_PDDID = '"& pddid &"' AND PDI_TFKID = '"& tfkid &"' AND PDI_Divid = '"& divisi &"' AND PDI_depID = '"& departement &"'"

  set data = data_cmd.execute

  if data.eof then
    data_cmd.commandTExt = "exec sp_AddDLK_T_PreDevInspectionH '"& cabang &"', '"& tgl &"', '"& pddid &"', '"& ojhid &"','"& tfkid &"', '"& divisi &"', '"& departement &"', "& refisi &", '"& keterangan &"', '"& session("userid") &"'"

    set p = data_cmd.execute

    id = p("ID")
    call alert("PRE DELIVERY INSPECTIONS", "berhasil di tambahkan", "success","pdid_add.asp?id="&id)
  else
    call alert("PRE DELIVERY INSPECTIONS", "sudah terdaftar", "error","pdi_add.asp")
  end if

end sub


sub tambahDetailPDI()
  id = trim(Request.Form("id"))
  initial = trim(Request.Form("initial"))
  desc = trim(Request.Form("desc"))
  condition = trim(Request.Form("condition"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& id &"' AND PDI_Initial = '"& initial &"'"

  set data = data_cmd.execute


  if data.eof then  
    call query("INSERT INTO DLK_T_PreDevInspectionD (PDI_ID,PDI_Initial, PDI_Description, PDI_Condition,PDI_UpdateID) VALUES ('"& id &"', '"& initial &"', '"& desc &"', '"& condition &"', '"& session("userid") &"') ")
    call alert("DETAIL PRE DELIVERY INSPECTIONS", "berhasil di tambahkan", "success","pdid_add.asp?id="&id)
  else
    call alert("DETAIL PRE DELIVERY INSPECTIONS", "sudah terdaftar", "error","pdid_add.asp?id="&id)
  end if

end sub

sub updateDetailPDI()
  id = trim(Request.Form("id"))
  initial = trim(Request.Form("initial"))
  desc = trim(Request.Form("desc"))
  condition = trim(Request.Form("condition"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& id &"' AND PDI_Initial = '"& initial &"'"

  set data = data_cmd.execute


  if data.eof then  
    call query("INSERT INTO DLK_T_PreDevInspectionD (PDI_ID,PDI_Initial, PDI_Description, PDI_Condition,PDI_UpdateID) VALUES ('"& id &"', '"& initial &"', '"& desc &"', '"& condition &"', '"& session("userid") &"') ")
    call alert("DETAIL PRE DELIVERY INSPECTIONS", "berhasil di tambahkan", "success","pdid_u.asp?id="&id)
  else
    call alert("DETAIL PRE DELIVERY INSPECTIONS", "sudah terdaftar", "error","pdid_u.asp?id="&id)
  end if

end sub
%>