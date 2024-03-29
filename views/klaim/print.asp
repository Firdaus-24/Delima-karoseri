<!--#include file="../../init.asp"-->   
<% 
    if session("INV3D") = false then
        Response.Redirect("../index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_DelBarang.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.GLB_M_Agen.AgenID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_DelBarang.DB_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_Jenisbarang.JenisID WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') AND (dbo.DLK_T_DelBarang.DB_id = '"& id &"')"

    set data = data_cmd.execute

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
            text-align: center;
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
            font-size:10px;
            border-collapse: collapse;
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
         <div class="col">
            <img src="../../public/img/pt.png" alt="delimapanjang">
        </div>
    </div>
    &nbsp
    <div class="row">
        <div class="col-sm-12 text-center">
            <h5>DATA BARANG RUSAK</h5>
        </div>
    </div>
    <table id="cdetail">
        <tr>
            <th>
                Nomor
            </th>
            <th>
                <%= data("DB_ID") %>
            </th>
        </tr>
        <tr>
            <th>
                Tanggal
            </th>
            <td>
                <%= Cdate(data("DB_Date")) %>
            </td>
        </tr>
        <tr>
            <th>
                Cabang
            </th>
            <td>
                <%= data("AgenName") %>
            </td>
        </tr>
        <tr>
            <th>
                Barang
            </th>
            <td>
                <%= data("Brg_nama") %>
            </td>
        </tr>
        <tr>
            <th>
                Kode
            </th>
            <td>
                <%= data("kategoriNama") &"-"& data("JenisNama") %>
            </td>
        </tr>
        <tr>
            <th>
                Quantity
            </th>
            <td>
                <%= data("DB_Qtysatuan") %>
            </td>
        </tr>
        <tr>
            <th>
                satuan
            </th>
            <td>
                <%= data("sat_Nama") %>
            </td>
        </tr>
        <tr>
            <th colspan="2">
                Document
            </th>
        </tr>
        <tr>
            <th>
                file
            </th>
            <td>
                <% 
                set fs = server.createObject("Scripting.FileSystemObject")
                path =  "D:Delima\document\pdf\"& data("DB_ID") &".pdf"
                if fs.FileExists(path) then
                %>
                    ada
                <% 
                else
                %>
                    kosong
                <%end if
                set fs = Nothing
                %>
            </td>
        </tr>
        <tr>
            <th>
                gambar 1
            </th>
            <td>
                <% 
                if data("DB_image1") <> "" then
                %>
                    <img src="<%= url %>document/image/<%= data("DB_image1") &".jpg" %>" width="40px">
                <% 
                else
                %>
                    -
                <%end if%>
            </td>
        </tr>
        <tr>
            <th>
                gambar 2
            </th>
            <td>
                <% 
                if data("DB_image2") <> "" then
                %>
                    <img src="<%= url %>document/image/<%= data("DB_image2") &".jpg" %>" width="40px">
                <% 
                else
                %>
                    -
                <%end if%>
            </td>
        </tr>
        <tr>
            <th>
                gambar 3
            </th>
            <td>
                <% 
                if data("DB_image3") <> "" then
                %>
                    <img src="<%= url %>document/image/<%= data("DB_image3") &".jpg" %>" width="40px">
                <% 
                else
                %>
                    -
                <%end if%>
            </td>
        </tr>
        <tr>
            <th>
                Acc 1
            </th>
            <td>
                <%= data("DB_Acc1") %>
            </td>
        </tr>
        <tr>
            <th>
                Acc 2
            </th>
            <td>
                <%= data("DB_Acc2") %>
            </td>
        </tr>
        <tr>
            <th>
                Keterangan
            </th>
            <td>
                <%= data("DB_keterangan") %>
            </td>
        </tr>
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
<% call footer() %>
