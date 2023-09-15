<!--#include file="../../init.asp"-->
<%
  idmo  = trim(Request.Form("idmo"))
  id  = trim(Request.Form("id"))
  tpout  = trim(Request.Form("tpout"))
  ' Response.Write id
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' detail bom by nomor produksi
  if tpout = "R" then
    strquerybarang = "SELECT (dbo.DLK_T_BOMRepairD.BmrdQtysatuan) AS qty, dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_T_BOMRepairD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMRepairD.BmrdSatID = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID INNER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID ON dbo.DLK_T_BOMRepairD.BmrdBrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_T_BOMRepairH ON LEFT(dbo.DLK_T_BOMRepairD.BmrdID, 13) = dbo.DLK_T_BOMRepairH.BmrID WHERE (dbo.DLK_T_BOMRepairH.BmrAktifYN = 'Y') AND (dbo.DLK_T_BOMRepairH.BmrPDRID = '"& id &"') ORDER BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_Barang.Brg_Nama"
  elseIf tpout = "P" then
    strquerybarang = "SELECT dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, (dbo.DLK_M_BOMD.BMDQtty) as qty FROM dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID RIGHT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID INNER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMD.BMDItem LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_M_BOMD.BMDJenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_BOMH.BMID = LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) WHERE (dbo.DLK_M_BOMH.BMApproveYN = 'Y') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_T_ProduksiD.PDD_ID = '"& id &"') ORDER BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_Barang.Brg_Nama"
  else
    strquerybarang = ""
  end if

  data_cmd.commandTExt = strquerybarang
  set barang = data_cmd.execute
%>

<% if not barang.eof then%>
  <table class="table table-hover table-bordered" style="font-size:12px;">
    <thead class="bg-secondary text-light">
      <tr>
        <th scope="col">Kode</th>
        <th scope="col">Item</th>
        <th scope="col">Quantity</th>
        <th scope="col">Satuan</th>
        <th scope="col">Type</th>
      </tr>
    </thead>
    <tbody>
    <% 
    do while not barang.eof 

    ' cek data yang sudah di keluarkan
    data_cmd.commandTExt = "SELECT ISNULL(SUM(MO_Qtysatuan),0) as total FROM DLK_T_MaterialOutD where MO_Item = '"& barang("Brg_ID") &"' AND MO_ID = '"& idmo &"' GROUP BY MO_Item "
    ' Response.Write data_cmd.commandTExt
    set ckdataout = data_cmd.execute

    if not ckdataout.eof then
      if Cint(barang("qty")) < Cint(ckdataout("total")) then
        strbg = "bg-danger"
      else
        strbg = "bg-info"
      end if
    else  
      strbg = ""
      cktotal = 0
    end if
    %>
      <tr class=<%=strbg%>>
        <th>
          <%= barang("KategoriNama") &"-"& barang("jenisNama") %>
        </th>
        <td>
          <%= barang("Brg_Nama") %>
        </td>
        <td>
          <%= barang("qty") %>
        </td>
        <td>
          <%= barang("Sat_nama") %>
        </td>
        <td>
          <%= barang("T_nama") %>
        </td>
      </tr>
    <% 
    response.flush
    barang.movenext
    loop
    %>
    </tbody>
  </table>
<%else%>
  <div class='text-center bg-warning text-light'>
  <h4>NOMOR B.O.M BELUM TERDAFTAR </h4>
  </div>
<%end if%>