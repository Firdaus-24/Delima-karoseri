<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Produksi.asp"--> 
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductH.*, dbo.DLK_M_Barang.Brg_Nama, GL_M_CategoryItem.cat_name, GLB_M_Agen.AgenName FROM dbo.DLK_T_ProductH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductH.PDBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GL_M_CategoryItem ON DLK_T_ProductH.PDKodeAKun = GL_M_CategoryItem.cat_id LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProductH.pdAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_ProductH.pdID = '"& id &"' AND dbo.DLK_T_ProductH.pdAktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_ProductD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_ProductD.PDDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductD.PDDItem = dbo.DLK_M_Barang.Brg_Id WHERE LEFT(dbo.DLK_T_ProductD.PDDPDID,12) = '"& data("PDID") &"' ORDER BY PDDPDID ASC"

    set ddata = data_cmd.execute

    ' getbarang 
    data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& data("PDBrgID") &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

    ' get jenis satuan
    data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Detail Product")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12  mt-3 text-center">
            <h3>DETAIL BARANG PRODUKSI</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center mb-3 labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("PDDate")) %>" readonly>
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
            <label for="kdakun" class="col-form-label">Kode Akun</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="kdakun" class="form-control" name="kdakun" value="<%= data("cat_name") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalProductd" data-bs-toggle="modal" data-bs-target="#modalProductd">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="produksi.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Item</th>
                        <th scope="col">Sepesification</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    do while not ddata.eof 
                    %>
                        <tr>
                            <th>
                                <%= ddata("PDDPDID") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("PDDSpect") %>
                            </td>
                            <td>
                                <%= ddata("PDDQtty") %>
                            </td>
                            <td>
                                <%= ddata("sat_nama") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                    <a href="aktifprod.asp?id=<%= ddata("PDDPDID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'delete detail produksi')">Delete</a>
                                </div>
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
<div class="modal fade" id="modalProductd" tabindex="-1" aria-labelledby="modalProductdLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalProductdLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="product_u.asp?id=<%= id %>" method="post" id="formproductd" onsubmit="validasiForm(this,event,'Detail Barang Produksi','warning')">
    <input type="hidden" name="pdid" id="pdid" value="<%= id %>">
      <div class="modal-body">
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
                <table class="table" style="font-size:12px;">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdpo">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ckproduckd" id="ckproduckd" value="<%= barang("Brg_ID") %>" required>
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
        <div class="row">
            <div class="col-sm-3">
                <label for="spect" class="col-form-label">Sepesification</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="spect" class="form-control" name="spect" maxlength="50" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="qtty" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="satuan" class="col-form-label">Satuan Barang</label>
            </div>
            <div class="col-sm-4 mb-3">
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

      </div>
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
        call updateProduksi()
    end if
    call footer()
%>