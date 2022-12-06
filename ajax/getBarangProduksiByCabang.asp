<!--#include file="../init.asp"-->  
<% 
   cabang = trim(Request.Form("cabang"))
   nama = trim(Request.Form("nama"))
   productID = trim(Request.Form("productID"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_String

   if nama <> "" then
      filterNama = "AND Brg_Nama LIKE '%"& Ucase(nama) &"%'"
   else
      filterNama = ""
   end if

   data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& productID &"' AND LEFT(BRg_ID,3) = '"& cabang &"' "& filterNama &" ORDER BY Brg_Nama ASC"

   set barang = data_cmd.execute

%>
<% do while not barang.eof %>
   <tr>
      <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
      <td><%= barang("brg_nama") %></td>
      <td>
         <div class="form-check">
            <input class="form-check-input" type="radio" name="ckproduckd" id="ckproduckd" value="<%= barang("Brg_ID") %>" required>
         </div>
      </td>
   </tr>
<% 
barang.movenext
loop
%>