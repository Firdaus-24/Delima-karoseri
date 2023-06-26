<%
sub updateAnggaran()
  memoid = trim(Request.Form("memoid"))
  brg = trim(Request.Form("brg"))
  spect = trim(Request.Form("spect"))
  qtty = trim(Request.Form("qtty"))
  harga = trim(Request.Form("harga"))
  satuan = trim(Request.Form("satuan"))
  ket = trim(Request.Form("ket"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' AND memoItem = '"& brg &"' "
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  if data.eof then
    ' data_cmd.commandTExt = "SELECT TOP 1 (right(memoID,3)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' order by memoID desc"
    data_cmd.commandTExt = "SELECT ('"& memoid &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(memoID),'000'),3)))+1),3)) AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"'"
    ' response.write data_cmd.commandText & "<br>"
    set p = data_cmd.execute

    ' cek harga tertinggi
    data_cmd.commandTExt = "SELECT ISNULL(MAX(Dven_Harga),0) as harga FROM DLK_T_VendorD where Dven_BrgID = '"& brg &"'"

    ' Response.Write data_cmd.commandTExt 
    set ckharga = data_cmd.execute


    call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& p("urut") &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"','"& ket &"', '"& ckharga("harga") &"')")
     
    call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success",Request.ServerVariables("HTTP_REFERER")) 
  else
    call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning",Request.ServerVariables("HTTP_REFERER"))
  end if

end sub
%>