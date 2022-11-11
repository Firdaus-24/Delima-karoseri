<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_OrPemH.*, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, dbo.DLK_M_Vendor.Ven_Email FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrPemH.OPH_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y'"
    ' data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Disc1,dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrPemD.OPD_Item = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall,dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat,dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email,DLK_M_Barang.Brg_Nama"

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
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No PO</th>
                    <th>:</th>
                    <td>
                        <%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>
                    </td>
                </tr>
                <tr>
                    <th>No Memo</th>
                    <th>:</th>
                    <td>
                        <%= left(data("OPH_memoID"),4) %>/<%=mid(data("OPH_memoId"),5,3) %>-<% call getAgen(mid(data("OPH_memoID"),8,3),"") %>/<%= mid(data("OPH_memoID"),11,4) %>/<%= right(data("OPH_memoID"),3) %>
                    </td>
                </tr>
                <tr>
                    <th>Vendor</th>
                    <th>:</th>
                    <td>
                        <%= data("Ven_Nama") %>
                    </td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <th>:</th>
                    <td>
                        <%= data("Ven_Phone") %>
                    </td>
                </tr>
                <tr>
                    <th>Email</th>
                    <th>:</th>
                    <td>
                        <%= data("Ven_Email") %>
                    </td>
                </tr>
                <tr>
                    <th>Ppn</th>
                    <th>:</th>
                    <td>
                        <%= data("OPH_PPN") %>%
                    </td>
                </tr>
                <tr>
                    <th>Diskon All</th>
                    <th>:</th>
                    <td>
                        <%= data("OPH_DiskonAll") %>%
                    </td>
                </tr>
            </table>
        </div>
    </div>
    
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsPurchase.asp?id=<%=id%>','_self')">EXPORT</button>
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



<% 
    call footer()
%>