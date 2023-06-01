<% 
  sub tambahSerahterima()
    salesorder = trim(Request.Form("salesorder"))
    custid = trim(Request.Form("custid"))
    tgl = trim(Request.Form("tgl"))
    penerima = trim(Request.Form("penerima"))
    penyerah = trim(Request.Form("penyerah"))
    keterangan = trim(Request.Form("keterangan"))
    jenisUnit = trim(Request.Form("jenisUnit"))

    data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerH WHERE TFK_OJHORHID = '"& salesorder &"' AND TFK_custid = '"& custid &"'"
    ' response.write data_cmd.commandtext & "<br>"
    set st = data_cmd.execute

    if st.eof then
      data_cmd.commandtext = "exec sp_addDLK_T_UnitCustomerH '"& salesorder &"', '"& custid &"','"& tgl &"','"& keterangan &"','"& penyerah &"', '"& penerima &"', '"& session("userid") &"', "& jenisUnit &""
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      call alert("DETAIL TRANSAKSI PENERIMAAN UNIT", "berhasil di tambahkan", "success","tfkd_add.asp?id="&id)
    else
      call alert("DETAIL TRANSAKSI PENERIMAAN UNIT", "sudah terdaftar", "error","tfk_add.asp?id=")
    end if
  end sub

  sub detailSerahTerima()
    filetype = trim(Request.Form("filetype"))
    idtfk = trim(Request.Form("idtfk"))
    tgl = trim(Request.Form("tgl"))
    merek = trim(Request.Form("textmerek"))
    ltype = trim(Request.Form("type"))
    polisi = trim(Request.Form("polisi"))
    rangka = trim(Request.Form("rangka"))
    mesin = trim(Request.Form("mesin"))
    warna = trim(Request.Form("warna"))

    data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD1 WHERE LEFT(TFK_ID,17) = '"& idtfk &"' AND TFK_BrandID = '"& merek &"'  AND TFK_Type = '"& ltype &"' AND TFK_Nopol = '"& polisi &"'  AND TFK_Norangka = '"& rangka &"'  AND TFK_NoMesin = '"& mesin &"' "
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
    
    if data.eof then
      data_cmd.commandText = "Select '"& idtfk &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(TFK_ID),'000'),3)))+1),3) as id From DLK_T_UnitCustomerD1 Where Left(TFK_ID,17)= '"& idtfk &"'"
      ' response.write data_cmd.commandText & "<br>"
      set ddata = data_cmd.execute

      data_cmd.commandText = "INSERT INTO DLK_T_UnitCustomerD1 (TFK_ID,TFK_Date,TFK_BrandID,TFK_Type,TFK_Nopol,TFK_Norangka,TFK_NoMesin,TFK_Color,TFK_UpdateID,TFK_UpdateTime) VALUES ( '"& ddata("id") &"', '"& tgl &"', '"& merek &"', '"& ltype &"','"& polisi &"', '"& rangka &"', '"& mesin &"','"& warna &"', '"& session("userid") &"', '"& now &"')"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      ' get data terakhir
      data_cmd.commandText = "SELECT TOP 1 TFK_ID FROM DLK_T_UnitCustomerD1 WHERE LEFT(TFK_ID,17) = '"& idtfk &"' ORDER BY TFK_ID DESC"
      set p = data_cmd.execute 

      call alert("Success","","success","setTools.asp?id="&p("TFK_ID")&"&p="&filetype)
    else
      call alert("ERROR!!!!","Data sudah pernah terdaftar","error", filetype&".asp?id="&idtfk)
    end if

  end sub
%>