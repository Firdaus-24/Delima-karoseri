<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' get data header
  data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

  set data = data_cmd.execute

  ' get data detail
  data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_M_BOMD.BMDBMID,12) = '"& data("BMID") &"' ORDER BY BMDBMID ASC"

  set ddata = data_cmd.execute

  call header("Detail Prediksi B.O.M")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12  mt-3 text-center">
      <h3>DETAIL PREDIKSI B.O.M</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center">
      <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center mb-3 labelId">
      <h3><%= left(id,2) %>-<%=mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,3) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("BMDate")) %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="cabang" class="col-form-label">Cabang</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="cabang" class="form-control" name="cabang" value="<%= data("agenName") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="barang" class="col-form-label">Barang</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="barang" class="form-control" name="barang" value="<%= data("Brg_Nama") %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="approve" class="col-form-label">Approve Y/N</label>
    </div>
    <div class="col-sm-4 mb-3">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="approve" id="approveY" value="Y" <% if data("BMApproveYN") = "Y" then%>checked <% end if %>disabled>
        <label class="form-check-label" for="approveY">Yes</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="approve" id="approveN" value="N" <% if data("BMApproveYN") = "N" then%>checked <% end if %>disabled>
        <label class="form-check-label" for="approveN" >No</label>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="drawing" class="col-form-label">No.Drawing</label>
    </div>
    <div class="col-sm-4 mb-3 drawing">
      <input type="text" class="form-control" name="drawing" id="drawing" maxlength="50" autocomplete="off" value="<%= LEft(data("BMSasisID"),5) &"-"& mid(data("BMSasisID"),6,4) &"-"& right(data("BMSasisID"),3) %>" onclick="window.open('<%=url%>views/sasis/openpdf.asp?id=CL0050003001&p=draw')" readonly>
    </div>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-4 mb-3 keterangan">
      <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" value="<%= data("BMKeterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="d-flex mb-3">
        <% 'if session("ENG2D") = true then %>
        <div class="me-auto p-2">
          <button type="button" class="btn btn-secondary" onClick="window.open('export-detailbom.asp?id=<%=id%>')" >Export</button>
        </div>
        <%' end if %>
        <div class="p-2">
          <a href="predBom.asp" class="btn btn-danger">Kembali</a>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover" style="">
        <thead class="bg-secondary text-light text-center align-middle">
          <tr>
            <th scope="col" rowspan="2">No</th>
            <th scope="col" rowspan="2">Kode</th>
            <th scope="col" rowspan="2">Item</th>
            <th scope="col" rowspan="2">Quantity</th>
            <th scope="col" rowspan="2">Satuan</th>
            <th scope="col" colspan="2">Harga</th>
          </tr>
          <tr>
            <th scope="col">inventory</th>
            <th scope="col">Purchase</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not ddata.eof 
          no = no + 1

          ' cek harga inventory
          data_cmd.commandText = "SELECT TOP 1 MR_harga FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = '"& ddata("BMDItem") &"' ORDER BY MR_Harga DESC"

          set invharga = data_cmd.execute

          ' cek harga purchase
          data_cmd.commandText = "SELECT TOP 1 IPD_Harga FROM DLK_T_InvPemD WHERE IPD_Item = '"& ddata("BMDItem") &"' ORDER BY IPD_Harga DESC"

          set pcsHarga = data_cmd.execute
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
                <%= replace(formatCurrency(invharga("MR_Harga")),"$","") %>
              </td>
              <td class="text-end">
                <%= replace(formatCurrency(pcsHarga("IPD_Harga")),"$","") %>
              </td>
            </tr>
          <% 
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>  
<% 
  call footer()
%>