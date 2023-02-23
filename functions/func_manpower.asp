<% 
sub ManpowerH()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    produksi = trim(Request.Form("produksi"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ManpowerH WHERE MP_AgenID = '"& agen &"' AND MP_PDHID = '"& produksi &"' AND MP_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddDLK_T_ManPowerH '"& produksi &"','"& agen &"','"& tgl &"', '"& session("userid") &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      value = 1 'case untuk insert data
    else
      value = 2 'case jika gagal insert 
    end if
    
    if value = 1 then
      call alert("TRANSAKSI MANPOWER", "berhasil di tambahkan", "success","mpd_add.asp?id="&id) 
    elseif value = 2 then
      call alert("TRANSAKSI MANPOWER", "sudah terdaftar", "warning","mp_add.asp")
    else
      value = 0
    end if

end sub

sub tambahOrjulD()
  id = trim(Request.Form("id"))
  itemSo = trim(Request.Form("itemSo"))
  qty = trim(Request.Form("qty"))
  satuan = trim(Request.Form("satuan"))
  harga = trim(Request.Form("harga"))
  diskon = trim(Request.Form("diskon"))
  keterangan = trim(Request.Form("keterangan"))
  
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID, 13) = '"& id &"' AND OJD_item = '"& itemSo &"'"
  ' response.write data_cmd.commandText & "<br>"
  set orjul = data_cmd.execute

  if orjul.eof then
    data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(OJD_OJHID),'000'),3)))+1),3)) as id From DLK_T_OrjulD Where Left(OJD_OJHID,13) = '"& id &"'"

    set a = data_cmd.execute

    call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID, OJD_Item,OJD_Qtysatuan, OJD_JenisSat,OJD_Harga,OJD_Diskon,OJD_Keterangan,OJD_Updatetime,OJD_Updateid) VALUES ('"& a("id") &"','"& itemSo &"', "& qty &",'"& satuan &"','"& harga &"','"& diskon &"','"& keterangan &"','"& now &"','"& session("userid") &"')")

    value = 1 'case untuk insert data
  else
    value = 2 'case jika gagal insert 
  end if

  if value = 1 then
    call alert("DETAIL SALES ORDER", "berhasil di tambahkan", "success","sod_add.asp?id="&id) 
  elseif value = 2 then
    call alert("DETAIL SALES ORDER", "sudah terdaftar", "warning","sod_add.asp?id="&id)
  else
    value = 0
  end if
end sub

    sub updatedetailOrjul()
        id = trim(Request.Form("id"))
        itemSo = trim(Request.Form("itemSo"))
        qty = trim(Request.Form("qty"))
        satuan = trim(Request.Form("satuan"))
        harga = trim(Request.Form("harga"))
        diskon = trim(Request.Form("diskon"))
        keterangan = trim(Request.Form("keterangan"))
        
        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandText = "SELECT * FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID, 13) = '"& id &"' AND OJD_item = '"& itemSo &"'"
        ' response.write data_cmd.commandText & "<br>"
        set orjul = data_cmd.execute

        if orjul.eof then
            data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(OJD_OJHID),'000'),3)))+1),3)) as id From DLK_T_OrjulD Where Left(OJD_OJHID,13) = '"& id &"'"

            set a = data_cmd.execute

            call query ("INSERT INTO DLK_T_OrjulD (OJD_OJHID, OJD_Item,OJD_Qtysatuan, OJD_JenisSat,OJD_Harga,OJD_Diskon,OJD_Keterangan,OJD_Updatetime,OJD_Updateid) VALUES ('"& a("id") &"','"& itemSo &"', "& qty &",'"& satuan &"','"& harga &"','"& diskon &"','"& keterangan &"','"& now &"','"& session("userid") &"')")

            value = 1 'case untuk insert data
        else
            value = 2 'case jika gagal insert 
        end if

        if value = 1 then
            call alert("DETAIL SALES ORDER", "berhasil di tambahkan", "success","so_u.asp?id="&id) 
        elseif value = 2 then
            call alert("DETAIL SALES ORDER", "sudah terdaftar", "warning","so_u.asp?id="&id)
        else
            value = 0
        end if
    end sub


%>