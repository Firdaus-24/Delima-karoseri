<!--#include file="../../init.asp"-->
<% 
    venagenid = trim(Request.Form("venagenID"))
    jenis = trim(Ucase(Request.Form("keybrgjnsvendor")))
    kategori = trim(Ucase(Request.Form("keybrgvendor")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    if jenis <> "" then
        filterjenis = " AND DLK_M_JenisBarang.JenisNama LIKE '%"& jenis &"%'"
    else 
        filterjenis = ""
    end if
    if kategori <> "" then
        filterkategori = " AND DLK_M_kategori.kategoriNama LIKE '%"& kategori &"%'"
    else 
        filterkategori = ""
    end if

    data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_Barang.JenisID, DLK_M_Barang.KategoriID, DLK_M_JenisBarang.JenisNama, DLK_M_Kategori.KategoriNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE Brg_AktifYN = 'Y' AND LEFT(Brg_ID,3) = '"& venagenid &"' "& filterjenis &" "& filterkategori &" ORDER BY Brg_Nama ASC"
    ' response.write data_cmd.commandText
    set barang = data_cmd.execute
%>
    <%  
    no = 0
    do while not barang.eof 
    no = no + 1
    %>
    <tr>
    <th scope="row"><%= no %></th>
    <td>
        <%= barang("kategoriNama") &"-"& barang("jenisNama") %>
    </td>
    <td><%= barang("Brg_Nama") %></td>
    <td class="text-center">    
        <div class="form-check">
            <input class="form-check-input" type="radio" name="ckdvendor" id="ckdvendor" value="<%= barang("Brg_ID") %>" required>
        </div>
    </td>
    </tr>
    <% 
    barang.movenext
    loop
    %>
