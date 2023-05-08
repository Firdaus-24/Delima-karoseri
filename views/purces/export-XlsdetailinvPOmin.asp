<!--#include file="../../init.asp"-->
<% 
    if session("PR6D") = false then
        Response.Redirect("index.asp")
    end if

    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=Invoices Reserve "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_M_Vendor.Ven_phone, dbo.DLK_M_Vendor.Ven_Email, dbo.DLK_T_OrPemH.OPH_Keterangan, dbo.DLK_T_OrPemH.OPH_Asuransi, dbo.DLK_T_OrPemH.OPH_Lain, dbo.DLK_M_Kebutuhan.K_Name, dbo.DLK_T_OrPemH.OPH_AcpDate, dbo.DLK_T_OrPemH.OPH_AktifYN FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrPemH.OPH_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN dbo.DLK_M_Kebutuhan ON dbo.DLK_T_OrPemH.OPH_KID = dbo.DLK_M_Kebutuhan.K_ID WHERE (dbo.DLK_T_OrPemH.OPH_ID = '"& id &"') AND (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y')"

    set data = data_cmd.execute

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, DLK_M_SatuanBarang.Sat_nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_OrPemD.OPD_Item LEFT OUTER JOIN DLK_M_SatuanBarang ON dbo.DLK_T_OrPemD.OPD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY Brg_nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set ddata = data_cmd.execute
    
%>
<style>
    body {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
        background-color: #FAFAFA;
        font: 12pt "Tahoma";
    }
    * {
        box-sizing: border-box;
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
    #number{
        text-align:right;
    }
    .tbldetail table { page-break-inside:auto }
    .tbldetail > tr    { page-break-inside:avoid; page-break-after:auto }
    @page {
        size: A4;
        size: auto;   /* auto is the initial value */
        margin:30px;
    }
    @media print {
        html, body {
            width: 210mm;
            height: 297mm;
            background-color:#fff;        
            padding:15px;       
        }
        .tbldetail > tr {
            margin:0;
            border: initial;
            border-radius: initial;
            width: initial;
            min-height: initial;
            box-shadow: initial;
            background: initial;
            page-break-after: always;
            page-break-before: always;
        }
        
    }
</style>
<body onload="window.print()">
    <div class="row gambar">
         <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
    <table style="text-align:center;width:100%;font-size:12px;">
        <tr>
            <th colspan="7" style="font-size:14px;">
                DETAIL BARANG KURANG DARI PESANAN
            </th>
        </tr>
        <tr>
            <th colspan="7"  style="font-size:14px;">
                <%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>
            </th>
        </tr>
        <tr>
            <td colspan="7">
                &nbsp
            </td>
        </tr>
    </table>
    <table style="text-align:left;width:100%;font-size:12px" class="tbldetail">
        <tr>
            <th>Cabang / Agen</th>
            <td>
                : <%= data("AgenName") %>
            </td>
            <th>Vendor</th>
            <td>
                : <%= data("Ven_Nama") %>
            </td>
        </tr>
        <tr>
            <th>Tanggal</th>
            <td>
                : <%= Cdate(data("OPH_Date")) %>
            </td>
            <th>Tanggal JT</th>
            <td>
                : <% if Cdate(data("OPH_JTDate")) <> Cdate("01/01/1900") then %><%= Cdate(data("OPH_JTDate")) %> <% end if %>
            </td>
        </tr>
        <tr>
            <th>Email</th>
            <td>
                : <%= data("Ven_Email") %>
            </td>
            <th>Phone</th>
            <td>
                : <%= data("Ven_Phone") %>
            </td>
        </tr>
        <tr>
            <th>Kebutuhan</th>
            <td>
                : <%= data("K_Name") %>
            </td>
            <th>Keterangan</th>
            <td>
                : <%= data("OPH_Keterangan") %>
            </td>
        </tr>
        <tr>
            <td colspan="7">
                &nbsp
            </td>
        </tr>
    </table>
    <table style="text-align:left;width:100%;" id="cdetail">
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
        hargadiskon = ddata("OPD_Harga") - dis1 - dis2
        realharga = hargadiskon * ddata("OPD_QtySatuan")  

        grantotal = grantotal + realharga
        
        ' cek barang datang
        data_cmd.commandText = "SELECT SUM(ISNULL(dbo.DLK_T_InvPemD.IPD_QtySatuan, 0)) AS beli FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_OPHID = '"& data("OPH_ID") &"') AND IPD_Item = '"& ddata("OPD_Item") &"' GROUP BY dbo.DLK_T_InvPemH.IPH_OPHID, dbo.DLK_T_InvPemD.IPD_Item"
        ' response.write data_cmd.commandText & "<br>"
        set inv = data_cmd.execute

        if inv("beli") > ddata("OPD_QtySatuan") then
            bgclass = "class='bg-danger text-light'"
        else
            bgclass =""
        end if

        %>
            <tr>
                <td>
                    <%= ddata("Brg_Nama") %>
                </td>
                <td <%= bgclass %>>
                    <%= ddata("OPD_QtySatuan") %>
                </td>
                <td>
                    <%= inv("beli") %>
                </td>
                <td style="text-align:right">
                    <%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>
                </td>
                <td>
                    <%= ddata("Sat_Nama") %>
                </td>
                <td>
                    <%= ddata("OPD_Disc1") %>%
                </td>
                <td>
                    <%= ddata("OPD_Disc2") %>%
                </td>
                <td style="text-align:right">
                    <%= replace(formatCurrency(realharga),"$","") %>
                </td>
            </tr>
        <% 
        response.flush
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
        realgrantotal = (grantotal - diskonall) + ppn + data("OPH_Asuransi") + data("OPH_lain")
        %>
        <tr>
            <th colspan="6">Diskon All</th>
            <th><%= data("OPH_Diskonall") %>%</th>
            <th style="text-align:right"><%= replace(formatCurrency(Round(diskonall)),"$","") %></th>
        </tr>
        <tr>
            <th colspan="6">PPN</th>
            <th><%= data("OPH_PPN") %>%</th>
            <th style="text-align:right"><%= replace(formatCurrency(Round(ppn)),"$","") %></th>
        </tr>
        <tr>
            <th colspan="7">Asuransi</th>
            <th style="text-align:right"><%= replace(formatCurrency(Round(data("OPH_Asuransi"))),"$","") %></th>
        </tr>
        <tr>
            <th colspan="7">Lain-Lain</th>
            <th style="text-align:right"><%= replace(formatCurrency(Round(data("OPH_lain"))),"$","") %></th>
        </tr>
        <tr>
            <th colspan="7">Total Pembayaran</th>
            <th style="text-align:right"><%= replace(formatCurrency(Round(realgrantotal)),"$","") %></th>
        </tr>
    </table>
