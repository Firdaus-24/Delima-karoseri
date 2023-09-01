<%
sub tambah()
  agen = trim(Request.Form("agen"))
  cktprod = trim(Request.Form("cktprod"))
  pdhid = trim(Request.Form("pdhid"))
  pdrid = trim(Request.Form("pdrid"))
  tgl = trim(Request.Form("tgl"))
  keterangan = trim(Request.Form("keterangan"))
  
  data_cmd.commandText = "SELECT * FROM DLK_T_VoucherH WHERE VCH_Agenid = '"& agen &"' AND VCH_PDDID = '"& pdhid &"' AND VCH_PDRID = '"& pdrid &"' AND VCH_Date = '"& tgl &"'"
  set data = data_cmd.execute

  if data.eof then
    data_cmd.commandText = "exec sp_addDLK_T_VoucherH '"& tgl &"', '"& agen &"', '"& pdhid &"', '"& pdrid &"', '"& cktprod &"', '"& keterangan &"', '"& Session("userid") &"'"
    set p = data_cmd.execute

    call alert("VOUCHER PERMINTAAN BARANG", "berhasil di tambahkan", "success","vcd_add.asp?id="&p("ID"))
   else 
    call alert("VOUCHER PERMINTAAN BARANG", "sudah terdaftar!!", "error","vc_add.asp")
  end if
end sub

sub updateheader()
  id = trim(Request.QueryString("id"))
  agen = trim(Request.Form("agen"))
  cktprod = trim(Request.Form("cktprod"))
  pdhid = trim(Request.Form("pdhid"))
  pdrid = trim(Request.Form("pdrid"))
  tgl = trim(Request.Form("tgl"))
  keterangan = trim(Request.Form("keterangan"))

  data_cmd.commandText = "SELECT * FROM DLK_T_VoucherH WHERE VCH_ID = '"& id &"' AND VCH_AktifYN = 'Y'"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

  if not data.eof then
    call query("UPDATE DLK_T_VoucherH SET VCH_Agenid = '"& agen &"',VCH_Date = '"& tgl &"', VCH_PDDID = '"& pdhid &"',VCH_PDRID = '"& pdrid &"', VCH_Type = '"& cktprod &"', VCH_keterangan = '"& keterangan &"' WHERE VCH_ID = '"& id &"'")

    call alert("UPDATE VOUCHER BARANG", "data berhasil diupdate", "success",Request.ServerVariables("HTTP_REFERER"))
   else 
    call alert("UPDATE VOUCHER BARANG", "tidak terdaftar!!", "error",Request.ServerVariables("HTTP_REFERER"))
  end if
end sub

sub detail()
  voucherid = trim(Request.Form("voucherid"))
  brg = trim(Request.Form("ckbrgvoucherPBarang"))
  qtty = trim(Request.Form("qtty"))
  satuan = trim(Request.Form("satuan"))
  keterangan = trim(Request.Form("keterangan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_VoucherD WHERE LEFT(DLK_T_VoucherD.VCH_VCHID,13) = '"& voucherid &"' AND VCH_Item = '"& brg &"'"
  set ckdata = data_cmd.execute 

  if ckdata.eof then
    data_cmd.commandTExt = "SELECT ('"& voucherid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(VCH_VCHID),'000'),3)))+1),3)) as newid FROM DLK_T_VoucherD WHERE LEFT(VCH_VCHID,13) = '"& voucherid &"'"
    set p = data_cmd.execute

    call query ("INSERT INTO DLK_T_VoucherD (VCH_VCHID,VCH_Item,VCH_Qtysatuan,VCH_Satid,VCH_Updateid,VCH_Updatetime,VCH_Keterangan) VALUES ('"& p("newid") &"', '"& brg &"', "& qtty &", '"& satuan &"', '"& Session("userid") &"', '"& now &"','"& keterangan &"') ")
    call alert("DETAIL VOUCHER PERMINTAAN BARANG", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER"))
  else
    call alert("DETAIL VOUCHER PERMINTAAN BARANG", "sudah terdaftar", "error",Request.ServerVariables("HTTP_REFERER"))
  end if

end sub

%>