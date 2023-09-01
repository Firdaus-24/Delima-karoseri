<!--#include file="../../init.asp"-->
<%
  nama = trim(Request.Form("nama"))

  if nama <> "" then
    filternama = "AND DLK_M_Barang.Brg_Nama LIKE '%"& nama &"%'"
  else
    filternama = ""
  end if

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' barang
  data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_id, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM   dbo.DLK_M_TypeBarang RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_TypeBarang.T_ID = dbo.DLK_M_Barang.Brg_Type LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') "& filternama &" ORDER BY brg_Nama, T_nama ASC"
  ' Response.Write data_cmd.commandTExt 
  set barang = data_cmd.execute

  do while not barang.eof
%>
<tr>
  <td><%=barang("kategoriNama")%></td>
  <td><%=barang("JenisNama")%></td>
  <td><%=barang("Brg_Nama")%></td>
  <td><%=barang("T_Nama")%></td>
  <td><input class="form-check-input" type="radio" name="ckbrgvoucherPBarang" id="ckbrgvoucherPBarang" value="<%=barang("brg_id")%>" required></td>
</tr>

<%
  Response.flush
  barang.movenext
  loop
%>
