<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    ' data_cmd.commandText = "SELECT DLK_T_AppPermintaan.AppDana, dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrpemD.OPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_T_AppPermintaan ON DLK_T_OrPemH.OPH_MemoID = DLK_T_AppPermintaan.appMemoID where DLK_T_OrPemH.OPH_ID = '"& id &"' AND DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY  DLK_T_AppPermintaan.AppDana, dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2,DLK_M_Barang.Brg_Nama "
    data_cmd.commandTExt = "SELECT DLK_T_OrPemH.*, DLK_T_AppPermintaan.AppDana FROM DLK_T_OrPemH LEFT OUTER JOIN DLK_T_AppPermintaan ON DLK_T_OrPemH.OPH_MemoID = DLK_T_AppPermintaan.appMemoID WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' barang
    data_cmd.commandText = "SELECT brg_Nama, brg_ID FROM DLK_M_Barang WHERE brg_AktifYN = 'Y' AND left(Brg_Id,3) = '"& data("OPH_AgenID") &"' ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Prosess Purches")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM UPDATE PURCHES ORDER</h3>
        </div>
    </div>
    <form action="purc_u.asp?id=<%= id %>" method="post" id="formpur1">
        <input type="hidden" id="id" name="id" value="<%= data("OPH_ID") %>" readonly>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="agen" name="agen" class="form-control" value="<%= data("OPH_AgenID") %>" readonly required>
                <input type="text" id="lagen" name="lagen" class="form-control" value="<% call getAgen(data("OPH_AgenID"),"p") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("OPH_Date")) %>" onfocus="(this.type='date')" readonly required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="<%= data("OPH_venid") %>"><% call getVendor(data("OPH_venid")) %></option>
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
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OPH_JTDAte") <> "1900-01-01"  then%> value="<%= Cdate(data("OPH_JTDate")) %>" <% end if %> onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="<%= data("OPH_MetPem") %>"><% call getmetpem(data("OPH_MetPem")) %></option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("OPH_Diskonall") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OPH_ppn") %>">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="dana_tpo" class="col-form-label">Acc Dana</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="dana_tpo" name="dana_tpo" class="form-control" value="<%= replace(formatCurrency(data("appDana")),"$","") %>" readonly> 
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OPH_Keterangan") %>">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="d-flex">
                    <div class="me-auto p-2">
                        <button type="button" class="btn btn-primary btn-modalOrPemD" data-bs-toggle="modal" data-bs-target="#modalOrPemD">Tambah Rincian</button>
                    </div>
                    <div class="p-2">
                        <a href="purcesDetail.asp" class="btn btn-danger">Kembali</a>
                    </div>
                </div>
            </div>
        </div>


        <div class="row">
            <div class="col-lg-12 mb-3 mt-3">
                <table class="table tableupurchase">
                    <thead class="bg-secondary text-light" style="white-space: nowrap;">
                        <tr>
                            <th>Pilih</th>
                            <th>Item</th>
                            <th>Quantty</th>
                            <th>Harga</th>
                            <th>Satuan Barang</th>
                            <th>Disc1</th>
                            <th>Disc2</th>
                            <th scope="col" class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        data_cmd.commandText = "SELECT DLK_T_OrPemD.*, DLK_M_Barang.Brg_Nama FROM DLK_T_OrPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrPemD.OPD_Item = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC "

                        set ddata = data_cmd.execute
                        do while not ddata.eof 
                        
                        %>
                        <tr>
                            <td class="text-center">
                                <input class="form-check-input ckpo" type="checkbox" value="" id="ckpo">
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="item" name="item" >
                                    <option value="<%= ddata("OPD_Item") %>"><%= ddata("Brg_Nama")%></option>
                                </select>
                            </td>
                            <td>
                                <input type="text" id="qtty" name="qtty" class="form-control " value="<%= ddata("OPD_QtySatuan") %>">
                            </td>
                            <td>
                                <input type="hidden" id="hargapo" name="harga" class="form-control " value="<%= ddata("OPD_Harga") %>" readonly>
                                <input type="text" id="lhargapo" name="lharga" class="form-control " value="<%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>" readonly>
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="satuan" name="satuan" >
                                    <option value="<%= ddata("OPD_JenisSat") %>"><% call getSatBerat(ddata("OPD_JenisSat")) %></option>
                                    
                                </select>
                            </td>
                            <td>
                                <input type="number" id="disc1" name="disc1" class="form-control " value="<%= ddata("OPD_Disc1") %>" required>
                            </td>
                            <td>
                                <input type="number" id="disc2" name="disc2" class="form-control" value="<%= ddata("OPD_Disc2") %>" required>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= ddata("OPD_OPHID") %>" class="btn badge text-bg-danger btn-purce2">Delete</a>
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
                <a href="purcesDetail.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  

<!-- Modal -->
<div class="modal fade" id="modalOrPemD" tabindex="-1" aria-labelledby="modalOrPemDLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalOrPemDLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="purc_u.asp?id=<%= id %>" method="post">
        <div class="modal-body modalOrPemD">
            <input type="hidden" name="id" id="id" value="<%= id %>">
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
                    <label for="qtty" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="hargapo" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-8 mb-3">
                    <input type="number" id="hargapo" class="form-control" name="hargapo" autocomplete="off" required>
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
        call updatePurce()
    end if
    call footer()
%>