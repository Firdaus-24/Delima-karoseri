<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    if session("INV1D") = false then
        Response.Redirect("../index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name, DLK_M_Weblogin.RealName FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_Memo_H.memoupdateid = DLK_M_Weblogin.userid WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    ' detail
    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY memoItem ASC"
    ' response.write data_cmd.commandText
    set dataD = data_cmd.execute


%>
<% call header("Detail Permintaan Anggaran") %>
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
    .footer article{
      font-size:10px;
    }
    @page {
        size: A4 portrait;
        margin: 5mm;  /* this affects the margin in the printer settings */
    }
    @media print
    {    
        body {
            width:   210mm;
            height:  297mm;
        }
        table { 
            page-break-inside:auto; 
        }
        tr    { 
        page-break-inside:avoid; 
        page-break-after:auto;
        }
        td    { page-break-inside:avoid; page-break-after:auto }
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
            <td align="center">DETAIL PERMINTAAN ANGGARAN PEMBELANJAAN</td>
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
                <%= dataH("DivNama") %>
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
        <thead>
            <tr>
                <th>No</th>
                <th>Kode</th>
                <th>Item</th>
                <th>Spesification</th>
                <th>Quantity</th>
                <th>Satuan</th>
                <th>Keterangan</th>
            </tr>
        </thead>
        <tbody>
            <% 
            no = 0
            do while not dataD.eof
            no = no + 1
            %>
                <tr>
                    <th><%= no %></th>
                    <td>
                        <%= dataD("KategoriNama") &"-"& dataD("jenisNama") %>
                    </td>
                    <td><%= dataD("Brg_Nama") %></td>
                    <td><%= dataD("memoSpect") %></td>
                    <td><%= dataD("memoQtty") %></td>
                    <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                    <td>
                        <%= dataD("memoKeterangan") %>
                    </td>
                </tr>
            <% 
            response.flush
            dataD.movenext
            loop
            %>
        </tbody>
    </table>
</body>
<% 
    call footer()
%>