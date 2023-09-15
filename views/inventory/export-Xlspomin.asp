<!--#include file="../../init.asp"-->
<% 
    if session("INV6D") = false then
        Response.Redirect("./")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama,  DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_Memo_D.memosatuan = DLK_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"

    set dataD = data_cmd.execute

    call header("Detail Barang Kurang") %>
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
                <%= dataH("agenname") %> 
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
                <%= dataH("divnama") %>
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
                <%= dataH("K_name") %>
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
                <th scope="col">No</th>
                <th scope="col">Kategori</th>
                <th scope="col">Jenis</th>
                <th scope="col">Barang</th>
                <th scope="col">Pesan</th>
                <th scope="col">PO</th>
                <th scope="col">Satuan</th>
                <th scope="col">Type</th>
                <th scope="col">Keterangan</th>
            </tr>
            <% 
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
                    <th scope="row"><%= no %></th>
                    <td ><%= dataD("kategorinama") %></td>
                    <td ><%= dataD("Jenisnama") %></td>
                    <td><%= dataD("Brg_Nama") %></td>
                    <td><%= dataD("memoQtty") %></td>
                    <td><%= qtypo %></td>
                    <td><%= dataD("Sat_nama") %></td>
                    <td>
                        <%= dataD("T_nama") %>
                    </td>
                    <td>
                        <%= dataD("memoKeterangan") %>
                    </td>
                </tr>
            <% 
            Response.flush
            dataD.movenext
            loop
            %>
        </tbody>
    </table>
<% 
    call footer()
%>