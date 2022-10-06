<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, DLK_M_Divisi.divID, DLK_M_Divisi.divNama, DLK_M_Departement.depID, DLK_M_Departement.depNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrJulH.OJH_DepID = DLK_M_Departement.depID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"
    set data = data_cmd.execute
    ' get data stok
    ' data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_AktifYN, isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) as stok, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemD.IPD_IphID FROM  dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulD.IJD_IPDIPHID = dbo.DLK_T_InvPemD.IPD_IphID LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) > isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) AND dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("OJH_AgenID") &"' AND isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) > 0 OR isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) <> 0 ORDER BY dbo.DLK_T_InvPemH.IPH_Date"

    data_cmd.commandText = "SELECT SUM(ISNULL(dbo.DLK_T_InvPemD.IPD_QtySatuan, 0) - ISNULL(dbo.DLK_T_InvJulD.IJD_QtySatuan, 0)) AS stok, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_InvPemD RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_T_InvPemH ON LEFT(DLK_T_InvPemD.IPD_IphID,13) = DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN DLK_T_InvJulD ON DLK_M_Barang.Brg_Id = DLK_T_InvJulD.IJD_Item WHERE IPH_AktifYN ='Y' AND IPH_AgenId = '"& data("OJH_AgenID") &"' GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set getstok = data_cmd.execute

    ' get detail 
    data_cmd.commandText = "SELECT DLK_T_OrjulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_OrjulD.OJD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"
    set dorjul = data_cmd.execute
    
    ' get satuan
    data_cmd.commandText = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama"

    set dsatuan = data_cmd.execute
    
    call header("Detail OrderJual")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL ORDER PENJUALAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agenorjul" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="agenorjul" name="agenorjul" value="<%= data("AgenID") %>" class="form-control" required>
                <input type="text" id="lagen" name="lagen" class="form-control" value="<%= data("AgenName") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" value="<%= data("OJH_Date") %>" readonly required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="divisi" class="col-form-label">Divisi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="divisi" name="divisi" class="form-control" value="<%= data("divNama") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="departement" class="col-form-label">Departement</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="departement" name="departement" class="form-control" value="<%= data("depNama") %>" readonly  autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OJH_Keterangan") %>" readonly autocomplete="off">
            </div>
        </div>    
    </div>  
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalOrjul" data-bs-toggle="modal" data-bs-target="#modalOrjul">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="outgoing.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Quantty</th>
                        <th scope="col">Satuan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    no = 0
                    do while not dorjul.eof
                    no = no + 1
                    %>
                    <tr>
                        <th scope="row"><%= no %></th>
                        <td><%= dorjul("Brg_Nama") %></td>
                        <td><%= dorjul("OJD_QtySatuan") %></td>
                        <td><%= dorjul("Sat_Nama") %></td>
                    </tr>
                    <% 
                    dorjul.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div>  
</div>  
<!-- Modal -->
<div class="modal fade" id="modalOrjul" tabindex="-1" aria-labelledby="modalOrjulLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalOrjulLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="orjuld_add.asp?id=<%= id %>" method="post" id="rincianOrjul">
        <div class="modal-body modalBodyOrjul">
            <div class="tablestokpo" style="height: 20em;overflow-y:auto;margin-bottom:20px">
                <table class="table">
                    <thead class="bg-secondary text-light">
                        <tr>
                            <th scope="col">Barang</th>
                            <!-- 
                            <th scope="col">Stok</th>
                             -->
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%do while not getstok.eof %>
                        <tr>
                            <td><%= getstok("Brg_Nama") %></td>
                            <!-- 
                            <td><%= getstok("stok") %></td>
                             -->
                            <td class="text-center">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="ckdorjul" id="ckdorjul" value="<%= data("OJH_ID") &","& getstok("Brg_ID") &","& getstok("stok") %>"  required>
                                </div>
                            </td>
                        </tr>
                        <% 
                        getstok.movenext
                        loop
                        %>
                    <tbody>
                </table>
            </div>
            <!-- getstok lama -->
            <!-- 
            <input type="hidden" id="fqty" name="fqty">  -->
            
            <div class="row">
                <div class="col-lg-2 mb-3">
                    <label for="qtyorjul" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-10 mb-3">
                    <input type="number" id="qtyorjul" name="qtyorjul" class="form-control" required>
                </div>
                <!-- set agen -->
                    <input type="hidden" id="agen" name="agen" class="form-control" value="<%= data("OJH_AgenID") %>" required>
            </div>  
            <div class="row">
                <div class="col-lg-2 mb-3">
                    <label for="satuan" class="col-form-label">Satuan</label>
                </div>
                <div class="col-lg-10 mb-3">
                    <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required>
                        <option value="">Pilih</option>
                        <% do while not dsatuan.eof %>
                        <option value="<%= dsatuan("sat_ID") %>"><%= dsatuan("sat_Nama") %></option>
                        <% 
                        dsatuan.movenext
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
        call detailOrjul()
    end if
    
    call footer()
%>
<script src="../../public/js/outgoing.js"></script>