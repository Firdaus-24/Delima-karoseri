<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Faktur.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.*, DLK_T_OrPemH.OPH_ID, dbo.DLK_M_Vendor.Ven_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_T_OrPemH ON DLK_T_InvPemH.IPH_OPHID = DLK_T_OrPemH.OPH_ID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' get type belanja
    if data("IPH_Belanja") = 1 then
        belanja = "Harian"
    elseIf data("IPH_Belanja") = 2 then
        belanja = "Mingguan"
    elseIf data("IPH_Belanja") = 3 then
        belanja = "Tahunan"
    else    
        belanja = ""
    end if

    ' barang
    data_cmd.commandText = "SELECT Brg_Nama, Brg_ID FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' AND left(Brg_Id,3) = '"& data("IPH_AgenID") &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute

    
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
                    <input type="text" class="form-control" value="<%= data("IPH_ID") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>No Purchase Order</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("OPH_ID") %>" readonly>
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
                    <label>Vendor</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("Ven_Nama") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Metode Pembayaran</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<% call getmetpem(data("IPH_MetPem")) %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Keterangan</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IPH_Keterangan") %>" readonly>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Tanggal</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IPH_Date") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Tanggal JT</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" <% if data("IPH_JTDate") <> "1900-01-01" then %> value="<%= data("IPH_JTDate") %>" <% end if %> readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Ppn</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IPH_PPN") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Diskon All</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= data("IPH_DiskonAll") %>" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-sm-4">
                    <label>Type belanja</label>
                </div>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="<%= belanja %>" readonly>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalFakturadd">
                    Tambah Rincian
                </button>
            </div>
            <div class="p-2">
                <a href="incomming.asp" type="button" class="btn btn-danger">Kembali</a>
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
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0  

                    data_cmd.commandText = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_Nama FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID WHERE IPD_IPHID = '"& data("IPH_ID") &"' AND IPD_AktifYN = 'Y' ORDER BY DLK_M_Barang.Brg_Nama ASC"

                    set ddata = data_cmd.execute
                    do while not ddata.eof 
                    ' cek total harga 
                    jml = ddata("IPD_QtySatuan") * ddata("IPD_Harga")
                    ' cek diskon peritem
                    if ddata("IPD_Disc1") <> 0 and ddata("IPD_Disc2") <> 0  then
                        dis1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
                        dis2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")
                    elseif ddata("IPD_Disc1") <> 0 then
                        dis1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
                    elseIf ddata("IPD_Disc2") <> 0 then
                        dis2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = ddata("IPD_Harga") - dis1 - dis2
                    realharga = hargadiskon * ddata("IPD_QtySatuan")  

                    grantotal = grantotal + realharga
                    %>
                        <tr>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IPD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(ddata("IPD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("IPD_disc1") %>%
                            </td>
                            <td>
                                <%= ddata("IPD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop
                    ' ddata.movefirst
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
                        <th colspan="6">Total Pembayaran</th>
                        <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalFakturadd" tabindex="-1" aria-labelledby="modalFakturaddLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modalFakturaddLabel">Rincian Barang</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form action="fakturd_add.asp?id=<%= id %>" method="post">
            <input type="hidden" name="id" id="id" value="<%= data("IPH_ID") %>">
            <div class="row">
                <div class="col-sm-4">
                    <label for="itempo" class="col-form-label">Barang</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <select class="form-select" id="itempo" name="itempo" aria-label="Default select example" required>
                        <option value="">Pilih</option>
                        <% do while not barang.eof %>
                        <option value="<%= barang("Brg_ID") %>"><%= barang("Brg_nama") %></option>
                        <% 
                        barang.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="qttypo" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="qttypo" class="form-control" name="qttypo" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="hargapo" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="hargapo" class="form-control" name="hargapo" required>
                </div>
            </div>
            
            <div class="row">
                <div class="col-sm-4">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <select class="form-select" aria-label="Default select example" name="satuanpo" id="satuanpo" required> 
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
                <div class="col-sm-4">
                    <label for="disc1" class="col-form-label">Disc1</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="disc1" class="form-control" name="disc1" >
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="disc2" class="col-form-label">Disc2</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="disc2" class="form-control" name="disc2">
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
        call tambahDetailFaktur()
    end if
    call footer()
%>