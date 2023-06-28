<!--#include file="../../init.asp"-->
<% 
    if session("ENG2D") = false then
        Response.Redirect("./")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

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
        <tr>
            <td colspan="5" align="center">
                DETAIL MASTER B.O.M
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
                Kode Model
            </td>
            <td>
                : <%= data("kategoriNama") &" - "& data("JenisNama") %>
            </td>
            <td>
                Nama Model
            </td>
            <td>
                : <%= data("Brg_Nama") %>
            </td>
            
        </tr>
        <tr>
            <td>
                Man Power
            </td>
            <td>
                : <%= data("BMmanpower") %>
            </td>
            <td>
                Anggaran Man Power
            </td>
            <td>
                : <%= replace(formatCurrency(data("BMtotalsalary")),"$","Rp. ") %>
            </td>
            
        </tr>
        <tr>
            <td>
                No.Drawing
            </td>
            <td>
                : <%= LEft(data("BMSasisID"),5) &"-"& mid(data("BMSasisID"),6,4) &"-"& right(data("BMSasisID"),3) %>
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
            <th scope="col">No</th>
            <th scope="col">Kode</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
        </tr>
        <% 
        no = 0
        do while not ddata.eof 
        no = no + 1
        %>
            <tr>
                <th>
                    <%= no %>
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
        response.flush
        ddata.movenext
        loop
        %>
    </table>
<% 
    call footer()
%>