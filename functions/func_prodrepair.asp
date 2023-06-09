<%
  sub tambah()
    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    startdate = trim(Request.Form("startdate"))
    enddate = trim(Request.Form("enddate"))
    irhidrepair = trim(Request.Form("irhidrepair"))
    tfkid = trim(Request.Form("tfkid"))
    brand = trim(Request.Form("brand"))
    typepdr = trim(Request.Form("typepdr"))
    nopol = trim(Request.Form("nopol"))
    nomesin = trim(Request.Form("nomesin"))
    rangka = trim(Request.Form("rangka"))
    warna = trim(Request.Form("warna"))

    set data_cmd = Server.CreateObject("ADODB.Command")
    data_cmd.ActiveConnection = MM_Delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiRepair WHERE PDR_AgenID = '"& cabang &"' AND PDR_IRHID = '"& irhidrepair &"' AND PDR_TFKID = '"& tfkid &"' AND PDR_AktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then
      call query("exec sp_addDLK_T_ProduksiRepair  '"& cabang &"', '"& tfkid &"', '"& irhidrepair &"','"& tgl &"','"& startdate &"','"& enddate &"', '"& brand &"', '"& typepdr &"','"& nopol &"', '"& rangka &"','"& nomesin &"','"& warna &"','"& session("Userid") &"','"& now &"'")
      call alert("DATA PRODUKSI REPAIR", "berhasil di tambahkan", "success","index.asp")
    else 
      call alert("DATA PRODUKSI REPAIR", "sudah terdaftar", "error","pdr_add.asp")
    end if

  end sub    

  sub Update()
    id = trim(Request.Form("id"))
    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    startdate = trim(Request.Form("startdate"))
    enddate = trim(Request.Form("enddate"))
    irhidrepair = trim(Request.Form("irhidrepair"))
    tfkid = trim(Request.Form("tfkid"))
    brand = trim(Request.Form("brand"))
    typepdr = trim(Request.Form("typepdr"))
    nopol = trim(Request.Form("nopol"))
    nomesin = trim(Request.Form("nomesin"))
    rangka = trim(Request.Form("rangka"))
    warna = trim(Request.Form("warna"))

    set data_cmd = Server.CreateObject("ADODB.Command")
    data_cmd.ActiveConnection = MM_Delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiRepair WHERE PDR_ID = '"& id &"' AND PDR_AktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
      call query("UPDATE DLK_T_ProduksiRepair SET PDR_AgenID = '"& cabang &"' ,PDR_TFKID = '"& tfkid &"',PDR_IRHID = '"& irhidrepair &"',PDR_Date = '"& tgl &"',PDR_StartDate = '"& startdate &"',PDR_EndDate = '"& enddate &"',PDR_BrandID = '"& brand &"',PDR_Type = '"& typepdr &"',PDR_Nopol = '"& nopol &"',PDR_Norangka = '"& rangka &"',PDR_NoMesin = '"& nomesin &"',PDR_Color = '"& warna &"',PDR_UpdateID = '"& session("Userid") &"',PDR_UpdateTime = '"& now &"'  WHERE PDR_ID = '"& id &"'")
      call alert("DATA PRODUKSI REPAIR", "berhasil di update", "success", Request.ServerVariables("HTTP_REFERER")	)
    else 
      call alert("DATA PRODUKSI REPAIR", "tidak terdaftar", "error",Request.ServerVariables("HTTP_REFERER")	)
    end if

  end sub    

%>