<!--#include file="../init.asp"-->  
<% 
    cabang = trim(Request.Form("cabang"))
    nama = trim(Request.Form("nama"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    if nama <> "" then
        filterNama = "AND Brg_Nama LIKE '%"& nama &"%'"
    else
        filterNama = ""
    end if

    if cabang <> "" then
        filterCabang = "AND LEFT(Brg_ID,3) = '"& cabang &"'"
    else 
        filterCabang = ""
    end if

    data_cmd.commandText = "SELECT DLK_M_Barang.*, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_TypeBarang.T_ID WHERE Brg_AktifYN = 'Y' AND (T_Nama = 'PRODUKSI' OR T_Nama = 'SUB PART' )"& filterCabang &" "& filterNama &" ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

%>
<% if nama = "" then %>
    <select class="form-select" aria-label="Default select example" name="barang" id="barang" required> 
        <option value="">Pilih</option>
        <% do while not barang.eof %>
            <option value="<%=barang("Brg_ID") %>"><%=  "<b>" & barang("KategoriNama") &"-"& barang("JenisNama") & "</b>" &" | "& barang("Brg_Nama") %></option>
        <% 
        barang.movenext
        loop
        %>
    </select>
<% else %>
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
<% end if %>