<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_aset.asp"-->
<%  
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get cabang
    data_cmd.commandText = "SELECT dbo.DLK_T_AsetH.AsetId, dbo.DLK_T_AsetH.AsetAgenID, dbo.DLK_T_AsetH.AsetPJawab, dbo.DLK_T_AsetH.AsetKeterangan, dbo.DLK_T_AsetH.AsetUpdateID, dbo.DLK_T_AsetH.AsetUpdateTime, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Departement.DepNama, dbo.DLK_M_Divisi.DivNama, dbo.DLK_M_Divisi.DivId, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_AsetH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_AsetH.AsetPJawab = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_Divisi ON dbo.DLK_T_AsetH.AsetDivID = dbo.DLK_M_Divisi.DivId LEFT OUTER JOIN dbo.DLK_M_Departement ON dbo.DLK_T_AsetH.AsetDepID = dbo.DLK_M_Departement.DepID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_AsetH.AsetAgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_AsetH.AsetAktifYN = 'Y') AND (dbo.DLK_T_AsetH.Asetid = '"& id &"')"
    set data = data_cmd.execute

    ' get detail aset 
    data_cmd.commandTExt = "SELECT DLK_T_AsetD.*, DLK_M_BArang.Brg_Nama, DLK_M_SatuanBarang.sat_Nama, DLK_M_Rak.Rak_Nama FROM DLK_T_AsetD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_AsetD.AD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_AsetD.AD_JenisSat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_AsetD.AD_RakID = DLK_M_Rak.Rak_ID WHERE LEFT(AD_AsetID,10) = '"& data("AsetID") &"'"
    set ddata = data_cmd.execute

    ' get satuan
    data_cmd.commandTExt = "SELECT sat_Nama, sat_id FROM DLK_M_SatuanBarang WHERE sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"
    set psatuan = data_cmd.execute

call header("Form Update Detail Aset") 
%>
<style>
    .loaderaset{
        position:relative;
        width:100%;
        display: flex;
        justify-content: center;
        top: 50%;
    }
    .loaderaset img{
        position: absolute;
        top: 50%;
        display:none; 
    }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE DETAIL ASET BARANG</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row  mb-3 mt-3">
        <div class="col-sm-2">
            <label for="cabang" class="form-label">Cabang</label>
        </div>
        <div class="col-sm-5">
            <input type="text" class="form-control" name="cabang" id="cabang" value="<%= data("AgenName") %>" autocomplete="off" readonly>
        </div>
        <div class="col-sm-2">
            <label for="tgl" class="form-label">Tanggal</label>
        </div>
        <div class="col-sm-3">
            <input type="text" class="form-control" name="tgl" id="tgl" value="<%= data("AsetUpdateTime") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="divisi" class="form-label">Divisi</label>
        </div>
        <div class="col-sm-5 mb-3">
            <input type="text" class="form-control" name="divisi" id="divisi" value="<%= data("DivNama") %>" autocomplete="off" readonly>
        </div>
        <div class="col-sm-2 ">
            <label for="depAset" class="form-label">Departement</label>
        </div>
        <div class="col-sm-3">
            <input type="text" class="form-control" name="departement" id="departement" value="<%= data("DepNama") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <label for="keterangan" class="form-label">Keterangan</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" class="form-control" name="keterangan" id="keterangan" value="<%= data("asetKeterangan") %>" autocomplete="off" readonly>
        </div>
        <div class="col-sm-2">
            <label for="pJawab" class="form-label">Penanggung Jawab</label>
        </div>
        <div class="col-sm-3 mb-3">
            <input type="text" class="form-control" name="pjawab" id="pjawab" value="<%= data("username") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAset">
                    Tambah Rincian
                </button>
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
                    do while not ddata.eof 
                    %>
                        <tr>
                            <th>
                                <%= ddata("AD_AsetID") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("AD_QtySatuan") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <%= ddata("Rak_Nama") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= ddata("AD_AsetID") %>&p=aset_u" class="btn badge text-bg-danger btn-fakturd">Delete</a>
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
<div class="modal fade" id="modalAset" tabindex="-1" aria-labelledby="modalAsetLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modalAsetLabel">Rincian Aset Barang</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        <form action="aset_u.asp?id=<%= id %>" method="post" id="formaset">
            <input type="hidden" name="id" id="id" value="<%= data("asetID") %>">
            <input type="hidden" name="asetcabang" id="asetcabang" value="<%= data("AsetAgenID") %>">
            <div class="row">
                <div class="col-sm-3">
                    <label for="cbrgaset" class="col-form-label">Cari Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="cbrgaset" class="form-control" name="cbrgaset" autocomplete="off">
                </div>
            </div>
            <div class="table" style="height: 20em;overflow-y:auto;margin-bottom:20px">
                <table class="table">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Barang</th>
                            <th scope="col">Stok</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <div class="loaderaset">
                        <img src="<%= url %>public/img/loader.gif" width="50px">
                    </div>
                    <tbody class="contentdetailAset"><tbody>
                </table>
            </div>
            <input type="hidden" id="jqtyaset" name="jqtyaset" class="form-control" >
            <div class="row">
                <div class="col-lg-3 mb-3">
                    <label for="qtyaset" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="qtyaset" name="qtyaset" class="form-control" required>
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
    call updateAset()
   
end if
call footer() 
%>