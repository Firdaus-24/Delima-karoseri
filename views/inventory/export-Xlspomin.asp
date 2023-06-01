<!--#include file="../../init.asp"-->
<% 
    if session("INV6D") = true then
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    ' cek kebutuhan
    if dataH("memoKebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif dataH("memoKebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif dataH("memoKebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if
%>
<% call header("Detail Barang Kurang") %>
<style>
    body{
        padding:10px;
        -webkit-print-color-adjust:exact !important;
        print-color-adjust:exact !important;
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
            <td align="center">DETAIL PERMINTAAN ANGGARAN KURANG</td>
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
                <%= kebutuhan %>
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
                <th scope="col">Pesan</th>
                <th scope="col">PO</th>
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

            ' cek data po 
            data_cmd.commandText = "SELECT OPD_QtySatuan FROM DLK_T_OrPemD LEFT OUTER JOIN DLK_T_OrPemH ON LEFT(DLK_T_OrPemD.OPD_OPHID,13) = DLK_T_OrPemH.OPH_ID WHERE DLK_T_OrPemH.OPH_MemoID = '"& id &"' AND OPD_Item = '"& dataD("memoItem") &"' AND OPH_AktifYN = 'Y'"
            ' response.write data_cmd.commandText & "<br>"
            set datapo = data_cmd.execute
            
            if not datapo.eof then
                qtypo = datapo("OPD_Qtysatuan")
            else
                qtypo = 0
            end if

            if dataD("memoQtty") > qtypo then
                classbg = "style='background-color:yellow'"
            else
                classbg = ""
            end if
            %>
                <tr <%= classbg %>>
                    <th><%= no %></th>
                    <td><%= dataD("Brg_Nama") %></td>
                    <td><%= dataD("memoSpect") %></td>
                    <td><%= dataD("memoQtty") %></td>
                    <td><%= qtypo %></td>
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
<% 
    call footer()
%>