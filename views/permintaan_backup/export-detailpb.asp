<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute
%>
<% call header("Detail Permintaan Barang") %>
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
</style>
    <div class="row gambar">
         <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
    <table width="100%" style="font-size:16px">
        <tbody>
        <tr>
            <td align="center">DETAIL PERMINTAAN BARANG</td>
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
                <th class="text-center">Status</th>
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
                    <td  class="text-center">
                        <% if dataH("memoApproveYN") = "Y" then %>
                            <b style="color:green">Done</b>
                        <% else %>
                            -
                        <% end if %>
                    </td>
                </tr>
            <% 
            dataD.movenext
            loop
            %>
        </tbody>
    </table>
    <table width="100%" style="font-size:12px">
        <tbody>
            <tr>
                <td>
                    &nbsp
                </td>
            </tr>
            <tr>
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
            
        </tbody>
    </table>
    <table width="50%" style="font-size:20px;">
        <tbody>
            <tr>
                <td> 
                    &nbsp
                </td>
            </tr>
            <tr >
                <td style="padding:10px;background-color:#7FFFD4;" > 
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
<% 
    call footer()
%>