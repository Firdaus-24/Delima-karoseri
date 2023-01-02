<!--#include file="../init.asp"-->
<% 
    cabang = trim(Request.form("cabang"))
    nama = trim(Request.form("nama"))

    if nama <> "" then
        filterNama = " AND (dbo.DLK_M_Barang.Brg_Nama LIKE '%"& nama &"%')"
    else
        filterNama = ""
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_TypeBarang.T_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) as stok, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga, ISNULL((SELECT TOP 1 dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE DLK_T_MaterialReceiptD2.MR_Item = DLK_M_Barang.Brg_ID GROUP BY Sat_nama),'') as lsatuan, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga, ISNULL((SELECT TOP 1 dbo.DLK_M_SatuanBarang.Sat_id FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE DLK_T_MaterialReceiptD2.MR_Item = DLK_M_Barang.Brg_ID GROUP BY Sat_id),'') as satuan FROM DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item WHERE Brg_AktifYN = 'Y' AND LEFT(dbo.DLK_M_Barang.Brg_ID,3) = '"&cabang&"' "&filterNama&" GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_ID, dbo.DLK_T_MaterialReceiptD2.MR_Harga HAVING ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0),0) > 0 OR ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0),0) <> 0 ORDER BY Brg_Nama, T_Nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

%>
    <article style="height: 15rem;overflow-y:auto;margin-bottom:10px">
    
    <table class="table">
        <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
        <tr>
            <td>
                Jenis/Kategori
            </td>
            <td>
                Nama
            </td>
            <td>
                Stok
            </td>
            <td>
                Satuan
            </td>
            <td>
                Harga
            </td>
            <td>
                Pilih
            </td>
        </tr>
        </thead>
    <tbody>
    <% 
    do while not data.eof 
    %>
    <tr>
        <th scope="row">
            <%= data("KategoriNama") &"-"& data("JenisNama")  %>
        </th>
        <td><%= data("Brg_Nama") %></td>
        <td><%= data("stok") %></td>
        <td><%= data("lsatuan") %></td>
        <td><%= replace(formatCurrency(data("harga")),"$","") %></td>
        <td class="text-center">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="ckdelbarang" id="ckdelbarang" onclick="getBrgDelete('<%= data("Brg_ID") %>','<%= data("Brg_Nama") %>','<%= data("stok") %>', '<%= data("satuan") %>', '<%= data("harga") %>')">
            </div>
        </td>
    </tr>
    <% 
    response.flush
    data.movenext
    loop
    %>
    </tbody>
    </table>
    </article>
