<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, dbo.DLK_M_Divisi.divNama, DLK_M_Departement.DepNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrJulH.OJH_DepID = DLK_M_Departement.DepID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' get detail
    data_cmd.commandText = "SELECT DLK_T_OrJulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_OrjulD.OJD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Media Print")
    
%>  
    <style>
        body{
            padding:10px;
        }
        .gambar{
            position:block;
            width:100%;
            height:10%;
        }
        .gambar img{
            position:block;
            width:40rem;
            height:5rem;
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
    <div class="row gambar">
         <div class="col ">
            <img src="../../public/img/delimapanjang.png" alt="delimapanjang">
        </div>
    </div>
    <table width="100%" style="font-size:12px">
        <tbody>
        <tr>
            <td align="center">
                JL.Raya Pemda (kaum pandak) No.17   
                Karadenan Cibinong-Bogor 16913  
                Telp.0251-8655385   
                Email : Dakotakaroseriindonesia01@gmail.com 
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
        </tbody>
    </table>
    <table width="100%" style="font-size:12px">
        <tbody>
        <tr>
            <td width="6%">No</td>
            <td width="10px">:</td>
            <td >
                <%= left(data("OJH_ID"),2) %>-<% call getAgen(mid(data("OJH_ID"),3,3),"") %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4) %>
            </td>
        </tr>
        <tr>
            <td width="6%">Tanggal</td>
            <td width="10px">:</td>
            <td>
                <%= data("OJH_Date") %>
            </td>
        </tr>
        <tr>
            <td width="6%">Divisi</td>
            <td width="10px">:</td>
            <td>
                <%= data("DivNama") %>
            </td>
        </tr>
        <tr>
            <td width="6%">Departement</td>
            <td width="10px">:</td>
            <td>
                <%= data("DepNama") %>
            </td>
        </tr>
        <tr>
            <td width="6%">Keterangan</td>
            <td width="10px">:</td>
            <td>
                <%= data("OJH_KEterangan") %>
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
        </tbody>
    </table>
    <table width="100%" style="font-size:14px">
        <tbody>
        <tr>
            <td width="100%" align="center">
                <b>DETAIL PERMINTAAN BARANG</b>
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
        </tbody>
    </table>
    <table id="cdetail">
        <tbody>
        <tr>
            <th>No</th>
            <th>Item</th>
            <th>Quantity</th>
            <th>Satuan</th>
        </tr>
		<% 
        no = 0
        ' grantotal = 0
        do while not ddata.eof 
        no = no +1
        ' cek total harga 
        ' jml = ddata("OJD_QtySatuan") * ddata("OJD_Harga")
        ' ' cek diskon peritem
        ' if ddata("OJD_Disc1") <> 0 and ddata("OJD_Disc2") <> 0  then
        '     dis1 = (ddata("OJD_Disc1")/100) * ddata("OJD_Harga")
        '     dis2 = (ddata("OJD_Disc2")/100) * ddata("OJD_Harga")
        ' elseif ddata("OJD_Disc1") <> 0 then
        '     dis1 = (ddata("OJD_Disc1")/100) * ddata("OJD_Harga")
        ' elseIf ddata("OJD_Disc2") <> 0 then
        '     dis2 = (ddata("OJD_Disc2")/100) * ddata("OJD_Harga")
        ' else    
        '     dis1 = 0
        '     dis2 = 0
        ' end if
        ' ' total dikon peritem
        ' hargadiskon = ddata("OJD_Harga") - dis1 - dis2
        ' realharga = hargadiskon * ddata("OJD_QtySatuan")  

        ' grantotal = grantotal + realharga
        %>
            <tr >
                <td align="center">
                    <%= no %>
                </td>
                <td align="center">
                    <%= ddata("Brg_Nama") %>
                </td>
                <td align="center">
                    <%= ddata("OJD_QtySatuan") %>
                </td>
                <td align="center">
                    <%= ddata("sat_Nama") %>
                </td>
            </tr>
        <% 
        ddata.movenext
        loop
        ' cek diskonall
        ' if data("OJH_diskonall") <> 0 OR data("OJH_Diskonall") <> "" then
        '     diskonall = (data("OJH_Diskonall")/100) * grantotal
        ' else
        '     diskonall = 0
        ' end if

        ' ' hitung ppn
        ' if data("OJH_ppn") <> 0 OR data("OJH_ppn") <> "" then
        '     ppn = (data("OJH_ppn")/100) * grantotal
        ' else
        '     ppn = 0
        ' end if
        ' realgrantotal = (grantotal - diskonall) + ppn
        %>
        <!-- 
        <tr>
            <th colspan="5">Total Pembayaran</th>
            <th align="center"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
         -->
        </tbody>
    </table>
    <!-- 
    <table width="100%" style="font-size:12px;">
        <tbody>
        <tr>
            <td>&nbsp<td>
        </tr>
        <tr>
            <th width="6%">ppn</th>
            <td width="10px">:</td>
            <th><%= data("OJH_PPN") %>%</th>
        </tr>
        <tr>
            <th width="6%">Diskon All</th>
            <td width="10px">:</td>
            <th><%= data("OJH_Diskonall") %>%</th>
        </tr>

        </tbody>
    </table>
     -->