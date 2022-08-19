<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_T_OrJulH.OJH_ppn, dbo.DLK_T_OrJulH.OJH_diskonall, dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_QtySatuan, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Disc1,dbo.DLK_T_OrJulD.OJD_Disc2, dbo.DLK_M_CUstomer.custNama, dbo.DLK_M_CUstomer.custPhone1,dbo.DLK_M_CUstomer.custPhone2, dbo.DLK_M_CUstomer.custEmail, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrJulH RIGHT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_T_OrJulH.OJH_ID = dbo.DLK_T_OrJulD.OJD_OJHID LEFT OUTER JOIN dbo.DLK_M_CUstomer ON dbo.DLK_T_OrJulH.OJH_custID = dbo.DLK_M_CUstomer.custID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrJulD.OJD_Item = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_OrJulH.OJH_ID = '"& id &"' AND dbo.DLK_T_OrJulH.OJH_AktifYN = 'Y' AND dbo.DLK_T_OrJulD.OJD_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_T_OrJulH.OJH_ppn, dbo.DLK_T_OrJulH.OJH_diskonall, dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_QtySatuan, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_JenisSat,dbo.DLK_T_OrJulD.OJD_Disc1, dbo.DLK_T_OrJulD.OJD_Disc2,dbo.DLK_M_CUstomer.custNama, dbo.DLK_M_CUstomer.custPhone1,dbo.DLK_M_CUstomer.custPhone2, dbo.DLK_M_CUstomer.custEmail, DLK_M_Barang.Brg_Nama"

    set data = data_cmd.execute

    
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
        <div class="col-lg-6">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No</th>
                    <th>:</th>
                    <td>
                        <%= left(data("OJH_ID"),2) %>-<% call getAgen(mid(data("OJH_ID"),3,3),"") %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4) %>
                    </td>
                </tr>
                <tr>
                    <th>Customer</th>
                    <th>:</th>
                    <td>
                        <%= data("CustNama") %>
                    </td>
                </tr>
                <tr>
                    <th>Phone1</th>
                    <th>:</th>
                    <td>
                        <%= data("custPhone1") %>
                    </td>
                </tr>
                <tr>
                    <th>Phone2</th>
                    <th>:</th>
                    <td>
                        <%= data("custPhone2") %>
                    </td>
                </tr>
                <tr>
                    <th>Email</th>
                    <th>:</th>
                    <td>
                        <%= data("custEmail") %>
                    </td>
                </tr>
                <tr>
                    <th>Ppn</th>
                    <th>:</th>
                    <td>
                        <%= data("OJH_PPN") %>%
                    </td>
                </tr>
                <tr>
                    <th>Diskon All</th>
                    <th>:</th>
                    <td>
                        <%= data("OJH_DiskonAll") %>%
                    </td>
                </tr>
            </table>
        </div>
        <div class="col-6 mb-3">
            <div class="btn-group float-end p-0" role="group" aria-label="Basic example">
                <a href="outgoing.asp" type="button" class="btn btn-primary">Kembali</a>
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsOrjul.asp?id=<%=id%>','_self')">EXPORT</button>
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
                    jml = data("OJD_QtySatuan") * data("OJD_Harga")
                    ' cek diskon peritem
                    if data("OJD_Disc1") <> 0 and data("OJD_Disc2") <> 0  then
                        dis1 = (data("OJD_Disc1")/100) * data("OJD_Harga")
                        dis2 = (data("OJD_Disc2")/100) * data("OJD_Harga")
                    elseif data("OJD_Disc1") <> 0 then
                        dis1 = (data("OJD_Disc1")/100) * data("OJD_Harga")
                    elseIf data("OJD_Disc2") <> 0 then
                        dis2 = (data("OJD_Disc2")/100) * data("OJD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = data("OJD_Harga") - dis1 - dis2
                    realharga = hargadiskon * data("OJD_QtySatuan")  

                    grantotal = grantotal + realharga

                    strid = data("OJD_OJHID")&","& data("OJD_Item") &","& data("OJD_QtySatuan") &","&  data("OJD_JenisSat") &","& data("OJD_Harga") &","& data("OJD_Disc1") &","& data("OJD_Disc2")   
                    %>
                        <tr>
                            <td>
                                <%= data("Brg_Nama") %>
                            </td>
                            <td>
                                <%= data("OJD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(data("OJD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(data("OJD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= data("OJD_disc1") %>%
                            </td>
                            <td>
                                <%= data("OJD_disc2") %>%
                            </td>
                            <td>
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktorjuld.asp?id=<%= strid %>" class="btn badge text-bg-danger btn-purce2">Delete</a>
                            </div>
                            </td>
                        </tr>
                    <% 
                    data.movenext
                    loop
                    data.movefirst
                    ' cek diskonall
                    if data("OJH_diskonall") <> 0 OR data("OJH_Diskonall") <> "" then
                        diskonall = (data("OJH_Diskonall")/100) * grantotal
                    else
                        diskonall = 0
                    end if

                    ' hitung ppn
                    if data("OJH_ppn") <> 0 OR data("OJH_ppn") <> "" then
                        ppn = (data("OJH_ppn")/100) * grantotal
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