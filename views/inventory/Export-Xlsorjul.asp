<!--#include file="../../init.asp"-->
<% 
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=Order Penjualan "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_T_OrJulH.OJH_ppn, dbo.DLK_T_OrJulH.OJH_diskonall, dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_QtySatuan, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Disc1,dbo.DLK_T_OrJulD.OJD_Disc2, dbo.DLK_M_CUstomer.custNama, dbo.DLK_M_CUstomer.custPhone1,dbo.DLK_M_CUstomer.custPhone2, dbo.DLK_M_CUstomer.custEmail, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrJulH RIGHT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_T_OrJulH.OJH_ID = dbo.DLK_T_OrJulD.OJD_OJHID LEFT OUTER JOIN dbo.DLK_M_CUstomer ON dbo.DLK_T_OrJulH.OJH_custID = dbo.DLK_M_CUstomer.custID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrJulD.OJD_Item = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_OrJulH.OJH_ID = '"& id &"' AND dbo.DLK_T_OrJulH.OJH_AktifYN = 'Y' AND dbo.DLK_T_OrJulD.OJD_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_T_OrJulH.OJH_ppn, dbo.DLK_T_OrJulH.OJH_diskonall, dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_QtySatuan, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_JenisSat,dbo.DLK_T_OrJulD.OJD_Disc1, dbo.DLK_T_OrJulD.OJD_Disc2,dbo.DLK_M_CUstomer.custNama, dbo.DLK_M_CUstomer.custPhone1,dbo.DLK_M_CUstomer.custPhone2, dbo.DLK_M_CUstomer.custEmail, DLK_M_Barang.Brg_Nama"

    set data = data_cmd.execute
    
%>
    <table>
        <tr rowspan="3">
            <td colspan="4">
                <img src="../../public/img/delimapanjang.png" alt="delimapanjang"  width="500" height="70">
            </td>
            <td colspan="2">
                JL.Raya Pemda (kaum pandak) No.17 <br>
                Karadenan Cibinong-Bogor 16913 <br>
                Telp.0251-8655385 <br>
                Email : Dakotakaroseriindonesia01@gmail.com<br>
            </td>
        </tr>
        <tr>
            <th colspan="6"><hr></th>
        </tr>
        <tr>
            <td>No</td>
            <td>:</td>
            <td>
                <%= left(data("OJH_ID"),2) %>-<% call getAgen(mid(data("OJH_ID"),3,3),"") %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4) %>
            </td>
        </tr>
        <tr>
            <td>Customer</td>
            <td>:</td>
            <td>
                <%= data("CustNama") %>
            </td>
        </tr>
        <tr>
            <td>Phone1</td>
            <td>:</td>
            <td>
                <%= data("CustPhone1") %>
            </td>
        </tr>
        <tr>
            <td>Phone2</td>
            <td>:</td>
            <td>
                <%= data("CustPhone2") %>
            </td>
        </tr>
        <tr>
            <td>Email</td>
            <td>:</td>
            <td>
                <%= data("CustEmail") %>
            </td>
        </tr>
        <tr>
            <td colspan="6" style="text-align:center;margin-top:5px;margin-bottom:5px;">
                <h3>DETAIL ORDER PENJUALAN</h3>
            </td>
        </tr>

        <tr>
            <th scope="col">No</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Jumlah</th>
        </tr>
        <% 
        no = 0
        grantotal = 0
        do while not data.eof 
        no = no +1
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
        %>
            <tr>
                <td>
                    <%= no %>
                </td>
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
                    <%= replace(formatCurrency(realharga),"$","") %>
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
            <th colspan="5">Total Pembayaran</th>
            <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
        <tr>
            <th>ppn</th>
            <td>:</td>
            <th><%= data("OJH_PPN") %>%</th>
        </tr>
        <tr>
            <th>Diskon All</th>
            <td>:</td>
            <th><%= data("OJH_Diskonall") %>%</th>
        </tr>
    </table>
    