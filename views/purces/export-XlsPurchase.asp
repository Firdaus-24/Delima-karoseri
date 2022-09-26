<!--#include file="../../init.asp"-->
<% 
    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=Purchase Order "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall, dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Disc1,dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrPemD.OPD_Item = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_ppn, dbo.DLK_T_OrPemH.OPH_diskonall,dbo.DLK_T_OrPemH.OPH_memoId, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat,dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email,DLK_M_Barang.Brg_Nama"

    set data = data_cmd.execute

    call header("Purcase Order")
    
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
                <%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>
            </td>
        </tr>
        <tr>
            <td>No Memo</td>
            <td>:</td>
            <td>
                <%= left(data("OPH_memoID"),4) %>/<%=mid(data("OPH_memoId"),5,3) %>-<% call getAgen(mid(data("OPH_memoID"),8,3),"") %>/<%= mid(data("OPH_memoID"),11,4) %>/<%= right(data("OPH_memoID"),3) %>
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
                <h3>PURCHASE ORDER</h3>
            </td>
        </tr>

        <tr>
            <th scope="col">No</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Status</th>
            <th scope="col">Jumlah</th>
        </tr>
        <% 
        no = 0
        grantotal = 0
        do while not data.eof 
        no = no +1
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

        ' cek status pembelian
        data_cmd.commandText = "SELECT memoqtty FROM DLK_T_Memo_D WHERE left(memoId,17) = '"& data("OPH_MemoID") &"' AND memoitem = '"& data("OPD_Item") &"' AND memosatuan = '"& data("OPD_JenisSat") &"'"
        ' response.write data_cmd.commandText & "<br>"
        set qtymemo = data_cmd.execute

        angkastatus = qtymemo("memoqtty") - data("OPD_QtySatuan")
        if angkastatus > 0 then
            ckstatus = "-"&angkastatus
        elseIf angkastatus < 0 then
            ckstatus = "OverPO"
        else
            ckstatus = "Done"
        end if
        %>
            <tr>
                <td>
                    <%= no %>
                </td>
                <td>
                    <%= data("Brg_Nama") %>
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
                    <%= ckstatus%>
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
            <th colspan="5">Total Pembayaran</th>
            <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
        <tr>
            <th>ppn</th>
            <td>:</td>
            <th><%= data("OPH_PPN") %>%</th>
        </tr>
        <tr>
            <th>Diskon All</th>
            <td>:</td>
            <th><%= data("OPH_Diskonall") %>%</th>
        </tr>
    </table>
<% 
    call footer()
%>