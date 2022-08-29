<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_faktur.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ophID, dbo.DLK_T_InvPemH.IPH_AgenID, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_venID, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan,dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_PPn, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_MetPem, dbo.DLK_T_InvPemD.IPD_IPHID,dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_AktifYN, DLK_M_Barang.Brg_Nama, DLK_T_InvPemH.IPH_belanja FROM dbo.DLK_T_InvPemH INNER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = dbo.DLK_T_InvPemD.IPD_IPHID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID where DLK_T_InvPemH.IPH_ID = '"& id &"' AND DLK_T_InvPemH.IPH_AktifYN = 'Y' AND DLK_T_InvPemD.IPD_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ophID, dbo.DLK_T_InvPemH.IPH_AgenID, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_venID, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan,dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_PPn, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_MetPem, dbo.DLK_T_InvPemD.IPD_IPHID,dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_AktifYN,DLK_M_Barang.Brg_Nama,DLK_T_InvPemH.IPH_belanja"

    set data = data_cmd.execute

    ' barang
    data_cmd.commandText = "SELECT Brg_Nama, Brg_ID FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' AND LEFT(brg_ID,3) = '"& data("IPH_AgenID") &"' ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute
    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    ' cek type belanja
    if data("IPH_belanja") = 1 then 
        belanja = "Harian"
    elseif data("IPH_belanja") = 2 then 
        belanja = "Mingguan"
    else
        belanja = "Tahunan"
    end if

    call header("Faktur Terhutang")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM UPDATE FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <form action="faktur_u.asp?id=<%= id %>" method="post" id="formfaktur">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="id" class="col-form-label">Faktur ID</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="id" name="id" class="form-control" value="<%= data("IPH_ID") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ophid" class="col-form-label">P.O ID</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="ophid" name="ophid" class="form-control" value="<%= data("IPH_ophID") %>" readonly>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("IPH_AgenID") %>" readonly>
                <input type="text" class="form-control" name="lagen" id="lagen" value="<% call getAgen(data("IPH_AgenID"),"p") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("IPH_Date") %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="<%= data("IPH_venid") %>"><% call getVendor(data("IPH_venid")) %></option>
                    <% do while not vendor.eof %>
                    <option value="<%= vendor("ven_ID") %>"><%= vendor("ven_Nama") %></option>
                    <% 
                    vendor.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("IPH_JTDAte") <> "1900-01-01"  then%> value="<%= data("IPH_JTDate") %>" <% end if %> onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="<%= data("IPH_MetPem") %>"><% call getmetpem(data("IPH_MetPem")) %></option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("IPH_Diskonall") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="typebelanja" class="col-form-label">Type belanja</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="typebelanja" name="typebelanja" required>
                    <option value="<%= data("IPH_belanja") %>"><%= belanja %></option>
                    <option value="1">Harian</option>
                    <option value="2">Mingguan</option>
                    <option value="3">Tahunan</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("IPH_ppn") %>">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("IPH_Keterangan") %>">
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
                <table class="table table-hover">
                    <thead class="bg-secondary text-light" style="white-space: nowrap;">
                        <tr>
                            <th>Pilih</th>
                            <th>Item</th>
                            <th>Quantty</th>
                            <th>Harga</th>
                            <th>Satuan Barang</th>
                            <th>Disc1</th>
                            <th>Disc2</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% do while not data.eof %>
                        <tr>
                            <td class="text-center">
                                <input class="form-check-input ckpo" type="checkbox" value="" id="ckpo">
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="item" name="item" >
                                    <option value="<%= data("IPD_Item") %>"><%= data("Brg_Nama")%></option>
                                </select>
                            </td>
                            <td>
                                <input type="text" id="qtty" name="qtty" class="form-control " value="<%= data("IPD_QtySatuan") %>" autocomplete="off">
                            </td>
                            <td>
                                <input type="hidden" id="hargapo" name="harga" class="form-control " value="<%= data("IPD_Harga") %>" readonly>
                                <input type="text" id="lhargapo" name="lharga" class="form-control " value="<%= replace(formatCurrency(data("IPD_Harga")),"$","") %>" readonly>
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="satuan" name="satuan" >
                                    <option value="<%= data("IPD_JenisSat") %>"><% call getSatBerat(data("IPD_JenisSat")) %></option>
                                    
                                </select>
                            </td>
                            <td>
                                <input type="number" id="disc1" name="disc1" class="form-control " value="<%= data("IPD_Disc1") %>" required>
                            </td>
                            <td>
                                <input type="number" id="disc2" name="disc2" class="form-control" value="<%= data("IPD_Disc2") %>" required>
                            </td>
                        </tr>
                        <% 
                        data.movenext
                        loop
                        data.movefirst
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- get value update -->
        <div class="value" style="display:none;">
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valitem" name="valitem" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valqtty" name="valqtty" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valharga" name="valharga" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valsatuan" name="valsatuan" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc1" name="valdisc1" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc2" name="valdisc2" class="form-control">
                </div>
            </div>
             <!-- 
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="thargapo" name="thargapo" class="form-control">
                </div>
            </div>
             -->
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="incomming.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  

<!-- Modal -->
<div class="modal fade" id="modalPemD" tabindex="-1" aria-labelledby="modalPemDLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalPemDLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="faktur_u.asp?id=<%= id %>" method="post">
        <div class="modal-body modalPemD">
            <input type="hidden" name="id" id="id" value="<%= id %>">
            <input type="hidden" name="ophid" id="ophid" value="<%= data("IPH_ophID") %>">
            <div class="row">
                <div class="col-sm-4">
                    <label for="itemf" class="col-form-label">Barang</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <select class="form-select" id="itemf" name="itemf" aria-label="Default select example" required>
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
                    <label for="qtty" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="hargaf" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="hargaf" class="form-control" name="hargaf" autocomplete="off" required>
                </div>
            </div>
            
            <div class="row">
                <div class="col-sm-4">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-8 mb-3">
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
                <div class="col-lg-4 mb-3">
                    <label for="disc1" class="col-form-label">Disc1</label>
                </div>
                <div class="col-lg-8">
                    <input type="number" id="disc1" name="disc1" autocomplete="off" class="form-control" required>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 mb-3">
                    <label for="disc2" class="col-form-label">Disc2</label>
                </div>
                <div class="col-lg-8">
                    <input type="number" id="disc2" name="disc2" autocomplete="off" class="form-control" required>
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
        call updateFaktur()
    end if
    call footer()
%>