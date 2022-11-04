<!--#include file="../../init.asp"-->   
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_DelBarang.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.GLB_M_Agen.AgenID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_DelBarang.DB_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_Jenisbarang.JenisID WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') AND (dbo.DLK_T_DelBarang.DB_id = '"& id &"')"

    set data = data_cmd.execute

    ' acc 1
    data_cmd.commandText = "SELECT username FROM DLK_M_Weblogin WHERE USerID = '"& data("DB_Acc1") &"' AND USerAktifYN = 'Y'"

    set acc1 = data_cmd.execute
    ' acc 2
    data_cmd.commandText = "SELECT username FROM DLK_M_Weblogin WHERE USerID = '"& data("DB_Acc2") &"' AND USerAktifYN = 'Y'"

    set acc2 = data_cmd.execute

    if not acc1.eof then
        pjawab1 = acc1("username") 
    else
        pjawab1 = ""
    end if
    if not acc2.eof then
        pjawab2 = acc2("username") 
    else
        pjawab2 = ""
    end if


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
            font-size:12px;
            border-collapse: collapse;
        }
    </style>
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
                Kategori
            </th>
            <td>
                <%= data("kategoriNama") %>
            </td>
        </tr>
        <tr>
            <th>
                Jenis
            </th>
            <td>
                <%= data("JenisNama") %>
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
                <%= pjawab1 %>
            </td>
        </tr>
        <tr>
            <th>
                Acc 2
            </th>
            <td>
                <%= pjawab2 %>
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

<% call footer() %>
