<!--#include file="../../init.asp"-->
<% 
  if session("ENG7D") = false then
    Response.Redirect("../index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' get data header
  data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

  set data = data_cmd.execute

  ' get data detail
  data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_M_BOMD.BMDBMID,12) = '"& data("BMID") &"' ORDER BY BMDBMID ASC"

  set ddata = data_cmd.execute
  
  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=Prediksi Harga BOM ID "& left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4)&"/"& right(id,3) &" .xls"
%>

<table width="100%">
  <tr>
    <th colspan="9" style="text-align:center">
      DETAIL PREDIKSI HARGA B.O.M
    </th>
  </tr>
  <tr rowspan="2"> 
    <th colspan="9" style="text-align:center;overflow:hidden">
      <img src="https://www.barcodesinc.com/generator/image.php?code=<%= id %>&style=90&type=C128B&width=80&height=30&xres=1&font=3" class="qr-code img-thumbnail img-responsive" />
    </th>
  </tr>
  <tr>
    <th colspan="9" style="text-align:center;color:green">
      <%= left(id,2) %>-<%=mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,3) %>
    </th>
  </tr>
  <tr>
    <td colspan="9" style="text-align:center">
      &nbsp
    </td>
  </tr>

  <!-- detail header -->
  <tr>
    <td colspan="2">
      Tanggal
    </td>
    <td colspan="2">
      : <%= Cdate(data("BMDate")) %>
    </td>
    <td colspan="2">
      Cabang
    </td>
    <td colspan="3">
      : <%= data("agenName") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Item
    </td>
    <td colspan="2">
      : <%= data("Brg_Nama") %>
    </td>
    <td colspan="2">
      Approve Y/N
    </td>
    <td colspan="3">
      : <%= data("BMApproveYN") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      No.Drawing
    </td>
    <td colspan="2">
      : <a href="<%=url%>views/sasis/openpdf.asp?id=CL0050003001&p=draw" style="cursor:pointer;text-decoration:none;color:black" target="blank"><%= LEft(data("BMSasisID"),5) &"-"& mid(data("BMSasisID"),6,4) &"-"& right(data("BMSasisID"),3) %></a>
    </td>
    <td colspan="2">
      Keterangan
    </td>
    <td colspan="3">
      : <%= data("BMKeterangan") %>
    </td>
  </tr>
  <tr>
    <td colspan="9" style="text-align:center">
      &nbsp
    </td>
  </tr>

  <!-- table detail -->
  <tr>
    <th scope="col" rowspan="2">No</th>
    <th scope="col" rowspan="2">Kode</th>
    <th scope="col" rowspan="2">Item</th>
    <th scope="col" rowspan="2">Quantity</th>
    <th scope="col" rowspan="2">Satuan</th>
    <th scope="col" colspan="2">Harga Satuan</th>
    <th scope="col" colspan="2">Total Harga</th>
  </tr>
  <tr>
    <th scope="col">inventory</th>
    <th scope="col">Purchase</th>
    <th scope="col">inventory</th>
    <th scope="col">Purchase</th>
  </tr>
  <% 
  no = 0
  totalinv = 0
  totalpcs = 0
  do while not ddata.eof 
  no = no + 1

  ' cek harga inventory
  data_cmd.commandText = "SELECT TOP 1 MR_harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = '"& ddata("BMDItem") &"' ORDER BY MR_Harga DESC"

  set invharga = data_cmd.execute

  if not invharga.eof then  
    hargainventory = invharga("MR_Harga")
  else
    hargainventory = 0
  end if

  ' cek harga purchase
  data_cmd.commandText = "SELECT TOP 1 IPD_Harga FROM DLK_T_InvPemD WHERE IPD_Item = '"& ddata("BMDItem") &"' ORDER BY IPD_Harga DESC"

  set pcsHarga = data_cmd.execute

  if not pcsHarga.eof then
    hargapurchase = pcsHarga("IPD_Harga")
  else
    hargapurchase = 0
  end if

  ' total harga 
  tinv = hargainventory * Cint(ddata("BMDQtty"))
  tpcs = hargapurchase * Cint(ddata("BMDQtty"))
  %>
    <tr>
      <th>
        <%= no %>
      </th>
      <td>
        <%= ddata("kategoriNama") &"-"& ddata("JenisNama") %>
      </td>
      <td>
        <%= ddata("Brg_Nama") %>
      </td>
      <td>
        <%= ddata("BMDQtty") %>
      </td>
      <td>
        <%= ddata("sat_nama") %>
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(hargainventory),"$","") %>
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(hargapurchase),"$","") %>
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(tinv),"$","") %>
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(tpcs),"$","") %>
      </td>
    </tr>
  <% 
  totalinv = totalinv + tinv
  totalpcs = totalpcs + tpcs
  ddata.movenext
  loop
  %>
    <tr>
      <td colspan="7">
        Total
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(totalinv),"$","") %>
      </td>
      <td class="text-end">
        <%= replace(formatCurrency(totalpcs),"$","") %>
      </td>
    </tr>
</table>
