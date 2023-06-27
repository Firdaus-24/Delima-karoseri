<!--#include file="../../init.asp"-->
<%
  if session("DJTF1D") = false then
    Response.Redirect("./")
  end if

  nama = trim(Request.QueryString("n"))
  cabang = trim(Request.QueryString("c"))
  kategori = trim(Request.QueryString("k"))
  jenis = trim(Request.QueryString("j"))

  ' query seach 
  if nama <> "" then
    filterNama = " AND UPPER(DLK_M_Barang.Brg_Nama) LIKE '%"& Ucase(nama) &"%' "
  end if
  if kategori <> "" then
    filterKat = " AND DLK_M_Barang.KategoriId = '"& kategori &"'"
  end if
  if jenis <> "" then
    filterJen = " AND DLK_M_Barang.jenisID = '"& jenis &"'"
  end if
  if cabang <> "" then
    filterAgen = " AND LEFT(Brg_ID,3) = '"& cabang &"'"
  end if

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT DLK_M_Barang.*, DLK_M_TypeBarang.T_Nama, DLK_M_kategori.KategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.Brg_Type = DLK_M_TypeBarang.T_ID LEFT OUTER JOIN DLK_M_KAtegori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.JenisID WHERE Brg_AktifYN = 'Y' AND (Brg_type = 'T12' OR Brg_type = 'T06') "& filterNama &""& filterKat &""& filterJen &" "& filterAgen &""

  set rs = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=Master Alat & Facility.xls"
%>

<table width="100">
  <thead class="bg-secondary text-light">
    <tr>
      <th colspan="5" align="center">MASTER ALAT & FACILITY<th>
    </tr>
    <tr>
      <th colspan="5" align="center">&nbsp<th>
    </tr>
    <tr>
      <th style="background-color: #0000ff;color:#fff;">No</th>
      <th style="background-color: #0000ff;color:#fff;">Nama</th>
      <th style="background-color: #0000ff;color:#fff;">Kategori</th>
      <th style="background-color: #0000ff;color:#fff;">Jenis</th>
      <th style="background-color: #0000ff;color:#fff;" >Type</th>
      <th style="background-color: #0000ff;color:#fff;" >Aktif</th>
    </tr>
  </thead>
  <tbody>
    <% 
      no = 0
      do while not rs.eof
      no = no + 1
    %>
      <tr>
        <td style="border-collapse: collapse;border:1px solid black;"><%= no %></td>
        <td style="border-collapse: collapse;border:1px solid black;"><%= rs("Brg_Nama") %></td>
        <td style="border-collapse: collapse;border:1px solid black;"><%= rs("kategoriNama") %></td>
        <td style="border-collapse: collapse;border:1px solid black;"><%= rs("JenisNama") %></td>
        <td style="border-collapse: collapse;border:1px solid black;"><%= rs("T_Nama")%></td>
        <td style="border-collapse: collapse;border:1px solid black;"><%if rs("Brg_AktifYN") = "Y" then%>Aktif <% end if %></td>
      </tr>
      <% 
      Response.flush
      rs.movenext
      loop
      %>
  </tbody>
</table>