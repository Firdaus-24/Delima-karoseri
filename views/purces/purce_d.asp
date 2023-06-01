<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_OrPemH.*, GLB_M_Agen.AgenName, DLK_M_vendor.Ven_Nama, DLK_M_Kebutuhan.K_Name FROM DLK_T_OrPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_vendor ON DLK_T_OrPemH.OPH_venID = DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_OrPemH.OPH_KID = DLK_M_Kebutuhan.K_ID WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y'"

    set data = data_cmd.execute

    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_OrPemD.*, dbo.DLK_M_Barang.Brg_Id,DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_OrPemD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_OrPemD.OPD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrPemD.OPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail Barang PO")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL PURCHASE ORDER</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></h3>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="memoId" class="col-form-label">No Memo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="hidden" id="memoId" name="memoId" class="form-control" value="<%= data("OPH_memoID") %>" readonly>
            <input type="text" id="lmemoId" name="lmemoId" class="form-control" value="<%= left(data("OPH_memoID"),4) %>/<%=mid(data("OPH_memoId"),5,3) %>-<% call getAgen(mid(data("OPH_memoID"),8,3),"") %>/<%= mid(data("OPH_memoID"),11,4) %>/<%= right(data("OPH_memoID"),3) %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="agen" name="agen" class="form-control" value="<%= data("agenName") %>" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="vendor" class="col-form-label">Vendor</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="vendor" name="vendor" class="form-control" value="<%= data("Ven_Nama") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" readonly required>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="acpdate" class="col-form-label">Tanggal Diterima</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="acpdate" name="acpdate" class="form-control" <% if data("OPH_acpDate") <> "1900-01-01" then %> value="<%= Cdate(data("OPH_acpDate")) %>" <% end if %> readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OPH_JTDate") <> "1900-01-01" then %> value="<%= Cdate(data("OPH_JTDate")) %>" <% end if %> readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="Asuransi" class="col-form-label">Asuransi</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Asuransi" name="Asuransi" class="form-control" value="<%= replace(formatcurrency(data("OPH_Asuransi")),"$","") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="Lain" class="col-form-label">Lain</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Lain" name="Lain" class="form-control" value="<%= replace(formatcurrency(data("OPH_Lain")),"$","") %>" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="ppn" class="col-form-label">PPn</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OPH_PPN") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="diskon" class="col-form-label">Diskon All</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("OPH_DiskonALl") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="kebutuhan" name="kebutuhan" class="form-control" maxlength="50" value="<%= data("K_NAme") %>" autocomplete="off" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OPH_Keterangan") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <% if session("PR2D") = true then %>
                    <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsPurchase.asp?id=<%=id%>','_self')">EXPORT</button>
                    <% end if %>
                </div>
                <div class="p-2">
                    <a href="purcesDetail.asp" type="button" class="btn btn-primary">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">Kode</th>
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
                    do while not ddata.eof 
                    ' cek total harga 
                    jml = ddata("OPD_QtySatuan") * ddata("OPD_Harga")
                    ' cek diskon peritem
                    if ddata("OPD_Disc1") <> 0 and ddata("OPD_Disc2") <> 0  then
                        dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
                        dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
                    elseif ddata("OPD_Disc1") <> 0 then
                        dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
                    elseIf ddata("OPD_Disc2") <> 0 then
                        dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = (ddata("OPD_Harga") - dis1) - dis2
                    realharga = hargadiskon * ddata("OPD_QtySatuan")  

                    grantotal = grantotal + realharga

                    %>
                        <tr>
                            <th>
                                <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("OPD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(ddata("OPD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("OPD_disc1") %>%
                            </td>
                            <td>
                                <%= ddata("OPD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop
                    ' cek diskonall
                    if data("OPH_diskonall") <> 0 OR data("OPH_Diskonall") <> "" then
                        diskonall = (data("OPH_Diskonall")/100) * grantotal
                    else
                        diskonall = 0
                    end if

                    ' hitung ppn
                    if data("OPH_ppn") <> 0 OR data("OPH_ppn") <> "" then
                        ppn = (data("OPH_ppn")/100) * grantotal
                    else
                        ppn = 0
                    end if
                    realgrantotal = (grantotal - diskonall) + ppn + data("OPH_Asuransi") + data("OPH_Lain")
                    %>
                    <tr>
                        <th colspan="7">Asuransi</th>
                        <th><%= replace(formatCurrency(data("OPH_Asuransi")),"$","") %></th>
                    </tr>
                    <tr>
                        <th colspan="7">Lain - Lain</th>
                        <th><%= replace(formatCurrency(data("OPH_Lain")),"$","") %></th>
                    </tr>
                    <tr>
                        <th colspan="7">Total Pembayaran</th>
                        <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>  



<% 
    call footer()
%>