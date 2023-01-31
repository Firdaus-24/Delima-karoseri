<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=Detail Product "& Request.QueryString("id")&" .xls"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID,  DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_M_BOMD.BMDBMID,12) = '"& data("BMID") &"' ORDER BY BMDBMID ASC"

    set ddata = data_cmd.execute

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
    .drawing{
        margin-top:20px;
        padding:5px;
        width:100%;
        height:10em;
        display:flex;
    }
    .images{
        width:12em;
        margin:10px;
        padding:0;
        text-align: center;
        vertical-align:center;
        overflow:hidden;
        border:1px solid black;
    }
    .images span{
        display:block;
        top:0;
        padding:0;
        font-family: Verdana, sans-serif;
        font-weight:bold;
        font-size:12px;
        font-style: oblique;
    }
    .images img{
        display:inline-block;
        width:12rem;
        height:110px;
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
                DETAIL BARANG B.O.M
            </td>
        </tr>
        <tr class="row">
            <td colspan="5" align="center">
                <%= left(id,2) %>-<%=mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,3) %>
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
                : <%= Cdate(data("BMDate")) %>
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
                Approve
            </td>
            <td colspan="2">
                : <%If data("BMApproveYN") = "Y" then %>Yes <% else %>No <% end if %>
            </td>
        </tr>
        <tr>
            <td>
                Keterangan
            </td>
            <td colspan="4">
                : <%= data("BMKeterangan") %>
            </td>
        </tr>
        <tr>
            <td colspan="5">&nbsp<td>
        </tr>
    </table>
    <table id="cdetail" style="font-size:12px">
        <tr>
            <th scope="col">ID</th>
            <th scope="col">Kode</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
        </tr>
        <% 
        do while not ddata.eof 
        %>
            <tr>
                <th>
                    <%= left(ddata("bmDbmID"),2) %>-<%=mid(ddata("bmDbmID"),3,3) %>/<%= mid(ddata("bmDbmID"),6,4) %>/<%= mid(ddata("BMDBMID"),10,3) %>/<%= right(ddata("BMDBMID"),3) %>
                </th>
                <td>
                    <%= ddata("kategoriNama") &"-"& ddata("JenisNama") %>
                </td>
                <td>
                    <%= ddata("Brg_Nama") %>
                </td>
                <td>
                    <%= ddata("BMDQtty") %>
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
    <div class="drawing">
        <div class="images">
            <span>Drawing 1 </span>
            <% if data("BMimg1") <> "" then%>
            <img src="<%= url %>document/stack/<%= data("BMimg1") &".jpg" %>">
            <% end if %>
        </div>
        <div class="images">
            <span>Drawing 2 </span>
            <% if data("BMimg2") <> "" then%>
            <img src="<%= url %>document/stack/<%= data("BMimg2") &".jpg" %>">
            <% end if %>
        </div>
        <div class="images">
            <span>Drawing 3 </span>
            <% if data("BMimg3") <> "" then%>
            <img src="<%= url %>document/stack/<%= data("BMimg3") &".jpg" %>">
            <% end if %>
        </div>
    </div>
<% 
    call footer()
%>