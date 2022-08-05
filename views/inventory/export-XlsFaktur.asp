<!--#include file="../../init.asp"-->
<% 
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=FakturTerhutang "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1,dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = dbo.DLK_T_InvPemD.IPD_IPHID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y' AND dbo.DLK_T_InvPemD.IPD_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat,dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email"

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
                <%= left(data("IPH_ID"),2) %>-<% call getAgen(mid(data("IPH_ID"),3,3),"") %>/<%= mid(data("IPH_ID"),6,4) %>/<%= right(data("IPH_ID"),4) %>
            </td>
        </tr>
        <tr>
            <td>Vendor</td>
            <td>:</td>
            <td>
                <%= data("Ven_Nama") %>
            </td>
        </tr>
        <tr>
            <td>Phone</td>
            <td>:</td>
            <td>
                <%= data("Ven_Phone") %>
            </td>
        </tr>
        <tr>
            <td>Email</td>
            <td>:</td>
            <td>
                <%= data("Ven_Email") %>
            </td>
        </tr>
        <tr>
            <td colspan="6" style="text-align:center;margin-top:5px;margin-bottom:5px;">
                <h3>FAKTUR TERHUTANG</h3>
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
                    <%= no %>
                </td>
                <td>
                    <%= data("IPD_Item") %>
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
            <th colspan="5">Total Pembayaran</th>
            <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
        <tr>
            <th>ppn</th>
            <td>:</td>
            <th><%= data("IPH_PPN") %>%</th>
        </tr>
        <tr>
            <th>Diskon All</th>
            <td>:</td>
            <th><%= data("IPH_Diskonall") %>%</th>
        </tr>
    </table>
    