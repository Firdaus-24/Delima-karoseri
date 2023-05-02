<% 
  sub tambahinv()
    cabang = trim(Request.Form("cabang"))
    orjulid = trim(Request.Form("orjulid"))
    tgl = trim(Request.Form("tgl"))
    tgljt = trim(Request.Form("tgljt"))
    cust = trim(Request.Form("cust"))
    diskon = trim(Request.Form("diskon"))
    ppn = trim(Request.Form("ppn"))
    tukar = trim(Request.Form("tukar"))
    keterangan = trim(Request.Form("keterangan"))

    ' set data_cmd =  Server.CreateObject ("ADODB.Command")
    ' data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM MKT_T_InvJulNewH WHERE IPH_AgenID = '"& cabang &"' AND IPH_OJHID = '"& orjulid &"' AND IPH_Custid = '"& cust &"' AND IPH_AktifYN = 'Y'"

    set data = data_cmd.execute
     
    if data.eof then
      data_cmd.commandText = "exec sp_AddMKT_T_InvJulNewH '"& cabang &"', '"& orjulid &"', '"& tgl &"', '"& cust &"', '"& tgljt &"', '"& keterangan &"', '"& diskon &"', '"& ppn &"', '"& tukar &"' "
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")

      call alert("INVOICE", "berhasil ditambahkan", "success","invd_add.asp?id="&id) 
    else
      call alert("INVOICE", "sudah terdaftar", "warning","inv_add.asp")
    end if
  end sub

  sub detailinvoice()
    iphid = trim(Request.Form("iphid"))
    ckinvoicenew = trim(Request.Form("ckinvoicenew"))
    harga = trim(replace(replace(replace(Request.Form("hargaitem"),",",""),"-",""),".",""))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    data_cmd.commandTExt = "SELECT * FROM MKT_T_InvJulNewD WHERE LEFT(IPD_IPHID,13) = '"& iphid &"' AND IPD_Item = '"& ckinvoicenew &"'"
    set detail = data_cmd.execute
    
    if detail.eof then
      data_cmd.commandTExt = "Select ('"& iphid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(IPD_IPHID),'000'),3)))+1),3)) as id From MKT_T_InvJulNewD Where Left(IPD_IPHID,13)= '"& iphid &"'"

      set p = data_cmd.execute

      call query("INSERT INTO MKT_T_InvJulNewD (IPD_IPHID,IPD_Item,IPD_QtySatuan,IPD_Harga,IPD_JenisSat,IPD_DIsc1,IPD_DIsc2) VALUES ('"&p("id")&"', '"&ckinvoicenew&"' , "&qtty&", '"& harga &"', '"&satuan&"', "&disc1&", "&disc2&") ")

      call alert("DETAIL INVOICE CUSTOMERS", "berhasil di tambahkan", "success","invd_add.asp?id="&iphid)
    else
      call alert("DETAIL INVOICE CUSTOMERS", "sudah pernah terdaftar!!", "error","invd_add.asp?id="&iphid)
    end if

  end sub 


%>