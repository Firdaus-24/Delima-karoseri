<!--#include file="../../init.asp"-->
<% 
    if session("INV9D") = false then
        Response.Redirect("./")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name, DLK_M_Weblogin.RealName FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_Memo_H.memoupdateid = DLK_M_Weblogin.userid WHERE memoID = '"& id &"' and memoAktifYN = 'Y' AND memobmrid <> '' AND memobmid = ''"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_Memo_D.memosatuan = DLK_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"
    ' response.write data_cmd.commandText
    set dataD = data_cmd.execute

%>
<% call header("Detail Permintaan Anggaran") %>
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
  #cdetail2 > * > tr > *  {
    border: 1px solid black;
    padding:5px;
  }

  #cdetail2{
    width:30%;
    font-size:12px;
    border-collapse: collapse;
    text-align: center;
    right:10px;
    position:absolute;
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
  <table width="100%" style="font-size:16px">
    <tbody>
      <tr>
        <td align="center">PERMINTAAN ANGGARAN PEMBELANJAAN B.O.M REPAIR</td>
      </tr> 
      <tr>
        <td>&nbsp</td>
      </tr> 
    </tbody>
  </table> 
  <table width="100%" style="font-size:12px"> 
    <tbody>
      <tr>
        <td width="6%">Nomor </td>
        <td width="10px">:</td>
        <td align="left"> 
          <b>
            <%= left(dataH("memoID"),4) %>/<%=mid(dataH("memoId"),5,3) %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
          </b>
        </td>
        <td width="6%">
          Cabang 
        </td>
        <td width="10px">
          : 
        </td>
        <td align="left">
          <%= dataH("AgenName") %> 
        </td>
      </tr> 
      <tr>
        <td width="6%">No. B.O.M </td>
        <td width="10px">:</td>
        <td align="left"> 
          <%= left(datah("memoBMRID"),3)&"-"&MID(datah("memoBMRID"),4,3)&"/"&MID(datah("memoBMRID"),7,4)&"/"&right(datah("memoBMRID"),3)  %>
        </td>
        <td width="6%">
          Departement 
        </td>
        <td width="10px">
          : 
        </td>
        <td align="left">
          <%= dataH("DepNama") %> 
        </td>
      </tr> 
      <tr>
        <td width="6%">Tanggal </td>
        <td width="10px">:</td>
        <td align="left"> 
          <%= Cdate(dataH("memoTgl")) %>
        </td>
        <td width="6%">
          Divisi 
        </td>
        <td width="10px">
          : 
        </td>
        <td align="left">
          <%= dataH("DivNama") %>
        </td>
      </tr>
      <tr>
        <td width="6%"> 
          Kebutuhan
        </td>
        <td width="10px"> 
          :
        </td>
        <td> 
          <%= dataH("K_Name") %>
        </td>
        <td width="6%"> 
          Note
        </td>
        <td width="10px"> 
          :
        </td>
        <td> 
          <%= dataH("memoketerangan") %>
        </td>
      </tr> 
      <tr>
        <td>&nbsp</td>
      </tr> 
    </tbody>
  </table> 
  <table width="100%" style="font-size:12px" id="cdetail">
    <tbody>
      <tr>
        <th>No</th>
        <th>Kode</th>
        <th>Item</th>
        <th>Spesification</th>
        <th>Quantity</th>
        <th>Satuan</th>
        <th>Type</th>
        <th>Keterangan</th>
      </tr>
      <% 
      no = 0
      do while not dataD.eof
      no = no + 1
      %>
        <tr>
          <th><%= no %></th>
          <td>
            <%= dataD("KategoriNama") &"-"& dataD("jenisNama") %>
          </td>
          <td><%= dataD("Brg_Nama") %></td>
          <td><%= dataD("memoSpect") %></td>
          <td><%= dataD("memoQtty") %></td>
          <td><%= dataD("sat_nama") %></td>
          <td><%= dataD("T_Nama") %></td>
          <td>
            <%= dataD("memoKeterangan") %>
          </td>
        </tr>
      <% 
      Response.flush
      dataD.movenext
      loop
      %>
    </tbody>
  </table>
</body>
<% 
    call footer()
%>