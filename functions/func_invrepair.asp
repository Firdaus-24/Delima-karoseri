<% 
  sub tambahInv()
    agen = trim(Request.Form("agen"))
    orhid = trim(Request.Form("orhid"))
    tgl = trim(Request.Form("tgl"))
    tgljt = trim(Request.Form("tgljt"))
    customer = trim(Request.Form("customer"))
    uangmuka = replace(replace(replace(trim(Request.Form("uangmuka")),".",""),"-",""),",","")
    diskon = trim(Request.Form("diskon"))
    ppn = trim(Request.Form("ppn"))
    timeWork = trim(Request.Form("tw"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM MKT_T_InvRepairH WHERE INV_AgenID = '"& agen &"' AND INV_ORHID = '"& orhid &"'"

    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddMKT_T_InvRepairH '"& agen &"', '"& orhid &"', '"& tgl &"', '"& tgljt &"', '"& customer &"',  '"& keterangan &"', "& diskon &", "& ppn &", '"& session("userid") &"', '"& uangmuka &"', "& timeWork &" "
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")

      call alert("INVOICE REPAIR", "berhasil ditambahkan", "success","invd_add.asp?id="&id) 
    else
      call alert("INVOICE REPAIR", "sudah terdaftar", "warning","inv_add.asp")
    end if
  end sub 

  sub detailInvoice()
    id = trim(Request.Form("id"))
    ordid = trim(Request.Form("ordid"))
    qty = trim(Request.Form("qty"))
    satuan = trim(Request.Form("satuan"))
    harga = replace(replace(replace(trim(Request.Form("harga")),".",""),",",""),"-","")
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    
    ' cek detail order po
    data_cmd.commandTExt = "SELECT ORD_ID, ORD_Classid, ORD_BrandID FROM MKT_T_OrjulRepairD WHERE ORD_ID = '"& ordid &"'"
    set ckorder = data_cmd.execute

    if not ckorder.eof then
      ' cek detail data
      data_cmd.commandTExt = "SELECT * FROM MKT_T_InvRepairD WHERE LEFT(IRD_INVID,13) = '"& id &"' AND IRD_classID = '"& ckorder("ORD_ClassID") &"' AND IRD_BrandID = '"& ckorder("ORD_BrandID") &"'"
      set datail = data_cmd.execute
      
      if datail.eof then
        ' setting id detail so
        data_cmd.commandText = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(IRD_INVID),'000'),3)))+1),3) ) as id FROM MKT_T_InvRepairD WHERE LEFT(IRD_InvID,13) = '"& id &"'"
        ' response.write data_cmd.commandText & "<br>"
        set ckid = data_cmd.execute

        call query("INSERT INTO MKT_T_InvRepairD (IRD_INVID,IRD_ClassID,IRD_BrandID,IRD_Qtysatuan,IRD_JenisSat,IRD_Harga,IRD_Diskon,IRD_Keterangan,IRD_updatetime,IRD_UpdateId) VALUES ('"& ckid("id") &"', '"& ckorder("ORD_Classid") &"',  '"& ckorder("ORD_Brandid") &"', "& qty &", '"& satuan &"', '"& harga &"', "& diskon &", '"& keterangan &"', '"& now &"', '"& session("userid") &"')   ")

        call alert("INVOICE REPAIR", "berhasil di tambahkan", "success","invd_add.asp?id="&id) 
      else
        call alert("INVOICE REPAIR", "sudah terdaftar!!", "error","invd_add.asp?id="&id) 
      end if
    else
        call alert("INVOICE REPAIR", "Nomor pesanan tidak terdaftar!!", "error","invd_add.asp?id="&id) 
    end if

    
  end sub 
%>