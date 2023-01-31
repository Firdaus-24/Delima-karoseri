<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, DLK_M_Divisi.divID, DLK_M_Divisi.divNama, DLK_M_Departement.depID, DLK_M_Departement.depNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrJulH.OJH_DepID = DLK_M_Departement.depID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"
    set data = data_cmd.execute

    ' cek kebutuhan
    if data("OJH_Kebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif data("OJH_Kebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif data("OJH_Kebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if

    ' get stok jangan di hapus 
    ' data_cmd.commandText = "SELECT SUM(ISNULL(dbo.DLK_T_InvPemD.IPD_QtySatuan, 0) - ISNULL(dbo.DLK_T_InvJulD.IJD_QtySatuan, 0)) AS stok, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_InvPemD RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_T_InvPemH ON LEFT(DLK_T_InvPemD.IPD_IphID,13) = DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN DLK_T_InvJulD ON DLK_M_Barang.Brg_Id = DLK_T_InvJulD.IJD_Item WHERE IPH_AktifYN ='Y' AND IPH_AgenId = '"& data("OJH_AgenID") &"' GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama ORDER BY DLK_M_Barang.Brg_Nama ASC"

    ' set getstok = data_cmd.execute

    ' get barang by agen/cabang
    data_cmd.commandText = "SELECT Brg_ID,Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE Brg_AKtifYN = 'Y' AND LEFT(Brg_ID,3) = '"& data("OJH_AgenID") &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

    ' get detail 
    data_cmd.commandText = "SELECT DLK_T_OrjulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_OrjulD.OJD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"
    set dorjul = data_cmd.execute
    
    ' get satuan
    data_cmd.commandText = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama"

    set dsatuan = data_cmd.execute
    
    call header("Detail Permintaan Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL PERMINTAAN BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" value="<%= data("OJH_Date") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agenorjul" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="lagen" name="lagen" class="form-control" value="<%= data("AgenName") %>" readonly required>
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
                <input type="text" id="departement" name="departement" class="form-control" value="<%= data("depNama") %>" readonly  autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="kebutuhan" name="kebutuhan" class="form-control" value="<%= kebutuhan %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="noproduk" class="col-form-label">No Produksi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="noproduk" name="noproduk" class="form-control" value="<%= data("OJH_PDID") %>" readonly  autocomplete="off">
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
                    <button type="button" class="btn btn-primary btn-modaldetailPermintaan" data-bs-toggle="modal" data-bs-target="#modaldetailPermintaan">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="index.asp" class="btn btn-danger">Kembali</a>
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
                        <th scope="col" class="text-center">Aksi</th>
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
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= dorjul("OJD_OJHID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Delete Item Permintaan')">Delete</a>
                            </div>
                        </td>
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
<div class="modal fade" id="modaldetailPermintaan" tabindex="-1" aria-labelledby="modaldetailPermintaanLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modaldetailPermintaanLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="permintaan_u.asp?id=<%= id %>" method="post" id="rinciandetailPermintaan" onsubmit="validasiForm(this,event,'Permintaan Detail Barang','warning')">
        <input type="hidden" name="ojhid" id="ojhid" value="<%= data("OJH_ID") %>">
        <input type="hidden" name="ojhagenid" id="ojhagenid" value="<%= data("OJH_agenID") %>">
        <div class="modal-body modalBodydetailPermintaan">
            <div class="row">
                <div class="col-sm-3">
                    <label for="cporjulbarang" class="col-form-label">Cari Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="cporjulbarang" class="form-control" name="cporjulbarang" autocomplete="off">
                </div>
            </div>
            <div class="table" style="height: 20em;overflow-y:auto;margin-bottom:20px">
                <table class="table">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode Barang</th>
                            <th scope="col">Nama Barang</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody class="contentorjullama">
                        <%do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("Brg_Nama") %></td>
                            <td class="text-center">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="brg" id="brg" value="<%= barang("Brg_ID") %>" required>
                                </div>
                            </td>
                        </tr>
                        <% 
                        barang.movenext
                        loop
                        %>
                    </tbody>
                    <tbody class="contentOrjulbarang">
                    </tbody>
                </table>
            </div>
            <div class="row">
                <div class="col-lg-2 mb-3">
                    <label for="qtty" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-10 mb-3">
                    <input type="number" id="qtty" name="qtty" class="form-control" autocomplete="off" required>
                </div>
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
        call updatedetailOrjul()
    end if
    
    call footer()
%>
