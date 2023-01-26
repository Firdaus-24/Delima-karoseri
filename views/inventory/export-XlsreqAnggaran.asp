<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama, GLB_M_Agen.AgenName, DLK_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_Memo_H.memoDivID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

%>
<% call header("Detail Permintaan Anggaran Inventory") %>
<style>
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
    #cdetail2 > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }

    #cdetail2{
        width:30%;
        font-size:12px;
        border-collapse: collapse;
        text-align: center;
        right:10px;
        position:absolute;
    }
    .footer article{
      font-size:10px;
    }
    @page {
        size: A4;
        size: auto;   /* auto is the initial value */
        margin: 0;  /* this affects the margin in the printer settings */
    }
</style>
<body onload="window.print()">
    <div class="row gambar">
         <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
    <table width="100%" style="font-size:16px">
        <tbody>
        <tr>
            <td align="center">DETAIL PERMINTAAN ANGGARAN INVENTORY</td>
        </tr> 
        <tr>
            <td>&nbsp</td>
        </tr> 
        </tbody>
    </table> 
    <table width="100%" style="font-size:12px"> 
        <tbody>
        <tr>
            <td width="6%">Nomor </td>
            <td width="10px">:</td>
            <td align="left"> 
                <b>
                    <%= left(dataH("memoID"),4) %>/<%=mid(dataH("memoId"),5,3) %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
                </b>
            </td>
            <td width="6%">
                Cabang 
            </td>
            <td width="10px">
                : 
            </td>
            <td align="left">
                <% call getAgen(dataH("memoAgenID"),"p") %> 
            </td>
        </tr> 
        <tr>
            <td width="6%">Hari </td>
            <td width="10px">:</td>
            <td align="left"> 
                <%call getHari(weekday(dataH("memoTgl"))) %>
            </td>
            <td width="6%">
                Departement 
            </td>
            <td width="10px">
                : 
            </td>
            <td align="left">
                <%= dataH("DepNama") %> 
            </td>
        </tr> 
        <tr>
            <td width="6%">Tanggal </td>
            <td width="10px">:</td>
            <td align="left"> 
                <%= Cdate(dataH("memoTgl")) %>
            </td>
            <td width="6%">
                Divisi 
            </td>
            <td width="10px">
                : 
            </td>
            <td align="left">
                <% call getDivisi(dataH("memoDivID")) %>
            </td>
        </tr>
        <tr>
            <td width="6%"> 
                Kebutuhan
            </td>
            <td width="10px"> 
                :
            </td>
            <td> 
                <%= dataH("K_Name") %>
            </td>
            <td width="6%"> 
                Note
            </td>
            <td width="10px"> 
                :
            </td>
            <td> 
                <%= dataH("memoketerangan") %>
            </td>
        </tr> 
        <tr>
            <td>&nbsp</td>
        </tr> 
        </tbody>
    </table> 
    <table width="100%" style="font-size:12px" id="cdetail">
        <tbody>
            <tr>
                <th>No</th>
                <th>Item</th>
                <th>Spesification</th>
                <th>Quantity</th>
                <th>Satuan</th>
                <th>Keterangan</th>
            </tr>
            <% 
            data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY memoItem ASC"
            ' response.write data_cmd.commandText
            set dataD = data_cmd.execute

            no = 0
            do while not dataD.eof
            no = no + 1
            %>
                <tr>
                    <th><%= no %></th>
                    <td><%= dataD("Brg_Nama") %></td>
                    <td><%= dataD("memoSpect") %></td>
                    <td><%= dataD("memoQtty") %></td>
                    <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                    <td>
                        <%= dataD("memoKeterangan") %>
                    </td>
                </tr>
            <% 
            dataD.movenext
            loop
            %>
        </tbody>
    </table>
    <table width="50%">
        <tbody>
            <tr>
                <td> 
                    &nbsp
                </td>
            </tr>
            <tr >
                <td style="padding:10px;background-color:#7FFFD4;font-size:14px;" > 
                    Formulir Pengajuan Anggaran <%= dataH("DepNama") %>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp
                </td>
            </tr>
        </tbody>
    </table>
    <table id="cdetail2">
        <tbody>
            <tr>
                <td>
                    Menyetujui
                </td>
                <td>
                    Mengajukan
                </td>
            </tr>
            <tr>
                <td>
                    <div style="height: 50px; overflow:hidden;">
                        
                    </div>
                </td>
                <td>
                    <div style="height: 50px; overflow:hidden;">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    FX Deni Arijanto
                </td>
                <td>
                    Andika P.
                </td>
            </tr>
        </tbody>
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