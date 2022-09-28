<!--#include file="../../init.asp"-->
<% 
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=FakturTerhutang "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_OPHID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1,dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IPHID,13) LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_InvPemD.IPD_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_OPHID, dbo.DLK_T_InvPemH.IPH_ppn, dbo.DLK_T_InvPemH.IPH_diskonall, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemD.IPD_IPHID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat,dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2,dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, DLK_M_Vendor.ven_Email, DLK_M_Barang.Brg_Nama, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama, GLB_M_Agen.AgenName"

    set data = data_cmd.execute
    
    call header("FAKTUR TERHUTANG")
%>
<style>
    body{
        padding:10px;
    }
    .gambarpanjang{
        width:550px;
        height:80px;
        top:0;
    }
    .gambarpanjang img{
        position:absolute;
        top:0;
        width:550px;
        height:80px;
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
</style>
    <table>
        <tr>
            <td colspan="4" class="gambarpanjang">
                <img src="<%= url %>public/img/delimapanjang.png" alt="delimapanjang"  width="500" height="70">
            </td>
        </tr>
        <tr>
            <td colspan="5" style="font-size:10px">
                JL.Raya Pemda (kaum pandak) No.17 
                Karadenan Cibinong-Bogor 16913 
                Telp.0251-8655385 
                Email : Dakotakaroseriindonesia01@gmail.com
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
    </table>
    <table>
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
                : <%= Cdate(data("IPH_JTDate")) %>
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
        <tr>
            <td colspan="5">&nbsp</td>
        </tr>
    </table>
    <table>
        <tr>
            <td colspan="5" style="text-align:center;">
                <h3>FAKTUR TERHUTANG INCOMMING</h3>
            </td>
        </tr>
    </table>
    <table id="cdetail">
        <tr>
            <th scope="col">No</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Rak</th>
        </tr>
        <% 
        no = 0
        ' grantotal = 0
        do while not data.eof 
        no = no +1
        ' ' cek total harga 
        ' jml = data("IPD_QtySatuan") * data("IPD_Harga")
        ' ' cek diskon peritem
        ' if data("IPD_Disc1") <> 0 and data("IPD_Disc2") <> 0  then
        '     dis1 = (data("IPD_Disc1")/100) * data("IPD_Harga")
        '     dis2 = (data("IPD_Disc2")/100) * data("IPD_Harga")
        ' elseif data("IPD_Disc1") <> 0 then
        '     dis1 = (data("IPD_Disc1")/100) * data("IPD_Harga")
        ' elseIf data("IPD_Disc2") <> 0 then
        '     dis2 = (data("IPD_Disc2")/100) * data("IPD_Harga")
        ' else    
        '     dis1 = 0
        '     dis2 = 0
        ' end if
        ' ' total dikon peritem
        ' hargadiskon = data("IPD_Harga") - dis1 - dis2
        ' realharga = hargadiskon * data("IPD_QtySatuan")  

        ' grantotal = grantotal + realharga
        %>
            <tr>
                <td>
                    <%= no %>
                </td>
                <td>
                    <%= data("Brg_Nama") %>
                </td>
                <td>
                    <%= data("IPD_QtySatuan") %>
                </td>
                <td>
                    <%= data("Sat_Nama") %>
                </td>
                <td>
                    <%= data("Rak_Nama") %>
                </td>
            </tr>
        <% 
        data.movenext
        loop
        ' data.movefirst
        ' ' cek diskonall
        ' if data("IPH_diskonall") <> 0 OR data("IPH_Diskonall") <> "" then
        '     diskonall = (data("IPH_Diskonall")/100) * grantotal
        ' else
        '     diskonall = 0
        ' end if

        ' ' hitung ppn
        ' if data("IPH_ppn") <> 0 OR data("IPH_ppn") <> "" then
        '     ppn = (data("IPH_ppn")/100) * grantotal
        ' else
        '     ppn = 0
        ' end if
        ' realgrantotal = (grantotal - diskonall) + ppn
        %>
        <!-- 
        <tr>
            <th colspan="5">Total Pembayaran</th>
            <th><%'= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
        <tr>
            <th>ppn</th>
            <td>:</td>
            <th><%'= data("IPH_PPN") %>%</th>
        </tr>
        <tr>
            <th>Diskon All</th>
            <td>:</td>
            <th><%'= data("IPH_Diskonall") %>%</th>
        </tr>
         -->
    </table>
<% 
    call footer()

%>
    