<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Disc1,dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = dbo.DLK_T_OrPemD.OPD_OPHID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y' AND dbo.DLK_T_OrPemD.OPD_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat,dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email"

    set data = data_cmd.execute

    
    call header("Detail Barang PO")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>PURCHASE ORDER</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No</th>
                    <th>:</th>
                    <td>
                        <%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>
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
        <div class="col-6 mb-3">
            <div class="btn-group float-end p-0" role="group" aria-label="Basic example">
                <a href="purcesDetail.asp" type="button" class="btn btn-primary">Kembali</a>
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsPurchase.asp?id=<%=id%>','_self')">EXPORT</button>
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
                    do while not data.eof 
                    ' cek total harga 
                    jml = data("OPD_QtySatuan") * data("OPD_Harga")
                    ' cek diskon peritem
                    if data("OPD_Disc1") <> 0 and data("OPD_Disc2") <> 0  then
                        dis1 = (data("OPD_Disc1")/100) * data("OPD_Harga")
                        dis2 = (data("OPD_Disc2")/100) * data("OPD_Harga")
                    elseif data("OPD_Disc1") <> 0 then
                        dis1 = (data("OPD_Disc1")/100) * data("OPD_Harga")
                    elseIf data("OPD_Disc2") <> 0 then
                        dis2 = (data("OPD_Disc2")/100) * data("OPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = data("OPD_Harga") - dis1 - dis2
                    realharga = hargadiskon * data("OPD_QtySatuan")  

                    grantotal = grantotal + realharga
                    %>
                        <tr>
                            <td>
                                <%= data("OPD_Item") %>
                            </td>
                            <td>
                                <%= data("OPD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(data("OPD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(data("OPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= data("OPD_disc1") %>%
                            </td>
                            <td>
                                <%= data("OPD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= data("OPD_OPHID") %>&nama=<%= data("OPD_Item") %>" class="btn badge text-bg-danger btn-purce2">Delete</a>
                            </div>
                            </td>
                        </tr>
                    <% 
                    data.movenext
                    loop
                    data.movefirst
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
                        <th></th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>  



<% 
    call footer()
%>