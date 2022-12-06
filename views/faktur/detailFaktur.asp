<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_Email, dbo.DLK_M_Vendor.Ven_phone, dbo.DLK_M_Vendor.Ven_ID, dbo.DLK_M_Vendor.Ven_TypeTransaksi, dbo.DLK_M_Vendor.Ven_Norek, GL_M_Bank.Bank_Name FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_VenId = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_InvPemH.IPH_AgenId = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN GL_M_Bank ON DLK_M_Vendor.Ven_BankID = GL_M_Bank.Bank_ID WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_ID = '"& id &"')"

    set data = data_cmd.execute

    ' cek type transaksi
    if data("Ven_TypeTransaksi") = "1" then
        strtype = "CBD"
    elseIF data("Ven_TypeTransaksi") = "2" then
        strtype = "COD"
    elseIF data("Ven_TypeTransaksi") = "3" then
        strtype = "TOP"
    else
        strtype = ""
    end if

    ' detail faktur
    data_cmd.commandText = "SELECT dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_IphID,dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2 FROM dbo.DLK_M_Kategori RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_InvPemD.IPD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_InvPemD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) = '"& id &"' ORDER BY dbo.DLK_T_InvPemD.IPD_IphID"

    set ddata = data_cmd.execute

    
    call header("Detail Faktur Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL FAKTUR BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center labelId">
            <h3><%= data("IPH_ID") %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center">
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" />
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No P.O</th>
                    <th>:</th>
                    <td>
                        <%= left(data("IPH_OPHID"),2) %>-<% call getAgen(mid(data("IPH_OPHID"),3,3),"") %>/<%= mid(data("IPH_OPHID"),6,4) %>/<%= right(data("IPH_OPHID"),4) %>
                    </td>
                    <th>Cabang / Agen</th>
                    <th>:</th>
                    <td>
                        <%= data("AgenName") %>
                    </td>
                </tr>
                <tr>
                    <th>Tanggal</th>
                    <th>:</th>
                    <td>
                        <%= Cdate(data("IPH_Date")) %>
                    </td>
                    <th>Tanggal JT</th>
                    <th>:</th>
                    <td>
                        <%if Cdate(data("IPH_JTDate")) <> Cdate("1/1/1900") then %>
                        <%= Cdate(data("IPH_JTDate")) %>
                        <% end if %>
                    </td>
                </tr>
                <tr>
                    <th>Vendor</th>
                    <th>:</th>
                    <td>
                        <%= data("Ven_Nama") %>
                    </td>
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
                    <th>Type Transaksi</th>
                    <th>:</th>
                    <td>
                        <%= strtype %>
                    </td>
                </tr>
                <tr>
                    <th>Bank</th>
                    <th>:</th>
                    <td>
                        <%= data("Bank_Name") %>
                    </td>
                    <th>No.Rekening</th>
                    <th>:</th>
                    <td>
                        <%= data("Ven_Norek") %>
                    </td>
                </tr>
                <tr>
                    <th>Keterangan</th>
                    <th>:</th>
                    <td>
                        <%= data("IPH_Keterangan") %>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsFaktur.asp?id=<%=id%>','_self')">EXPORT</button>
            </div>
            <div class="p-2">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Dics1</th>
                        <th scope="col">Dics2</th>
                        <th scope="col">Harga</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0
                    do while not ddata.eof 
                    ' cek total harga 
                    jml = ddata("IPD_QtySatuan") * ddata("IPD_Harga")
                    ' cek diskon peritem
                    if ddata("IPD_Disc1") <> 0 and ddata("IPD_Disc2") <> 0  then
                        dis1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
                        dis2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")
                    elseif ddata("IPD_Disc1") <> 0 then
                        dis1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
                    elseIf ddata("IPD_Disc2") <> 0 then
                        dis2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = ddata("IPD_Harga") - dis1 - dis2
                    realharga = hargadiskon * ddata("IPD_QtySatuan")  

                    grantotal = grantotal + realharga
                    %>
                        <tr>
                            <th>
                                <button type="button" class="btn btn-outline-primary" onclick="window.location.href='printBarcode.asp?id=<%= ddata("IPD_IPHID")%>'"><%= ddata("IPD_IPHID") %></button>
                                
                            </th>
                            <td>    
                                <%= ddata("kategoriNama") &"-"& ddata("JenisNama") %>
                            </td>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IPD_QtySatuan") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IPD_Disc1") %>
                            </td>
                            <td>
                                <%= ddata("IPD_Disc2") %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop

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
                        <th colspan="6">PPN</th>
                        <th><%= data("IPH_PPN") &"%" %></th>
                        <th><%= replace(formatCurrency(ppn),"$","") %></th>
                    </tr>
                    <tr>
                        <th colspan="6">Diskon All</th>
                        <th><%= data("IPH_DiskonAll") &"%" %></th>
                        <th><%= replace(formatCurrency(diskonall),"$","") %></th>
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