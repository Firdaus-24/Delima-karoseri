<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=Detail Product "& Request.QueryString("id")&" .xls"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductH.*, dbo.DLK_M_Barang.Brg_Nama, GL_M_CategoryItem.cat_name, GLB_M_Agen.AgenName FROM dbo.DLK_T_ProductH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductH.PDBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GL_M_CategoryItem ON DLK_T_ProductH.PDKodeAKun = GL_M_CategoryItem.cat_id LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProductH.pdAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_ProductH.pdID = '"& id &"' AND dbo.DLK_T_ProductH.pdAktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_ProductD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_ProductD.PDDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductD.PDDItem = dbo.DLK_M_Barang.Brg_Id WHERE LEFT(dbo.DLK_T_ProductD.PDDPDID,12) = '"& data("PDID") &"' ORDER BY PDDPDID ASC"

    set ddata = data_cmd.execute

    ' getbarang 
    data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& data("PDBrgID") &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

    ' get jenis satuan
    data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Detail Product")
%>
<style>
    body{
        padding:10px;
    }
    .gambar{
        width:200px;
        height:80px;
        /* right:70px; */
        position:absolute;
    }
    .gambar img{
        position:absolute;
        width:120px;
        height:50px;
    }
    #cdetail > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }
    @page {
        size: A4;
        size: auto;   /* auto is the initial value */
        margin: 0;  /* this affects the margin in the printer settings */
    }
    #cdetail{
        width:100%;
        font-size:12px;
        border-collapse: collapse;
    }
</style>
<body onload="window.print()">
    <table width="100%" style="font-size:16px">
        <tr>
        <div class="row gambar">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
        </tr>
        <tr>
            <td colspan="5" align="center">
                DETAIL BARANG PRODUKSI
            </td>
        </tr>
        <tr class="row">
            <td colspan="5" align="center">
                <%= id %>
            </td>
        </tr>
        <tr class="row">
            <td colspan="5" align="center">
                &nbsp
            </td>
        </tr>
    </table>
    <table width="100%" style="font-size:12px">
        <tr>
            <td>
                Tanggal
            </td>
            <td>
                : <%= Cdate(data("PDDate")) %>
            </td>
            <td>
                Cabang
            </td>
            <td colspan="2">
                : <%= data("agenName") %>
            </td>
        </tr>
        <tr>
            <td>
                Barang
            </td>
            <td>
                : <%= data("Brg_Nama") %>
            </td>
            <td>
                Kode Akun
            </td>
            <td colspan="2">
                : <%= data("cat_name") %>
            </td>
        </tr>
        <tr>
            <td>
                Keterangan
            </td>
            <td colspan="4">
                : <%= data("PDKeterangan") %>
            </td>
        </tr>
        <tr>
            <td colspan="5">&nbsp<td>
        </tr>
    </table>
    <table id="cdetail" style="font-size:12px">
        <tr>
            <th scope="col">ID</th>
            <th scope="col">Item</th>
            <th scope="col">Sepesification</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
        </tr>
        <% 
        do while not ddata.eof 
        %>
            <tr>
                <th>
                    <%= ddata("PDDPDID") %>
                </th>
                <td>
                    <%= ddata("Brg_Nama") %>
                </td>
                <td>
                    <%= ddata("PDDSpect") %>
                </td>
                <td>
                    <%= ddata("PDDQtty") %>
                </td>
                <td>
                    <%= ddata("sat_nama") %>
                </td>
            </tr>
        <% 
        ddata.movenext
        loop
        %>
    </table>
<% 
    call footer()
%>