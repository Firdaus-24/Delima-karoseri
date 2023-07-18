<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_serahterimaunit.asp"-->
<% 
  if session("MQ2B") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT DLK_T_UnitCustomerH.*,  DLK_M_Customer.custNama, DLK_M_Weblogin.username FROM DLK_T_UnitCustomerH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_UnitCustomerH.TFK_Custid = DLK_M_Customer.custid LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_UnitCustomerH.TFK_UpdateID = DLK_M_WebLogin.userid WHERE TFK_ID = '"& id &"' AND TFK_AktifYN = 'Y'"

  set data = data_cmd.execute

  ' data detail1
  data_cmd.commandText = "SELECT dbo.DLK_T_UnitCustomerD1.*, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_UnitCustomerD1 LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_UnitCustomerD1.TFK_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE LEFT(TFK_ID,17) = '"& data("TFK_ID") &"'"
  ' response.write data_cmd.commandtext & "<br>"
  set ddata = data_cmd.execute

  ' brand
  data_cmd.commandText = "SELECT BrandID, BrandName FROM DLK_M_Brand WHERE BrandAktifYN = 'Y' ORDER BY BrandName"

  set databrand = data_cmd.execute

  call header("Upate Serah Terima")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 text-center">
      <h3>FROM TAMBAH KEDATANGAN UNIT</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 mb-3 text-center labelId">
      <h3><%= LEFT(data("TFK_ID"),11) &"/"& MID(data("TFK_ID"),12,4) &"/"& Right(data("TFK_ID"),2) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="ltgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="ltgl" name="ltgl" value="<%= Cdate(data("TFK_Date")) %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-2">
        <label for="salesorder" class="col-form-label">Jenis Unit</label>
      </div>
      <div class="col-lg-4 mb-2">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="jenisUnit" id="baru" value="1" <% if data("TFK_Jenis") = 1 then%>checked <% end if %> disabled>
          <label class="form-check-label" for="baru">Baru</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="jenisUnit" id="repair" value="2" <% if data("TFK_Jenis") = 2 then%>checked <% end if %> disabled>
          <label class="form-check-label" for="repair">Repair</label>
        </div>
      </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="salesorder" class="col-form-label">Sales Order</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="salesorder" name="salesorder" class="form-control" value="<%= left(data("TFK_OJHORHID") ,2)%>-<%=  mid(data("TFK_OJHORHID") ,3,3)%>/<%= mid(data("TFK_OJHORHID") ,6,4) %>/<%= right(data("TFK_OJHORHID"),4) %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="customer" name="customer" class="form-control" value="<%= data("CustNama") %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="penerima" class="col-form-label">Penerima</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="penerima" name="penerima" class="form-control" maxlength="50" value="<%= data("TFK_Penerima") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="penyerah" class="col-form-label">Penyerah</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="penyerah" name="penyerah" class="form-control" maxlength="50" value="<%= data("TFK_penyerah") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("TFK_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3">
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mt-3">
      <table class="table ">
        <thead class="table-primary">
          <tr>
            <th scope="col">Tanggal Kedatangan</th>
            <th scope="col">Merk</th>
            <th scope="col">Type</th>
            <th scope="col">No.Polisi</th>
            <th scope="col">No.Rangka</th>
            <th scope="col">No.Mesin</th>
            <th scope="col">Color</th>
            <th scope="col">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% do while not ddata.eof 
          %>
          <tr>
            <td>
              <%= Cdate(ddata("TFK_Date")) %>
            </td>
            <td>
             <%= ddata("BrandName") %>
            </td>
            <td>
              <%= ddata("TFK_Type") %>
            </td>
            <td>
            <%= ddata("TFK_nopol") %>
            </td>
            <td>
              <%= ddata("TFK_norangka") %>
            </td>
            <td>
              <%= ddata("TFK_Nomesin") %>
            </td>
            <td>
              <%= ddata("TFK_Color") %>
            </td>
            <td>
              
                <button type="bottom" class="btn btn-light btn-sm" onclick="window.location.href='detailD1.asp?id=<%=ddata("TFK_ID")%>&p=tfkd_u'">Detail</button>
            </td>
          </tr>
          <% 
          response.flush
          ddata.movenext
          loop
          %>

          <!-- form tambah d1 -->
          <form action="tfkd_u.asp?id=<%= data("TFK_ID") %>" method="post" onsubmit="validasiForm(this,event,'DETAIL UNIT CUSTOMER','warning')">
          <tr>
            <td>
              <input type="hidden" id="filetype" class="form-control" name="filetype" value="tfkd_u" required>
              <input type="hidden" id="idtfk" class="form-control" name="idtfk" value="<%= data("TFK_ID") %>" required>
              <input type="date" id="tgltfkd" class="form-control" name="tgl" required>
            </td>
            <td>
              <select class="form-select"  name="textmerek" id="textmerek" required>
                <option value="">Pilih</option>
                <% do while not databrand.eof %>
                <option value="<%= databrand("BrandID") %>"><%= databrand("brandName") %></option>
                <% 
                response.flush
                databrand.movenext
                loop
                %>
              </select>
            </td>
            <td>
              <input type="text" id="type" class="form-control" name="type" maxlength="20" required>
            </td>
            <td>
              <input type="text" id="polisi" class="form-control" name="polisi" maxlength="10" required>
            </td>
            <td>
              <input type="text" id="rangka" class="form-control" name="rangka" maxlength="20" required>
            </td>
            <td>
              <input type="text" id="mesin" class="form-control" name="mesin" maxlength="20" required>
            </td>
            <td>
              <input type="text" id="warna" class="form-control" name="warna" maxlength="10" required>
            </td>
            <td>
              <button type="submit" class="btn btn-primary btn-sm">Save</button>
            </td>
          </tr>
          </form>
        </tbody>
      </table>
    </div>
  </div>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    call detailSerahTerima()
  end if

call footer() %>
<script>

</script>