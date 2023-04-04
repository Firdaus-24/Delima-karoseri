<% 
sub tambahBebanProses()
  cabang = trim(Request.Form("cabang"))
  prodid = trim(Request.Form("prodid"))
  tgl = trim(Request.Form("tgl"))
  keterangan = trim(Request.Form("keterangan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_BB_ProsesH WHERE BP_AgenID = '"& cabang &"' AND BP_PDHID = '"& prodid &"'" 
  
  set data = data_cmd.execute
 
  if data.eof then
    data_cmd.commandTExt = "exec sp_addDLK_T_BB_ProsesH '"& cabang &"', '"& prodid &"', '"& tgl &"', '"& session("userid") &"', '"& keterangan &"'"

    set p = data_cmd.execute

    id = p("ID")

    call alert("TRANSAKSI BEBAN PROSES PRODUKSI", "berhasil di tambahkan", "success","bpd_add.asp?id="&id)
  else 
    call alert("TRANSAKSI BEBAN PROSES PRODUKSI", "sudah terdaftar", "error","bp_add.asp")
  end if
end sub

sub detailBeban()
  id = trim(Request.Form("id"))
  bnid = trim(Request.Form("bnid"))
  jumlah = trim(Request.Form("jumlah"))
  keterangan = trim(Request.Form("keterangan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_BB_ProsesD WHERE LEFT(BP_ID,12) = '"& id &"' AND BP_BNID = "& bnid &""
  set ddata = data_cmd.execute

  if ddata.eof then
    data_cmd.commandTExt = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BP_ID),'000'),3)))+1),3) ) as id FROM DLK_T_BB_ProsesD WHERE LEFT(BP_ID,12) = '"& id &"' "

    set p = data_cmd.execute

    call query("INSERT INTO DLK_T_BB_ProsesD (BP_ID, BP_BNID, BP_Jumlah, BP_KEterangan, BP_updateID, BP_updatetime) VALUES ('"& p("id") &"', "& bnid &", '"& jumlah &"', '"& keterangan &"', '"& session("userid") &"', '"& now &"' )  ")
    

    call alert("TRANSAKSI BEBAN PROSES PRODUKSI DETAIL", "berhasil di tambahkan", "success","bpd_add.asp?id="&id)
  else
    call alert("TRANSAKSI BEBAN PROSES PRODUKSI DETAIL", "sudah terdaftar", "error","bpd_add.asp?id="&id)
  end if

end sub

sub updateBeban()
  id = trim(Request.Form("id"))
  bnid = trim(Request.Form("bnid"))
  jumlah = trim(Request.Form("jumlah"))
  keterangan = trim(Request.Form("keterangan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_BB_ProsesD WHERE LEFT(BP_ID,12) = '"& id &"' AND BP_BNID = "& bnid &""
  set ddata = data_cmd.execute

  if ddata.eof then
    data_cmd.commandTExt = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BP_ID),'000'),3)))+1),3) ) as id FROM DLK_T_BB_ProsesD WHERE LEFT(BP_ID,12) = '"& id &"' "

    set p = data_cmd.execute

    call query("INSERT INTO DLK_T_BB_ProsesD (BP_ID, BP_BNID, BP_Jumlah, BP_KEterangan, BP_updateID, BP_updatetime) VALUES ('"& p("id") &"', "& bnid &", '"& jumlah &"', '"& keterangan &"', '"& session("userid") &"', '"& now &"' )  ")
    

    call alert("TRANSAKSI BEBAN PROSES PRODUKSI DETAIL", "berhasil di tambahkan", "success","bp_u.asp?id="&id)
  else
    call alert("TRANSAKSI BEBAN PROSES PRODUKSI DETAIL", "sudah terdaftar", "error","bp_u.asp?id="&id)
  end if

end sub
%>