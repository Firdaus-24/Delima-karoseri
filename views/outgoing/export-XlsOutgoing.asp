<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_ceil.asp"-->
<% 
  if session("INV4D") = false then
      Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))


  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_Weblogin.realname FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_MaterialOutH.MO_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

  set data = data_cmd.execute

  ' detail data
  data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

  set ddata = data_cmd.execute

  call header("Detail Outgoing")
%>
<style>
  * {
    font-size: 12px;
  }

  body {
    margin: 10px;
  }

  .border {
    border: 1px solid black;
  }

  .labelHeaderIncr {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 80px;
    align-items: center;
    line-height: 10px;
    font-size: 12px;
    margin-top: 30px;
  }

  .gambar {
    width: 90px;
    height: 80px;
    position: absolute;
    right: 70px;
    line-height: 10px;
  }

  .gambar img {
    position: absolute;
    width: 90px;
    height: 50px;
  }

  .rowIncrd {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    column-gap: 10px;
    row-gap: 1em;
  }

  .tableIncrd {
    font-size: 12px;
    margin-top: 10px;
    border-collapse: collapse;
    text-align: center;
    width: 100%;
  }

  .tableIncrd,
  td,
  th {
      border: 1px solid black;
  }

  @page {
    size: A4 portrait;
    margin: 5mm;
  }

  @media print {

      html,
      body {
          width: 210mm;
          height: 297mm;
      }

      .tableIncrd {
          width: 97%;
          page-break-inside: auto;
      }

      .tableIncrd tr {
          page-break-inside: avoid;
          page-break-after: auto;
      }

      /* ... the rest of the rules ... */
  }
</style>
<body onload="window.print()"> 
  <div class="rowIncrd gambar">
    <div class="col ">
      <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
    </div>
  </div>
  <div class='labelHeaderIncr'>
    <span><h3>DETAIL BARANG OUTGOING</h3></span>
    <span><h3><%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4) %></h3></span>
  </div>
  <div class='rowIncrd'>
    <span>No Produksi</span>
    <span>: <%if data("MO_type") = "R" then%>
            <%=LEFT(data("MO_PDDPDRID"),3) &"-"& MID(data("MO_PDDPDRID"),4,2) &"/"& RIGHT(data("MO_PDDPDRID"),3) %>
            <%else%><%= left(data("MO_PDDPDRID"),2) %>-<%= mid(data("MO_PDDPDRID"),3,3) %>/<%= mid(data("MO_PDDPDRID"),6,4) %>/<%= mid(data("MO_PDDPDRID"),10,4) %>/<%= right(data("MO_PDDPDRID"),3) %> <%end if%>
    </span>
    <span>Cabang</span>
    <span>: <%= data("agenname") %></span>
  </div>
  <div class="rowIncrd">
    <span>
      Tanggal
    </span>
    <span>
      : <%= Cdate(data("MO_Date")) %>
    </span>
    <span>
      Update ID
    </span>
    <span>
      : <%= data("realname") %>
    </span>
  </div>
  <div class="rowIncrd">
    <span>
      Jenis
    </span>
    <span>
      : <%if data("MO_type") = "R" then%>
        Repair
        <%else%>
        Project
        <%end if%>
    </span>
    <span>
      Keterangan
    </span>
    <span>
      : <%= data("MO_Keterangan") %>
    </span>
  </div>
  <table width="100%" class="tableIncrd">
    <tr>
      <th>Tanggal</th>
      <th>Kategori</th>
      <th>Jenis</th>
      <th>Item</th>
      <th>Quantity</th>
      <th>Satuan</th>
      <th>Rak</th>
      <th>Harga</th>
      <th>Total</th>
    </tr>
    <% 
    gtotal = 0
    total = 0
    do while not ddata.eof
    total =  ddata("MO_Harga") * ddata("MO_QtySatuan")
    gtotal = gtotal + total
    %>
      <tr>
        <th>
          <%= ddata("MO_Date") %>
        </th>
        <th>
          <%= ddata("KategoriNama") %>
        </th>
        <th>
          <%= ddata("jenisNama") %>
        </th>
        <td>
          <%= ddata("Brg_Nama") %>
        </td>
        <td>
          <%= ddata("MO_QtySatuan") %>
        </td>
        <td>
          <%= ddata("Sat_Nama") %>
        </td>
        <td>
          <%= ddata("Rak_Nama") %>
        </td>
        <td align="right">
          <%= replace(formatCurrency(ddata("MO_Harga")),"$","") %>
        </td>
        <td align="right">
          <%= replace(formatCurrency(ceil(total)),"$","") %>
        </td>
      </tr>
    <% 
    Response.flush
    ddata.movenext
    loop
    %>
    <tr>  
      <th colspan="8">Grand Total</th>
      <td class="text-end">
        <%= replace(formatCurrency(ceil(gtotal)),"$","") %>
      </td>
    </tr> 
  </table>
</body>
<% 
    call footer()
%>