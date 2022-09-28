<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_faktur.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.*, GLB_M_Agen.AgenName, DLK_M_Vendor.Ven_Nama FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_vendor ON DLK_T_InvPemH.IPH_venid = DLK_M_vendor.ven_ID where DLK_T_InvPemH.IPH_ID = '"& id &"' AND DLK_T_InvPemH.IPH_AktifYN = 'Y'"
    set data = data_cmd.execute

    ' getbarang by vendor
    data_cmd.commandText = "SELECT dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_M_Barang.Brg_Nama, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM  dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE (LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = '"& data("IPH_VenID") &"') AND EXISTS(SELECT OPD_OPHID, OPD_Item FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("IPH_OPHID") &"' AND OPD_Item = dVen_BrgID) ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute

    ' rak
    data_cmd.commandText = "SELECT Rak_Nama, rak_ID FROM DLK_M_Rak WHERE Rak_AktifYN = 'Y' AND LEFT(Rak_ID,3) = '"& data("IPH_AgenID") &"' ORDER BY Rak_Nama ASC"
    set prak = data_cmd.execute

    call header("Faktur Terhutang")
%>
<style>
    .tableufaktur .form-control{
        padding-top:0;
        padding-bottom:0;
        border:none;
        background:transparent;
    }
    .tableufaktur .form-control:focus{
        outline: none !important;
        border:none;
    }
</style>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>FORM UPDATE FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= data("IPH_ID") %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="ophid" class="col-form-label">P.O ID</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="ophid" name="ophid" class="form-control" value="<%= left(data("IPH_OPHID"),2) %>-<% call getAgen(mid(data("IPH_OPHID"),3,3),"") %>/<%= mid(data("IPH_OPHID"),6,4) %>/<%= right(data("IPH_OPHID"),4) %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("IPH_AgenID") %>" readonly>
            <input type="text" class="form-control" name="lagen" id="lagen" value="<%= data("AgenName") %>" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("IPH_Date")) %>" readonly required>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("IPH_JTDAte") <> "1900-01-01"  then%> value="<%= data("IPH_JTDate") %>" <% end if %> readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="vendor" class="col-form-label">Vendor</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="vendor" name="vendor" class="form-control" value="<%= data("ven_Nama") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("IPH_Keterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalPemD" data-bs-toggle="modal" data-bs-target="#modalPemD">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="incomming.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <!-- detail barang -->
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3">
            <table class="table table-hover tableufaktur">
                <thead class="bg-secondary text-light" style="white-space: nowrap;">
                    <tr>
                        <th>ID</th>
                        <th>Item</th>
                        <th>Quantty</th>
                        <th>Satuan Barang</th>
                        <th>Rak</th>
                        <th class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    data_cmd.commandTExt = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_InvPemD.IPD_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"'ORDER BY DLK_M_Barang.Brg_Nama ASC "

                    set ddata = data_cmd.execute
                    do while not ddata.eof %>
                    <tr>
                        <th>
                            <%= ddata("IPD_IPHID") %>
                        </th>
                        <td>
                            <%= ddata("Brg_Nama")%>
                        </td>
                        <td>
                            <%= ddata("IPD_QtySatuan") %>
                        </td>
                        <td>
                            <%= ddata("Sat_Nama") %>
                        </td>
                        <td>
                            <%= ddata("Rak_Nama") %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                            <a href="aktifd.asp?id=<%= ddata("IPD_IPHID") %>&p=faktur_u" class="btn badge text-bg-danger btn-fakturd">Delete</a>
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

<!-- Modal -->
<div class="modal fade" id="modalPemD" tabindex="-1" aria-labelledby="modalPemDLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalPemDLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="faktur_u.asp?id=<%= id %>" method="post" id="fakturd" onsubmit="validasiForm(this,event,'Proses Incomming','warning')">
    <input type="hidden" name="iphid" id="iphid" value="<%= id %>">
      <div class="modal-body">
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
                <table class="table" style="font-size:12px;">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Sepesification</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdpo">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td><%= barang("Dven_Spesification") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ckinv" id="ckinv" value="<%= barang("Dven_BrgID") %>" required>
                                </div>
                            </td>
                        </tr>
                        <% 
                        barang.movenext
                        loop
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- end table -->
        <input type="hidden" id="hargainv" class="form-control" name="hargainv" autocomplete="off" value="0" required>
        <div class="row">
            <div class="col-sm-3">
                <label for="qtty" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-6 mb-3">
                <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="satuan" class="col-form-label">Satuan Barang</label>
            </div>
            <div class="col-sm-6 mb-3">
                <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
                    <option value="">Pilih</option>
                    <% do while not psatuan.eof %>
                    <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                    <%  
                    psatuan.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="rak" class="col-form-label">Rak</label>
            </div>
            <div class="col-sm-6 mb-3">
                <select class="form-select" aria-label="Default select example" name="rak" id="rak" required> 
                    <option value="">Pilih</option>
                    <% do while not prak.eof %>
                    <option value="<%= prak("Rak_ID") %>"><%= prak("Rak_nama") %></option>
                    <%  
                    prak.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <input type="hidden" id="disc1" name="disc1" value="0" autocomplete="off" class="form-control" required>

        <input type="hidden" id="disc2" name="disc2" value="0" autocomplete="off" class="form-control" required>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </form>
    </div>
  </div>
</div>


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updateFaktur()
    end if
    call footer()
%>