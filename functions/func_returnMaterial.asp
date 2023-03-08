<% 
  sub tambahReturMaterial()

    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    produksi = trim(Request.Form("produksi"))
    keterangan = trim(Request.Form("keterangan"))
    
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_ReturnMaterialH WHERE RM_AgenID = '"& cabang &"' AND RM_PDHID = '"& produksi &"' AND RM_AktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then

      data_cmd.commandText = "exec sp_AddDLK_T_ReturnMaterialH '"& cabang &"', '"& tgl &"', '"& produksi &"', '"& session("userid") &"','', '"& keterangan &"'"

      set p = data_cmd.execute

      id = p("ID")
      call alert("TRANSAKSI RETURN MATERIAL PRODUKSI", "berhasil di tambahkan", "success","rmd_add.asp?id="&id)
    else
      call alert("TRANSAKSI RETURN MATERIAL PRODUKSI", "sudah terdaftar!!", "error","rm_add.asp")
    end if


  end sub

  sub detailRM()

  rmid = trim(Request.Form("rmid"))
  item = trim(Request.Form("item"))
  harga = trim(Request.Form("harga"))
  qtty = trim(Request.Form("qtty"))
  satuan = trim(Request.Form("satuan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_ReturnMaterialD WHERE RM_Item = '"& item &"' AND LEFT(RM_ID,13) = '"& rmid &"'"

  set data = data_cmd.execute

  if data.eof then
    data_cmd.commandTExt = "SELECT ('"& rmid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(RM_ID),'000'),3)))+1),3)) as ID FROM DLK_T_ReturnMaterialD WHERE LEFT(RM_ID,13) = '" & rmid & "'"
    ' response.write data_cmd.commandText & "<br>"
    set p = data_cmd.execute

    call query("INSERT INTO DLK_T_ReturnMaterialD ( RM_ID, RM_Item, RM_QtySatuan, RM_Harga, RM_Jenissat, RM_UpdateID ) VALUES ( '"& p("ID") &"', '"& item &"', '"& qtty &"', '"& harga &"', '"& satuan &"', '"& session("userID") &"') ")

    call alert("DETAIL TRANSAKSI RETURN MATERIAL PRODUKSI", "berhasil di tambahkan", "success","rmd_add.asp?id="&left(rmid,13))
  else
    call alert("DETAIL TRANSAKSI RETURN MATERIAL PRODUKSI", "sudah terdaftar!!", "error","rmd_add.asp?id="&left(rmid,13))
  end if


  end sub

  sub updatedetailRM()

  rmid = trim(Request.Form("rmid"))
  item = trim(Request.Form("item"))
  harga = trim(Request.Form("harga"))
  qtty = trim(Request.Form("qtty"))
  satuan = trim(Request.Form("satuan"))

  data_cmd.commandTExt = "SELECT * FROM DLK_T_ReturnMaterialD WHERE RM_Item = '"& item &"' AND LEFT(RM_ID,13) = '"& rmid &"'"

  set data = data_cmd.execute

  if data.eof then
    data_cmd.commandTExt = "SELECT ('"& rmid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(RM_ID),'000'),3)))+1),3)) as ID FROM DLK_T_ReturnMaterialD WHERE LEFT(RM_ID,13) = '" & rmid & "'"
    ' response.write data_cmd.commandText & "<br>"
    set p = data_cmd.execute

    call query("INSERT INTO DLK_T_ReturnMaterialD ( RM_ID, RM_Item, RM_QtySatuan, RM_Harga, RM_Jenissat, RM_UpdateID ) VALUES ( '"& p("ID") &"', '"& item &"', '"& qtty &"', '"& harga &"', '"& satuan &"', '"& session("userID") &"') ")

    call alert("DETAIL TRANSAKSI RETURN MATERIAL PRODUKSI", "berhasil di tambahkan", "success","rmd_u.asp?id="&left(rmid,13))
  else
    call alert("DETAIL TRANSAKSI RETURN MATERIAL PRODUKSI", "sudah terdaftar!!", "error","rmd_u.asp?id="&left(rmid,13))
  end if


  end sub
%>