<!--#include file="../../init.asp"-->
<%
  cabang = trim(Request.Form("cabang"))
  nama = trim(Request.Form("nama"))

  set data_cmd = Server.CreateObject("ADODB.command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_TypeBarang.T_ID HAVING  (dbo.DLK_M_Barang.Brg_Nama LIKE '%"& nama &"%') AND (LEFT(dbo.DLK_M_Barang.Brg_Id, 3) = '"& cabang &"') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T01') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T02') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T05') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T06')  ORDER BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_Barang.Brg_Nama"

  set barang = data_cmd.execute

  if not barang.eof then  
    Do Until barang.eof
%>
    <tr>
      <th scope="row"><%= barang("kategoriNama")&" - "& barang("jenisNama") %></th>
      <td><%= barang("brg_nama") %></td>
      <td><%= barang("T_Nama") %></td>
      <td>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="ckbmrdbrg" id="ckbmrdbrg" value="<%= barang("Brg_ID") %>" required>
        </div>
      </td>
    </tr>
<% 
    Response.flush
    barang.movenext
    loop
  else
%>
    <tr>
      <th class="text-center bg-danger" scope="row" colspan="4">BARANG TIDAK DI TEMUKAN!!</th>
    </tr>
<% end if%>