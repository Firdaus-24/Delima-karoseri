<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1,dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = dbo.DLK_T_InvPemD.IPD_IPHID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y' AND dbo.DLK_T_InvPemD.IPD_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat,dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama"

    set data = data_cmd.execute

    
    call header("Detail Faktur Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL FAKTUR BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No</th>
                    <th>:</th>
                    <td>
                        <%= left(data("IPH_ID"),2) %>-<% call getAgen(mid(data("IPH_ID"),3,3),"") %>/<%= mid(data("IPH_ID"),6,4) %>/<%= right(data("IPH_ID"),4) %>
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
                        <%= data("IPH_PPN") %>%
                    </td>
                </tr>
                <tr>
                    <th>Diskon All</th>
                    <th>:</th>
                    <td>
                        <%= data("IPH_DiskonAll") %>%
                    </td>
                </tr>
            </table>
        </div>
        <div class="col-6 mb-3">
            <div class="btn-group float-end p-0" role="group" aria-label="Basic example">
                <a href="incomming.asp" type="button" class="btn btn-primary">Kembali</a>
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsFaktur.asp?id=<%=id%>','_self')">EXPORT</button>
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
                    jml = data("IPD_QtySatuan") * data("IPD_Harga")
                    ' cek diskon peritem
                    if data("IPD_Disc1") <> 0 and data("IPD_Disc2") <> 0  then
                        dis1 = (data("IPD_Disc1")/100) * data("IPD_Harga")
                        dis2 = (data("IPD_Disc2")/100) * data("IPD_Harga")
                    elseif data("IPD_Disc1") <> 0 then
                        dis1 = (data("IPD_Disc1")/100) * data("IPD_Harga")
                    elseIf data("IPD_Disc2") <> 0 then
                        dis2 = (data("IPD_Disc2")/100) * data("IPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = data("IPD_Harga") - dis1 - dis2
                    realharga = hargadiskon * data("IPD_QtySatuan")  

                    grantotal = grantotal + realharga
                    %>
                        <tr>
                            <td>
                                <%= data("Brg_Nama") %>
                            </td>
                            <td>
                                <%= data("IPD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(data("IPD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(data("IPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= data("IPD_disc1") %>%
                            </td>
                            <td>
                                <%= data("IPD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= data("IPD_IPHID") %>&nama=<%= data("IPD_Item") %>" class="btn badge text-bg-danger btn-fakturd">Delete</a>
                            </div>
                            </td>
                        </tr>
                    <% 
                    data.movenext
                    loop
                    data.movefirst
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