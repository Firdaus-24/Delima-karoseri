<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_OPHID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1,dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IPHID,13) LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_InvPemD.IPD_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_OPHID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat,dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama, GLB_M_Agen.AgenName"

    set data = data_cmd.execute

    
    call header("Detail Barang Kurang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL BARANG KURANG DARI PESANAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= data("IPH_ID") %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No P.O</th>
                    <td>
                        : <%= left(data("IPH_OPHID"),2) %>-<% call getAgen(mid(data("IPH_OPHID"),3,3),"") %>/<%= mid(data("IPH_OPHID"),6,4) %>/<%= right(data("IPH_OPHID"),4) %>
                    </td>
                    <th>Cabang / Agen</th>
                    <td>
                        : <%= data("AgenName") %>
                    </td>
                </tr>
                <tr>
                    <th>Tanggal</th>
                    <td>
                        : <%= Cdate(data("IPH_Date")) %>
                    </td>
                    <th>Tanggal JT</th>
                    <td>
                        : <% if Cdate(data("IPH_JTDate")) <> Cdate("01/01/1900") then%><%= Cdate(data("IPH_JTDate")) %> <% end if %>
                    </td>
                </tr>
                <tr>
                    <th>Vendor</th>
                    <td>
                        : <%= data("Ven_Nama") %>
                    </td>
                    <th>Phone</th>
                    <td>
                        : <%= data("Ven_Phone") %>
                    </td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td>
                        : <%= data("Ven_Email") %>
                    </td>
                    <th>Keterangan</th>
                    <td>
                        : <%= data("IPH_Keterangan") %>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsdetailinvPOmin.asp?id=<%=id%>','_self')">EXPORT</button>
            </div>
            <div class="p-2">
                <a href="invPOmin.asp" type="button" class="btn btn-danger">Kembali</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th>Item</th>
                        <th>Pesen</th>
                        <th>Beli</th>
                        <th>Harga</th>
                        <th>Satuan Barang</th>
                        <th>Disc1</th>
                        <th>Disc2</th>
                        <th>Jumlah</th>
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

                    ' cek barang pesenan PO 
                    data_cmd.commandText = "SELECT OPD_QtySatuan FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("IPH_OPHID") &"' AND OPD_Item = '"& data("IPD_Item") &"'"
                    ' response.write data_cmd.commandText & "<br>"
                    set qttypo = data_cmd.execute

                    if qttypo("OPD_QtySatuan") > data("IPD_QtySatuan") then
                        bgclass = "class='bg-danger text-light'"
                    else
                        bgclass =""
                    end if

                    %>
                        <tr>
                            <td>
                                <%= data("Brg_Nama") %>
                            </td>
                            <td <%= bgclass %>>
                                <%= qttypo("OPD_QtySatuan") %>
                            </td>
                            <td>
                                <%= data("IPD_QtySatuan") %>
                            </td>
                            <td class="text-end">
                                <%= replace(formatCurrency(data("IPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= data("Sat_Nama") %>
                            </td>
                            <td>
                                <%= data("IPD_Disc1") %>%
                            </td>
                            <td>
                                <%= data("IPD_Disc2") %>%
                            </td>
                            <td class="text-end">
                                <%= replace(formatCurrency(realharga),"$","") %>
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
                        <th colspan="6">Diskon All</th>
                        <th><%= data("IPH_Diskonall") %>%</th>
                        <th class="text-end"><%= replace(formatCurrency(Round(diskonall)),"$","") %></th>
                    </tr>
                    <tr>
                        <th colspan="6">PPN</th>
                        <th><%= data("IPH_PPN") %>%</th>
                        <th class="text-end"><%= replace(formatCurrency(Round(ppn)),"$","") %></th>
                    </tr>
                    <tr>
                        <th colspan="7">Total Pembayaran</th>
                        <th class="text-end"><%= replace(formatCurrency(Round(realgrantotal)),"$","") %></th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>  

<% 
    call footer()
%>