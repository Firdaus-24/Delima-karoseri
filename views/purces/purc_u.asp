<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT DLK_T_AppPermintaan.AppDana, dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_T_OrPemD.OPD_AktifYN, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrPemH INNER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = dbo.DLK_T_OrPemD.OPD_OPHID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrpemD.OPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_T_AppPermintaan ON DLK_T_OrPemH.OPH_MemoID = DLK_T_AppPermintaan.appMemoID where DLK_T_OrPemH.OPH_ID = '"& id &"' AND DLK_T_OrPemH.OPH_AktifYN = 'Y' AND DLK_T_OrPemD.OPD_AktifYN = 'Y' GROUP BY  DLK_T_AppPermintaan.AppDana, dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_T_OrPemD.OPD_AktifYN,DLK_M_Barang.Brg_Nama "

    set data = data_cmd.execute

    ' barang
    data_cmd.commandText = "SELECT brg_Nama, brg_ID FROM DLK_M_Barang WHERE brg_AktifYN = 'Y' AND left(Brg_Id,3) = '"& data("OPH_AgenID") &"' ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' agen
    data_cmd.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set agen = data_cmd.execute
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
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OPH_JTDAte") <> "1900-01-01"  then%> value="<%= data("OPH_JTDate") %>" <% end if %> onfocus="(this.type='date')">
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
                                    <option value="<%= data("OPD_Item") %>"><%= data("Brg_Nama")%></option>
                                </select>
                            </td>
                            <td>
                                <input type="text" id="qtty" name="qtty" class="form-control " value="<%= data("OPD_QtySatuan") %>">
                            </td>
                            <td>
                                <input type="hidden" id="hargapo" name="harga" class="form-control " value="<%= data("OPD_Harga") %>" readonly>
                                <input type="text" id="lhargapo" name="lharga" class="form-control " value="<%= replace(formatCurrency(data("OPD_Harga")),"$","") %>" readonly>
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="satuan" name="satuan" >
                                    <option value="<%= data("OPD_JenisSat") %>"><% call getSatBerat(data("OPD_JenisSat")) %></option>
                                    
                                </select>
                            </td>
                            <td>
                                <input type="number" id="disc1" name="disc1" class="form-control " value="<%= data("OPD_Disc1") %>" required>
                            </td>
                            <td>
                                <input type="number" id="disc2" name="disc2" class="form-control" value="<%= data("OPD_Disc2") %>" required>
                            </td>
                        </tr>
                        <% 
                        data.movenext
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


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updatePurce()
    end if
    call footer()
%>