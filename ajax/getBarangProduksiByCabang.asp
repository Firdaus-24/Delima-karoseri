<!--#include file="../init.asp"-->  
<% 
   cabang = trim(Request.Form("cabang"))
   nama = trim(Request.Form("nama"))
   bomid = trim(Request.Form("bomid"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_String

   if nama <> "" then
      filterNama = "AND Brg_Nama LIKE '%"& Ucase(nama) &"%'"
   else
      filterNama = ""
   end if

   data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama, DLK_M_TypeBarang.T_Nama  FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.Brg_type = DLK_M_TypeBarang.T_ID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& bomid &"' AND LEFT(BRg_ID,3) = '"& cabang &"' "& filterNama &" ORDER BY T_Nama, Brg_Nama ASC"
   ' response.write data_cmd.commandText & "<br>"
   set barang = data_cmd.execute


   if not barang.eof then
      do while not barang.eof %>
      <tr>
         <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
         <td><%= barang("brg_nama") %></td>
         <td><%= barang("T_nama") %></td>
         <td>
            <div class="form-check">
               <input class="form-check-input" type="radio" name="ckproduckd" id="ckproduckd" value="<%= barang("Brg_ID") %>" required>
            </div>
         </td>
      </tr>
      <% 
      barang.movenext
      loop
   else
      %>
   <tr rowspan="2" class="bg-danger text-light text-center" >
      <td colspan="4">DATA TIDAK DITEMUKAN</td>
   </tr>
   <%end if%>