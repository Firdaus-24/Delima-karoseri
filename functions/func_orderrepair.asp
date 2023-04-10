<% 
  sub reapairH()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    customer = trim(Request.Form("customer"))
    tgljt = trim(Request.Form("tgljt"))
    diskon = trim(Request.Form("diskon"))
    ppn = trim(Request.Form("ppn"))
    timeWork = trim(Request.Form("timeWork"))
    uangmuka = trim(Request.Form("uangmuka"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM MKT_T_OrJulRepairH WHERE ORH_AgenID = '"& agen &"' AND ORH_Date = '"& tgl &"' AND ORH_custID = '"& customer &"' AND ORH_JTDate = '"& tgljt &"' AND ORH_Keterangan = '"& keterangan &"' AND ORH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddMKT_T_OrJulRepairH '"& agen &"','"& tgl &"', '"& customer &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& timeWork &", '"& uangmuka &"', '"& session("userid") &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      value = 1 'case untuk insert data
    else
      value = 2 'case jika gagal insert 
    end if
    
    if value = 1 then
      call alert("SALES ORDER HEADER", "berhasil di tambahkan", "success","sod_add.asp?id="&id) 
    elseif value = 2 then
      call alert("SALES ORDER HEADER", "sudah terdaftar", "warning","sod_add.asp")
    else
      value = 0
    end if
  end sub

  sub detailrepair()
    id = trim(Request.Form("id"))
    classid = trim(Request.Form("class"))
    brand = trim(Request.Form("brand"))
    qty = trim(Request.Form("qty"))
    satuan = trim(Request.Form("satuan"))
    harga = trim(Request.Form("harga"))
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM MKT_T_OrJulRepairD WHERE LEFT(ORD_ID, 13) = '"& id &"' AND ORD_classID = '"& classid &"' AND ORD_BrandID = '"& brand &"' AND ORD_Qtysatuan = "& qty &""
    ' response.write data_cmd.commandText & "<br>" 
    set orjul = data_cmd.execute 

    if orjul.eof then
      data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(ORD_ID),'000'),3)))+1),3)) as id From MKT_T_OrjulRepairD Where Left(ORD_ID,13) = '"& id &"'"

      set a = data_cmd.execute

      call query ("INSERT INTO MKT_T_OrjulRepairD (ORD_ID, ORD_classID, ORD_BrandID, ORD_Qtysatuan, ORD_JenisSat,ORD_Harga,ORD_Diskon,ORD_Keterangan,ORD_Updatetime,ORD_Updateid) VALUES ('"& a("id") &"','"& classid &"', '"& brand &"', "& qty &",'"& satuan &"','"& harga &"','"& diskon &"','"& keterangan &"','"& now &"','"& session("userid") &"')")

      value = 1 'case untuk insert data
    else
      value = 2 'case jika gagal insert 
    end if

    if value = 1 then
      call alert("DETAIL SALES ORDER REPAIR", "berhasil di tambahkan", "success","sod_add.asp?id="&id) 
    elseif value = 2 then
      call alert("DETAIL SALES ORDER REPAIR", "sudah terdaftar", "warning","sod_add.asp?id="&id)
    else
      value = 0
    end if
  end sub

  sub updaterepair()
    id = trim(Request.Form("id"))
    classid = trim(Request.Form("class"))
    brand = trim(Request.Form("brand"))
    qty = trim(Request.Form("qty"))
    satuan = trim(Request.Form("satuan"))
    harga = trim(Request.Form("harga"))
    diskon = trim(Request.Form("diskon"))
    keterangan = trim(Request.Form("keterangan"))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM MKT_T_OrJulRepairD WHERE LEFT(ORD_ID, 13) = '"& id &"' AND ORD_classID = '"& classid &"' AND ORD_BrandID = '"& brand &"' AND ORD_Qtysatuan = "& qty &""
    ' response.write data_cmd.commandText & "<br>" 
    set orjul = data_cmd.execute 

    if orjul.eof then
      data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(ORD_ID),'000'),3)))+1),3)) as id From MKT_T_OrjulRepairD Where Left(ORD_ID,13) = '"& id &"'"

      set a = data_cmd.execute

      call query ("INSERT INTO MKT_T_OrjulRepairD (ORD_ID, ORD_classID, ORD_BrandID, ORD_Qtysatuan, ORD_JenisSat,ORD_Harga,ORD_Diskon,ORD_Keterangan,ORD_Updatetime,ORD_Updateid) VALUES ('"& a("id") &"','"& classid &"', '"& brand &"', "& qty &",'"& satuan &"','"& harga &"','"& diskon &"','"& keterangan &"','"& now &"','"& session("userid") &"')")

      value = 1 'case untuk insert data
    else
      value = 2 'case jika gagal insert 
    end if

    if value = 1 then
      call alert("DETAIL SALES ORDER REPAIR", "berhasil di tambahkan", "success","so_u.asp?id="&id) 
    elseif value = 2 then
      call alert("DETAIL SALES ORDER REPAIR", "sudah terdaftar", "warning","so_u.asp?id="&id)
    else
      value = 0
    end if
  end sub

%>