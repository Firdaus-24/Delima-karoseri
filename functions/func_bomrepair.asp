<%
  sub tambah()
    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    pdrid = trim(Request.Form("pdrid"))
    irhid = trim(Request.Form("irhid"))
    tmanpower = trim(Request.Form("tmanpower"))
    salary = replace(replace(replace(trim(Request.Form("salary")),".",""),",",""),"-","")
    keterangan = trim(Request.Form("keterangan"))


    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_BOMRepairH WHERE BmrAgenid = '"& cabang &"' AND BmrPDRID = '"& pdrid &"' AND BmrIRHID = '"& irhid &"' AND BmrAktifYN = 'Y'"

    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandTExt = "exec sp_AddDLK_T_BOMRepairH '"& pdrid &"', '"& irhid &"', '"& cabang &"', '"& tgl &"',  '"& session("userid") &"', '"& keterangan &"', "& tmanpower &", '"& salary &"'"

      set p = data_cmd.execute

      id = p("ID")
      call alert("B.O.M REPAIR", "berhasil di tambahkan", "success","bmrd_add.asp?id="&id)
    else
      call alert("B.O.M REPAIR", "sudah terdaftar", "error","Bmr_add.asp")
    end if

  end sub

sub tambahbomD()
    bmrid = trim(Request.Form("bmrid"))
    ckbmrdbrg = trim(Request.Form("ckbmrdbrg"))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_BOMRepairD WHERE BMRDBrgID = '"& ckbmrdbrg &"' AND LEFT(BMRDID,13) = '"& bmrid &"'"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "SELECT ('"&bmrid&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BMRDID),'000'),3)))+1),3)) as id From DLK_T_BOMRepairD Where Left(BMRDID,13) = '"& bmrid &"'"

      set a = data_cmd.execute

      call query ("INSERT INTO DLK_T_BOMRepairD (BmrdID,BmrdBrgID,BmrdQtysatuan,BmrdSatID,BmrdUpdateID,BmrdKeterangan) VALUES ('"& a("id") &"','"& ckbmrdbrg &"', "& qtty &", '"& satuan &"','"& session("userid") &"','"& keterangan &"')")

      call alert("DETAIL B.O.M REPAIR", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
    else
      call alert("DETAIL B.O.M REPAIR", "sudah terdaftar", "error",Request.ServerVariables("HTTP_REFERER"))
    end if
end sub


sub anggaran()
  tgl = trim(Request.Form("tgl"))
  agen = trim(Request.Form("agen"))
  divisi = trim(Request.Form("divisi"))
  departement = trim(Request.Form("departement"))
  keterangan = trim(Request.Form("keterangan"))
  kebutuhan = trim(Request.Form("kebutuhan"))
  bmrid = trim(Request.Form("bmrid"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoTgl = '"& tgl &"' AND MemoagenID = '"& agen &"' AND memoDepID = '"& departement &"' AND memoKeterangan = '"& keterangan &"' AND memoKebutuhan = "& kebutuhan &" AND memoApproveYN = 'N' AND memobmrid = '"& bmrid &"' AND memoAktifYN = 'Y'"
  ' response.write data_cmd.commandText
  set data = data_cmd.execute

  if data.eof then
    data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& departement &"', '"& divisi &"', '"& keterangan &"', '"& session("userid") &"', "& kebutuhan &", '"& bmrid &"' ,'','' ,1"
    set pdata = data_cmd.execute

    strid = pdata("ID")
    
    ' cek detail bom 
    data_cmd.commandTExt = "SELECT * FROM DLK_T_BOMRepairD WHERE LEFT(BmrdID,13) = '"& bmrid &"' order by BmrdBrgID ASC"
    ' Response.Write data_cmd.commandTExt
    set drepar = data_cmd.execute

    do while not drepar.eof 
      ' cek harga
      data_cmd.commandTExt = "SELECT ISNULL(MAX(Dven_Harga),0) as harga FROM DLK_T_VendorD where Dven_BrgID = '"& drepar("BmrdBrgID") &"'"

      ' Response.Write data_cmd.commandTExt 
      set ckharga = data_cmd.execute

      data_cmd.commandTExt = "SELECT ('"& strid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(memoID),'000'),3)))+1),3)) as newid FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& strid &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& p("newid") &"','"& drepar("BmrdBrgID") &"', '', "& drepar("BmrdQtysatuan") &",'"& drepar("BmrdSatID") &"', '"& drepar("BmrdKeterangan") &"', '"& ckharga("harga") &"')")
  
    response.flush
    drepar.movenext
    loop


    call alert("PERMINTAAN B.O.M REPAIR", "berhasil di tambahkan", "success","anggaran.asp") 
  else
    call alert("PERMINTAAN B.O.M REPAIR", "sudah terdaftar", "warning","./")
  end if


end sub

%>