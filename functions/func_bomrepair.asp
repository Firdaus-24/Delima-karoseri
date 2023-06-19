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

%>