<!--#include file="../connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<% 
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name, DLK_M_Weblogin.RealName FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_Memo_H.memoupdateid = DLK_M_Weblogin.userid WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
  ' response.write data_cmd.commandText
  set dataH = data_cmd.execute

  ' detail
  data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_SatuanBarang.Sat_nama, DLK_M_TypeBarang.T_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_satuanbarang ON DLK_T_Memo_D.memosatuan = dlk_M_Satuanbarang.sat_ID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"
  ' response.write data_cmd.commandText
  set dataD = data_cmd.execute


%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Detail Permintaan Anggaran</title>
  <link href="../public/css/bootstrap.min.css" rel="stylesheet" />
  <script src="../public/js/bootstrap.bundle.min.js"></script>
  <!-- sweet alert -->
  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <link href='../public/img/delimalogo.png' rel='website icon' type='png' />
</head>
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
  <table width="100%" style="font-size:12px"> 
    <tr>
      <td align="center" colspan="8"><b>DETAIL PERMINTAAN ANGGARAN PEMBELANJAAN</b></td>
    </tr> 
    <tr>
      <td align="center" colspan="8"><b><%= left(dataH("memoID"),4) %>/<%=mid(dataH("memoId"),5,3) %>-<%= mid(dataH("memoID"),8,3)%>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %></b></td>
    </tr> 
    <tr>
      <td align="center" colspan="8">&nbsp</td>
    </tr> 
    <tr>
      <td>Tanggal </td>
      <td>:</td>
      <td align="left"> 
        <%= Cdate(dataH("memoTgl")) %>
      </td>
      <td>
        Cabang 
      </td>
      <td>
        : 
      </td>
      <td align="left">
        <%= dataH("agenname") %> 
      </td>
    </tr> 
    <tr>
      <td>
        Divisi 
      </td>
      <td>
        : 
      </td>
      <td align="left">
        <%= dataH("DivNama") %>
      </td>
      <td>
        Departement 
      </td>
      <td>
        : 
      </td>
      <td align="left">
        <%= dataH("DepNama") %> 
      </td>
    </tr> 
    <tr>
      <td> 
        No.B.O.M
      </td>
      <td> 
        :
      </td>
      <td> 
        <%if datah("memobmid") <> "" then%> 
          <%= left(datah("memobmid"),2) %>-<%=mid(datah("memobmid"),3,3) %>/<%= mid(datah("memobmid"),6,4) %>/<%= right(datah("memobmid"),3) %>
        <%elseIf datah("memobmrid") <> "" then%> 
          <%= left(datah("memobmrid"),3) %>-<%=mid(datah("memobmrid"),4,3) %>/<%= mid(datah("memobmrid"),7,4) %>/<%= right(datah("memobmrid"),3) %>
        <%end if%>
      <td> 
        No. Produksi
      </td>
      <td> 
        :
      </td>
      <td> 
        <%if datah("memopdhid") <> "" then %> 
          <%= left(datah("memopdhid"),2) %>-<%= mid(datah("memopdhid"),3,3) %>/<%= mid(datah("memopdhid"),6,4) %>/<%= right(datah("memopdhid"),4)  %>
        <%end if%>
      </td>
    </tr> 
    <tr>
      <td> 
        Kebutuhan
      </td>
      <td> 
        :
      </td>
      <td> 
        <%= dataH("K_Name") %>
      </td>
      <td>Capasity</td>
      <td>:</td>
      <td>
        <%if datah("memobmid") <> "" OR datah("memobmrid") <> "" then%> 
          <%= dataH("memocapacty") %> Unit
        <%else%> 
          0
        <%end if%>
      </td>
    </tr> 
    <tr>
      <td>Pengaju</td>
      <td>:</td>
      <td><%=datah("realname")%></td>
      <td> 
        Keterangan
      </td>
      <td> 
        :
      </td>
      <td> 
        <%= dataH("memoketerangan") %>
      </td>
    </tr> 
    <tr>
      <td>&nbsp</td>
    </tr> 
  </table> 
  <table width="100%" style="font-size:12px" id="cdetail">
    <thead>
      <tr>
        <th>No</th>
        <th>Kategori</th>
        <th>Jenis</th>
        <th>Item</th>
        <th>Quantity</th>
        <th>Satuan</th>
        <th>Type</th>
        <th>Keterangan</th>
      </tr>
    </thead>
    <tbody>
      <% 
      no = 0
      do while not dataD.eof
      no = no + 1
      %>
        <tr>
          <th><%= no %></th>
          <td><%= dataD("KategoriNama") %></td>
          <td>
              <%= dataD("jenisNama") %>
          </td>
          <td><%= dataD("Brg_Nama") %></td>
          <td><%= dataD("memoQtty") %></td>
          <td><%= dataD("sat_nama") %></td>
          <td><%= dataD("T_nama") %></td>
          <td>
              <%= dataD("memoKeterangan") %>
          </td>
        </tr>
      <% 
      response.flush
      dataD.movenext
      loop
      %>
    </tbody>
  </table>
<!-- jquery -->
  <script src="../../public/js/jquery-min.js"></script>
  <!-- bootstrap -->
  <script src="../../public/js/bootstrap.min.js"></script>
</body>
</html>