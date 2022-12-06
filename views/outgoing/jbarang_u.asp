<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_jbarang.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvJulH.*, GLB_M_Agen.AgenName, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_InvJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvJulH.IJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_T_ProductH ON DLK_T_InvJulH.IJH_PDID = DLK_T_ProductH.PDID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_ProductH.PDBrgID = DLK_M_Barang.Brg_Id WHERE dbo.DLK_T_InvJulH.IJH_ID = '"& id &"' AND dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' cek kebutuhan
    if data("IJH_Kebutuhan") = 0 then
        kebutuhan = "Produksi"
        labelpd = data("IJH_PDID") &" | "& data("Brg_Nama")
    elseif data("IJH_Kebutuhan") = 1 then
        kebutuhan = "Khusus"
        labelpd = ""
    elseif data("IJH_Kebutuhan") = 2 then
        kebutuhan = "Umum"
        labelpd = ""
    else
        kebutuhan = "Sendiri"
        labelpd = ""
    end if

    ' ' get data stok
    ' data_cmd.commandTExt = "SELECT dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, SUM(ISNULL(dbo.DLK_T_InvPemD.IPD_QtySatuan, 0) - ISNULL(dbo.DLK_T_InvJulD.IJD_QtySatuan, 0)) AS stok FROM dbo.DLK_T_InvJulD RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvJulD.IJD_IPDIPHID = dbo.DLK_T_InvPemD.IPD_IphID LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id WHERE  (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("IJH_AgenID") &"') GROUP BY dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id ORDER BY dbo.DLK_M_Barang.Brg_Nama"
    ' ' response.write data_cmd.commandText & "<br>"
    ' set getstok = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Update Faktur Barang")
%>
<!--#include file="../../navbar.asp"-->
<style>
    .loaderjual{
        position:relative;
        width:100%;
        display: flex;
        justify-content: center;
        top: 50%;
        /* display:none; */
    }
    .loaderjual img{
        position: absolute;
        top: 50%;
        display:none; 
    }
</style>
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>No Purchase Order</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("IJH_OJHID") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Cabang</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("AgenName") %>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Kebutuhan</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= kebutuhan %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>No Produksi</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= labelpd %>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Tanggal</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= Cdate(data("IJH_Date")) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Tanggal JT</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" <% if data("IJH_JTDate") <> "1900-01-01" then %> value="<%= data("IJH_JTDate") %>" <% end if %> readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Keterangan</label>
        </div>
        <div class="col-sm-10">
            <input type="text" class="form-control" value="<%= data("IJH_Keterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modaljuald">
                    Tambah Rincian
                </button>
            </div>
            <div class="p-2">
                <a href="jbarang.asp" type="button" class="btn btn-danger">Kembali</a>
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
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Rak</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0  

                    data_cmd.commandText = "SELECT DLK_T_InvJulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama, DLK_M_Rak.Rak_Nama FROM DLK_T_InvJulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvJulD.IJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvJulD.IJD_jenissat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_InvJulD.IJD_Rakid = DLK_M_Rak.Rak_ID WHERE LEFT(IJD_IJHID,13) = '"& data("IJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

                    set ddata = data_cmd.execute
                    do while not ddata.eof 
                    ' ' cek total harga 
                    ' jml = ddata("IJD_QtySatuan") * ddata("IJD_Harga")
                    ' ' cek diskon peritem
                    ' if ddata("IJD_Disc1") <> 0 and ddata("IJD_Disc2") <> 0  then
                    '     dis1 = (ddata("IJD_Disc1")/100) * ddata("IJD_Harga")
                    '     dis2 = (ddata("IJD_Disc2")/100) * ddata("IJD_Harga")
                    ' elseif ddata("IJD_Disc1") <> 0 then
                    '     dis1 = (ddata("IJD_Disc1")/100) * ddata("IJD_Harga")
                    ' elseIf ddata("IJD_Disc2") <> 0 then
                    '     dis2 = (ddata("IJD_Disc2")/100) * ddata("IJD_Harga")
                    ' else    
                    '     dis1 = 0
                    '     dis2 = 0
                    ' end if
                    ' ' total dikon peritem
                    ' hargadiskon = ddata("IJD_Harga") - dis1 - dis2
                    ' realharga = hargadiskon * ddata("IJD_QtySatuan")  

                    ' grantotal = grantotal + realharga
                    %>
                        <tr>
                            <th>
                                <%= ddata("IJD_IJHID") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IJD_QtySatuan") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <%= ddata("Rak_Nama") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifjdbarang.asp?id=<%= ddata("IJD_IJHID") %>&p=jbarang_u" class="btn badge text-bg-danger btn-fakturd">Delete</a>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop

                    ' if data("IJH_diskonall") <> 0 OR data("IJH_Diskonall") <> "" then
                    '     diskonall = (data("IJH_Diskonall")/100) * grantotal
                    ' else
                    '     diskonall = 0
                    ' end if

                    ' ' hitung ppn
                    ' if data("IJH_ppn") <> 0 OR data("IJH_ppn") <> "" then
                    '     ppn = (data("IJH_ppn")/100) * grantotal
                    ' else
                    '     ppn = 0
                    ' end if
                    ' realgrantotal = (grantotal - diskonall) + ppn
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modaljuald" tabindex="-1" aria-labelledby="modaljualdLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modaljualdLabel">Rincian Barang</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        <form action="jbarang_u.asp?id=<%= id %>" method="post" id="rincianjual">
            <input type="hidden" name="id" id="id" value="<%= data("IJH_ID") %>">
            <input type="hidden" name="ccbgjual" id="ccbgjual" value="<%= data("IJH_AgenID") %>">
            <div class="row">
                <div class="col-sm-3">
                    <label for="cbrgjual" class="col-form-label">Cari Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="cbrgjual" class="form-control" name="cbrgjual" autocomplete="off">
                </div>
            </div>
            <div class="tablestokpo" style="height: 20em;overflow-y:auto;margin-bottom:20px">
                <table class="table">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Barang</th>
                            <th scope="col">Stok</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <div class="loaderjual">
                        <img src="<%= url %>public/img/loader.gif" width="50px">
                    </div>
                    <tbody class="contentdetailjbarang"><tbody>
                </table>
            </div>
            <input type="hidden" id="jqty" name="jqty" class="form-control" >
            <div class="row">
                <div class="col-lg-3 mb-3">
                    <label for="qtyjual" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="qtyjual" name="qtyjual" class="form-control" required>
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
        call updatePenjualan()
    end if
    call footer()
%>