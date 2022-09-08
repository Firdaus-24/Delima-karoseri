<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_jbarang.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvJulH.*, DLK_T_OrJulH.OJH_ID, dbo.DLK_M_Customer.CustNama, GLB_M_Agen.AgenName FROM dbo.DLK_T_InvJulH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_InvJulH.IJH_CustID = dbo.DLK_M_Customer.CustID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvJulH.IJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_T_OrJulH ON DLK_T_InvJulH.IJH_OJHID = DLK_T_OrJulH.OJH_ID WHERE dbo.DLK_T_InvJulH.IJH_ID = '"& id &"' AND dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' get type jual
    if data("IJH_jual") = 1 then
        jual = "Harian"
    elseIf data("IJH_jual") = 2 then
        jual = "Mingguan"
    elseIf data("IJH_jual") = 3 then
        jual = "Tahunan"
    else    
        jual = ""
    end if

    ' get data stok
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_AktifYN, isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) as stok, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemD.IPD_IphID FROM  dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulD.IJD_IPDIPHID = dbo.DLK_T_InvPemD.IPD_IphID LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) > isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) AND dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("IJH_AgenID") &"' AND isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) > 0 OR isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) <> 0 ORDER BY dbo.DLK_T_InvPemH.IPH_Date"

    set getstok = data_cmd.execute

    
    call header("Faktur Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>No Faktur</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IJH_ID") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>No Purchase Order</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("OJH_ID") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Cabang</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("AgenName") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Customer</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("CustNama") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Metode Pembayaran</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<% call getmetpem(data("IJH_MetPem")) %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Keterangan</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IJH_Keterangan") %>" readonly>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Tanggal</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= Cdate(data("IJH_Date")) %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Tanggal JT</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" <% if data("IJH_JTDate") <> "1900-01-01" then %> value="<%= data("IJH_JTDate") %>" <% end if %> readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Ppn</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IJH_PPN") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Diskon All</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IJH_DiskonAll") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Type jual</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= jual %>" readonly>
                </div>
            </div>
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
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Diskon1</th>
                        <th scope="col">Diskon2</th>
                        <th scope="col">Jumlah</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0  

                    data_cmd.commandText = "SELECT DLK_T_InvJulD.*, DLK_M_Barang.Brg_Nama FROM DLK_T_InvJulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvJulD.IJD_Item = DLK_M_Barang.Brg_ID WHERE LEFT(IJD_IJHID,13) = '"& data("IJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

                    set ddata = data_cmd.execute
                    do while not ddata.eof 
                    ' cek total harga 
                    jml = ddata("IJD_QtySatuan") * ddata("IJD_Harga")
                    ' cek diskon peritem
                    if ddata("IJD_Disc1") <> 0 and ddata("IJD_Disc2") <> 0  then
                        dis1 = (ddata("IJD_Disc1")/100) * ddata("IJD_Harga")
                        dis2 = (ddata("IJD_Disc2")/100) * ddata("IJD_Harga")
                    elseif ddata("IJD_Disc1") <> 0 then
                        dis1 = (ddata("IJD_Disc1")/100) * ddata("IJD_Harga")
                    elseIf ddata("IJD_Disc2") <> 0 then
                        dis2 = (ddata("IJD_Disc2")/100) * ddata("IJD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = ddata("IJD_Harga") - dis1 - dis2
                    realharga = hargadiskon * ddata("IJD_QtySatuan")  

                    grantotal = grantotal + realharga
                    %>
                        <tr>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IJD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(ddata("IJD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("IJD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("IJD_disc1") %>%
                            </td>
                            <td>
                                <%= ddata("IJD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= ddata("IJD_IJHID") %>&p=fakturd_add" class="btn badge text-bg-danger btn-fakturd">Delete</a>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop
                    ' ddata.movefirst
                    ' cek diskonall
                    if data("IJH_diskonall") <> 0 OR data("IJH_Diskonall") <> "" then
                        diskonall = (data("IJH_Diskonall")/100) * grantotal
                    else
                        diskonall = 0
                    end if

                    ' hitung ppn
                    if data("IJH_ppn") <> 0 OR data("IJH_ppn") <> "" then
                        ppn = (data("IJH_ppn")/100) * grantotal
                    else
                        ppn = 0
                    end if
                    realgrantotal = (grantotal - diskonall) + ppn
                    %>
                    <tr>
                        <th colspan="6">Total Pembayaran</th>
                        <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
                    </tr>
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
            <form action="jbarangd_add.asp?id=<%= id %>" method="post" id="rincianjual">
            <input type="hidden" name="id" id="id" value="<%= data("IJH_ID") %>">
            <div class="tablestokpo" style="height: 20em;overflow-y:auto;margin-bottom:20px">
                <table class="table">
                    <thead class="bg-secondary text-light">
                        <tr>
                            <th scope="col">Tanggal</th>
                            <th scope="col">Barang</th>
                            <th scope="col">Stok</th>
                            <th scope="col">Harga</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%do while not getstok.eof %>
                        <tr>
                            <th scope="row"><%= Cdate(getstok("IPH_Date")) %></th>
                            <td><%= getstok("Brg_Nama") %></td>
                            <td><%= getstok("stok") %></td>
                            <td><%= replace(formatCurrency(getstok("IPD_Harga")),"$","") %></td>
                            <td class="text-center">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="ckpenjualan" id="ckpenjualan" value="<%= data("OJH_ID") &","& getstok("IPD_IPHID") &","& getstok("Brg_ID") &","& getstok("IPD_Harga") &","& getstok("IPD_JenisSat") &","& getstok("stok") %>"  required>
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
            <input type="hidden" id="jqty" name="jqty"> <!-- getstok lama -->
            <div class="row">
                <div class="col-lg-2 mb-3">
                    <label for="disc1" class="col-form-label">Disc1</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="disc1" name="disc1" class="form-control">
                </div>
                <div class="col-lg-2 mb-3">
                    <label for="disc2" class="col-form-label">Disc2</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="disc2" name="disc2" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-2 mb-3">
                    <label for="qtyjual" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="qtyjual" name="qtyjual" class="form-control" required>
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
        call tambahDetailPenjualan()
    end if
    call footer()
%>