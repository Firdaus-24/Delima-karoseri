<!--#include file="../../init.asp"-->
<% 
   if session("PP9D") = false then
      Response.Redirect("./")
   end if
  id =  trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_T_VoucherH.* FROM dbo.DLK_T_VoucherH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_VoucherH.VCH_Agenid = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_VoucherH.VCH_AktifYN = 'Y') AND (dbo.DLK_T_VoucherH.VCH_id = '"& id &"')"

  set data = data_cmd.execute

  if data.eof then
    Response.Redirect("./")
  end if

  ' detail
  data_cmd.commandTExt = "SELECT dbo.DLK_T_VoucherD.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_T_VoucherD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VoucherD.VCH_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_VoucherD.VCH_Satid = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(DLK_T_VoucherD.VCH_VCHID,13) = '"& data("VCH_ID") &"' ORDER BY Brg_Nama, T_Nama ASC"

  set ddata = data_cmd.execute

  call header("Detail Voucher")
%>
<link href="../../public/css/incunit.css" rel="stylesheet" />
<body onload="window.print()"> 
  <div class="rowIncrd gambar">
    <div class="col ">
      <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
    </div>
  </div>
  <div class='labelHeaderIncr'>
    <span><h3>DETAIL VOUCHER</h3></span>
    <span><h3><%=left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)%></h3></span>
  </div>
  <div class='rowIncrd'>
    <span>Cabang / Agen</span>
    <span>: <%=data("agenname")%></span>
    <span>Type Produksi</span>
    <span>: <%if data("VCH_Type") = "N" then %>New Project <%else%>Repair <%end if%></span>
  </div>
  <div class='rowIncrd'>
    <span>New Produksi</span>
    <span>:  <%if data("VCH_PDDID") <> "" then%><%= left(data("VCH_PDDID"),2) %>-<%= mid(data("VCH_PDDID"),3,3) %>/<%= mid(data("VCH_PDDID"),6,4) %>/<%= mid(data("VCH_PDDID"),10,4) %>/<%= right(data("VCH_PDDID"),3) %>
        <%end if%>
    </span>
    <span>Tanggal</span>
    <span>: <%= Cdate(data("VCH_Date")) %></span>
  </div>
  <div class='rowIncrd'>
    <span>Repair Produksi</span>
    <span>:  <%if data("VCH_PDRID") <> "" then%><%= LEFT(data("VCH_PDRID"),3) &"-"& MID(data("VCH_PDRID"),4,2) &"/"& RIGHT(data("VCH_PDRID"),3) %>
        <%end if%>
    </span>
    <span>Keterangan</span>
    <span>: <%=data("VCH_Keterangan")%></span>
  </div>
  <table class="tableIncrd">
    <tr>
      <th scope="col">No</th>
      <th scope="col">Kategori</th>
      <th scope="col">Jenis</th>
      <th scope="col">Barang</th>
      <th scope="col">Type</th>
      <th scope="col">Quantity</th>
      <th scope="col">Satuan</th>
    </tr>
    <%
    no = 0
    do while not ddata.EOF
    no = no + 1
    %>
    <tr>
      <th scope="row"><%=no%></th>
      <td><%=ddata("kategorinama")%></td>
      <td><%=ddata("JenisNama")%></td>
      <td><%=ddata("Brg_Nama")%></td>
      <td><%=ddata("T_Nama")%></td>
      <td><%=ddata("VCH_Qtysatuan")%></td>
      <td><%=ddata("sat_nama")%></td>
    </tr>
    <%
    Response.flush
    ddata.movenext
    loop
    %>
  </table>
</body>
<% 

   call footer()
%>