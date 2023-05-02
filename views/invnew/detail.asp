<!--#include file="../../init.asp"-->
<% 
  ' if session("PR4A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvJulNewH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvJulNewH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvJulNewH.IPH_Custid = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvJulNewH.IPH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.MKT_T_InvJulNewH.IPH_ID = '"& id &"' AND dbo.MKT_T_InvJulNewH.IPH_AktifYN = 'Y'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail item
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.MKT_T_InvJulNewD.IPD_Harga, dbo.MKT_T_InvJulNewD.IPD_DIsc1, dbo.MKT_T_InvJulNewD.IPD_DIsc2, dbo.MKT_T_InvJulNewD.IPD_QtySatuan, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.MKT_T_InvJulNewD.IPD_IPHID FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.MKT_T_InvJulNewD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvJulNewD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.MKT_T_InvJulNewD.IPD_Item WHERE LEFT(dbo.MKT_T_InvJulNewD.IPD_IPHID,13) = '"& data("IPH_ID") &"' ORDER BY Brg_Nama ASC"

  set ddata = data_cmd.execute

  call header("Detail Invoice")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL INVOICE CUSTOMERS</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)%></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" class="form-control" name="lagen" id="lagen" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
        <label for="ophid" class="col-form-label">No P.O</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="lophid" name="lophid" class="form-control" value="<%= left(data("IPH_OJHID"),2) %>-<% call getAgen(mid(data("IPH_OJHID"),3,3),"") %>/<%= mid(data("IPH_OJHID"),6,4) %>/<%= right(data("IPH_OJHID"),4) %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("IPH_DAte")) %>" readonly required>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("IPH_JTDAte") <> "1900-01-01"  then%> value="<%= Cdate(data("IPH_JTDate")) %>" <% end if %> readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="cust" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
        <input type="text" id="cust" name="cust" class="form-control" value="<%= data("custnama") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ppn" class="col-form-label">PPN</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("IPH_PPN") %>"  class="form-control" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="diskon" class="col-form-label">Diskon</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("IPH_diskonALL") %>"  class="form-control" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tukar" class="col-form-label">Tukar Faktur</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="tukarY" name="tukar" <% if data("IPH_TukarYN") = "Y" then %>checked <% end if %> disabled>
        <label class="form-check-label" for="tukarY">Yes</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="tukanN" name="tukar" <% if data("IPH_TukarYN") = "N" then %>checked <% end if %> disabled>
        <label class="form-check-label" >No</label>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("IPH_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="d-flex mb-3">
      <div class="me-auto p-2">
        <% if session("MK3D") = true then %>
        <button type="button" class="btn btn-outline-primary" onclick="window.open('export-Xlsinvoice.asp?id=<%=id%>', '_self')">
          <i class="bi bi-filetype-exe"></i> Excel
        </button>
        <button type="button" class="btn btn-outline-primary" onclick="window.open('export-WRInvoice.asp?id=<%=id%>')">
          <i class="bi bi-printer"></i> Print
        </button>
        <% end if %>
      </div>
      <div class="p-2">
        <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">Kode</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Disc1</th>
            <th scope="col">Disc2</th>
            <th scope="col">Total</th>
          </tr>
        </thead>
        <tbody>
        <% 
        grantotal = 0  
        realgrantotal = 0
        total = 0
        diskon1 = 0
        diskon2 = 0 
        do while not ddata.eof 

        diskon1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
        diskon2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")

        hargadiskon = ddata("IPD_Harga") - diskon1 - diskon2
        total = hargadiskon * ddata("IPD_Qtysatuan")
        
        grantotal = grantotal + total
        %>
          <tr>
            <th>
              <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
            </th>
            <td>
              <%= ddata("Brg_Nama") %>
            </td>
            <td>
              <%= ddata("IPD_QtySatuan") %>
            </td>
            <td>
              <%= ddata("Sat_nama") %>
            </td>
            <td class="text-end">
              <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
            </td>
            <td>
              <%= ddata("IPD_Disc1") %> %
            </td>
            <td>
              <%= ddata("IPD_Disc2") %> %
            </td>
            <td class="text-end">
              <%= replace(formatCurrency(total),"$","") %>
            </td>
          </tr>
          <% 
          response.flush  
          ddata.movenext
          loop

          ' cek diskonall
          if data("IPH_diskonall") <> 0 OR data("IPH_Diskonall") <> "" then
            diskonall = (data("IPH_Diskonall")/100) * grantotal
          else
            diskonall = 0
          end if

          ' hitung ppn
          if data("IPH_ppn") <> 0 OR data("IPH_ppn") <> "" then
            ppn = (data("IPH_ppn")/100) * grantotal
          else
            ppn = 0
          end if

          realgrantotal = (grantotal - diskonall) + ppn
          %>
          <tr>
            <th colspan="7">Total Pembayaran</th>
            <th class="text-end"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>  
<% call footer() %>