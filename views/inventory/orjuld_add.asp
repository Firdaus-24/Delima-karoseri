<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, DLK_M_Customer.CustID, DLK_M_Customer.custNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrJulH.OJH_CustID = DLK_M_Customer.CustID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"
    set data = data_cmd.execute

    ' get data stok
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, sum(isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0) - isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0)) as stok, dbo.DLK_T_InvPemH.IPH_Date, isnull(dbo.DLK_T_InvJulD.IJD_IPHID,''), DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemH.IPH_ID FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_InvPemD.IPD_Item RIGHT OUTER JOIN dbo.DLK_T_InvPemH ON dbo.DLK_T_InvPemD.IPD_IphID = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvPemH.IPH_ID = dbo.DLK_T_InvJulD.IJD_IPHID where dbo.DLK_T_InvPemH.IPH_agenid = '"& data("agenID") &"' and isnull(dbo.DLK_T_InvJulD.IJD_QtySatuan,0) <  dbo.DLK_T_InvPemD.IPD_QtySatuan GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvJulD.IJD_QtySatuan, dbo.DLK_T_InvJulD.IJD_Item, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvJulD.IJD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat,dbo.DLK_T_InvPemH.IPH_ID ORDER BY  dbo.DLK_T_InvPemH.IPH_Date ASC"

    set getstok = data_cmd.execute

    ' get detail 
    data_cmd.commandText = "SELECT DLK_T_OrjulD.*, DLK_M_Barang.Brg_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID WHERE OJD_OJHID = '"& data("OJH_ID") &"' AND OJD_AktifYN = 'Y' ORDER BY DLK_M_Barang.Brg_Nama ASC"
    set dorjul = data_cmd.execute
    
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
                <label for="customer" class="col-form-label">customer</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="customer" name="customer" class="form-control" value="<%= data("custNama") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgljt" name="tgljt" class="form-control" <% if data("OJH_JTDate") <> "1900-01-01" then %> value="<%= data("OJH_JTDate") %>" <% end if %> readonly autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="metpem" name="metpem" class="form-control" value="<% call getmetpem(data("OJH_Metpem")) %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("OJH_diskonall") %>" readonly autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OJH_Ppn") %>" readonly  autocomplete="off">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
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
                        <th scope="col">Harga</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Disc1</th>
                        <th scope="col">Disc2</th>
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
                        <td><%= dorjul("OJD_Harga") %></td>
                        <td><%= dorjul("OJD_JenisSat") %></td>
                        <td><%= dorjul("OJD_Disc1") %></td>
                        <td><%= dorjul("OJD_Disc2") %></td>
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

            <table class="table">
                <thead>
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
                                <input class="form-check-input" type="radio" name="ckdorjul" id="ckdorjul" value="<%= data("OJH_ID") &","& getstok("IPH_ID") &","& getstok("Brg_ID") &","& getstok("IPD_Harga") &","& getstok("IPD_JenisSat") &","& getstok("stok") %>"  required>
                            </div>
                        </td>
                    </tr>
                    <% 
                    getstok.movenext
                    loop
                    %>
                <tbody>
            </table>
            <input type="hidden" id="fqty" name="fqty"> <!-- getstok lama -->
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
                    <label for="qtyorjul" class="col-form-label">Quantty</label>
                </div>
                <div class="col-lg-4 mb-3">
                    <input type="number" id="qtyorjul" name="qtyorjul" class="form-control" required>
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