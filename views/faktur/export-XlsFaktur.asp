<!--#include file="../../init.asp"-->
<% 
    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=FakturTerhutang "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_Email, dbo.DLK_M_Vendor.Ven_phone, dbo.DLK_M_Vendor.Ven_ID, dbo.DLK_M_Vendor.Ven_TypeTransaksi, dbo.DLK_M_Vendor.Ven_Norek, GL_M_Bank.Bank_Name FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_VenId = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_InvPemH.IPH_AgenId = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN GL_M_Bank ON DLK_M_Vendor.Ven_BankID = GL_M_Bank.Bank_ID WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_ID = '"& id &"')"
    ' response.write data_cmd.commandText & "<br>"
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
    data_cmd.commandText = "SELECT dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2 FROM dbo.DLK_M_Kategori RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_InvPemD.IPD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_InvPemD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) = '"& id &"' ORDER BY dbo.DLK_T_InvPemD.IPD_IphID"

    set ddata = data_cmd.execute
    
    call header("FAKTUR TERHUTANG")
%>
<style type="text/css">
    body{
        padding:10px;
    }
    .gambar{
        width:80px;
        height:80px;
        position:absolute;
        right:70px;
    }
    .gambar img{
        position:absolute;
        width:100px;
        height:50px;
    }
    #cdetail > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }

    #cdetail{
        width:100%;
        font-size:12px;
        border-collapse: collapse;
    }
    .footer article{
        font-size:10px;
    }
    @page {
      size: A4;
      size: auto;   /* auto is the initial value */
      margin: 0;  /* this affects the margin in the printer settings */
    }
    @media print {
        html, body {
            width: 210mm;
            height: 200mm;
            margin:0 auto;
        }
        /* ... the rest of the rules ... */
    }
</style>
<body onload="window.print()">
    <div class="row gambar">
        <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
    <table width="100%" >
        <tr>
            <td style="text-align:center;">
                <h5>FAKTUR TERHUTANG</h5>
            </td>
        </tr>
    </table>
    <table width="100%" style="font-size:12px">
        <tr>
            <th>No</th>
            <td>
                : <%= left(data("IPH_ID"),2) %>-<% call getAgen(mid(data("IPH_ID"),3,3),"") %>/<%= mid(data("IPH_ID"),6,4) %>/<%= right(data("IPH_ID"),4) %>
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
                : <%if Cdate(data("IPH_JTDate")) <> Cdate("1/1/1900") then %>
                    <%= Cdate(data("IPH_JTDate")) %>
                <% end if %>
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
            <th>Type Transaksi</th>
            <td>
                : <%= strtype %>
            </td>
        </tr>
        <tr>
            <th>Bank</th>
            <td>
                : <%= data("Bank_Name") %>
            </td>
            <th>No.Rekening</th>
            <td>
                : <%= data("Ven_Norek") %>
            </td>
        </tr>
        <tr>
            <th>Tukar Faktur</th>
            <td>
                : <%if data("IPH_tukarYN") ="Y" then %>Yes <% else %>No <% end if %>
            </td>
            <th>Keterangan</th>
            <td>
                : <%= data("IPH_Keterangan") %>
            </td>
        </tr>
        <tr>
            <td colspan="5">&nbsp</td>
        </tr>
    </table>
    <table id="cdetail">
        <tr>
            <th scope="col">No</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Disc1</th>
            <th scope="col">Disc2</th>
            <th scope="col">Harga</th>
        </tr>
        <% 
        no = 0
        grantotal = 0
        do while not ddata.eof 
        no = no + 1
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
                <td>
                    <%= no %>
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
                <td align="right">
                    <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
                </td>
            </tr>
        <% 
        response.flush
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
        realgrantotal = (grantotal - diskonall) + ppn + data("IPH_Asuransi") + data("IPH_Lain")
        %>
        <tr>
            <th colspan="5">ppn</th>
            <td><%= data("IPH_PPN") %>%</td>
            <td align="right"><%= replace(formatCurrency(ppn),"$","") %></td>
        </tr>
        <tr>
            <th colspan="5">Diskon All</th>
            <td><%= data("IPH_Diskonall") %>%</td>
            <td align="right"><%= replace(formatCurrency(diskonall),"$","") %></td>
        </tr>
        <tr>
            <th colspan="6">Asuransi</th>
                <td align="right">
                    <%= replace(formatcurrency(data("IPH_asuransi")),"$","") %>
                </td>
            </tr>
            <tr>
                <th colspan="6">Lain-lain</th>
                <td align="right">
                    <%= replace(formatcurrency(data("IPH_lain")),"$","")  %>
                </td>
            </tr>
        <tr>
            <th colspan="6">Total Pembayaran</th>
            <td align="right"><%= replace(formatCurrency(realgrantotal),"$","") %></td>
        </tr>
    </table>
    <div class="footer">
        <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" width="60"/></br>
        <article>
            <p>
                PT.Delima Karoseri Indonesia
            </p>
            <p>
                Copyright © 2022, ALL Rights Reserved MuhamadFirdaus-IT Division</br>
                V.1 Mobile Responsive 2022
            </p>
        </article>
    </div>  
</body>
<% 
    call footer()
%>
    