<!--#include file="../init.asp"-->
<% 
    nama = trim(Request.form("nama"))
    cabang = trim(Request.form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_T_VendorD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VendorD.Dven_BrgID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE (dbo.DLK_T_VendorD.Dven_BrgID <> '') AND (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (left(dbo.DLK_M_Barang.Brg_Id,3) = '"& cabang &"') AND (dbo.DLK_M_Barang.Brg_nama LIKE '%"& nama &"%')GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama ORDER BY Brg_Nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute
%>
    <% do while not barang.eof %>
    <tr>
        <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
        <td><%= barang("brg_nama") %></td>
        <td>
            <div class="form-check">
                <input class="form-check-input" type="radio" name="brg" id="brg" value="<%= barang("Brg_ID") %>" required>
            </div>
        </td>
    </tr>
    <% 
    barang.movenext
    loop
    %>
