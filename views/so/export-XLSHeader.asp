<!--#include file="../../init.asp"-->
<%  
  la = trim(Request.QueryString("la"))
  le = trim(Request.QueryString("le"))
  st = trim(Request.QueryString("st"))
  en = trim(Request.QueryString("en"))

  if en <> "" then
    filterAgen = "AND DLK_T_OrJulH.OJH_AgenID = '"& en &"'"
  else
    filterAgen = ""
  end if
  if st <> "" then
    filtercust = "AND DLK_T_OrJulH.OJH_custID = '"& st &"'"
  else
    filtercust = ""
  end if


  if la <> "" AND le <> "" then
    filtertgl = "AND dbo.DLK_T_OrJulH.OJH_Date BETWEEN '"& la &"' AND '"& le &"'"
  elseIf la <> "" AND le = "" then
    filtertgl = "AND dbo.DLK_T_OrJulH.OJH_Date = '"& la &"'"
  else 
    filtertgl = ""
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_T_OrJulH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrJulH.OJH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_OrJulH.OJH_CustID = dbo.DLK_M_Customer.custId WHERE (DLK_T_OrJulH.OJH_AktifYN = 'Y') "& filterAgen &""& filtercust &""& filtertgl &"  ORDER BY OJH_Date DESC"

  set data = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=SalesOrderHeader "& data("agenName") &" .xls"
%>
<table style="width:100%">
  <tr>
    <td align="center" colspan="9"><b>SALES ORDER</b></td>
  </tr>
  <tr>
    <td align="center" colspan="9">&nbsp</td>
  </tr>
  <tr>
    <td style="background-color: #0000a0;color:#fff;">No</td>
    <td style="background-color: #0000a0;color:#fff;">Order ID</td>
    <td style="background-color: #0000a0;color:#fff;">Cabang</td>
    <td style="background-color: #0000a0;color:#fff;">Tanggal</td>
    <td style="background-color: #0000a0;color:#fff;">Customer</td>
    <td style="background-color: #0000a0;color:#fff;">Tanggal JT</td>
    <td style="background-color: #0000a0;color:#fff;">Diskon</td>
    <td style="background-color: #0000a0;color:#fff;">PPN</td>
    <td style="background-color: #0000a0;color:#fff;" colspan="2">Time Work</td>
  </tr>
  <% 
  do while not data.eof 
  no = 0 + 1
  %>
  <tr>
    <TH><%= no %></TH>
    <th align="left">
      <%= left(data("OJH_ID"),2) %>-<%= mid(data("OJH_ID"),3,3) %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4)  %>
    </th>
    <td><%= data("AgenNAme")%></td>
    <td><%= Cdate(data("OJH_Date")) %></td>
    <td><%= data("custNama")%></td>
    <td>
      <% if Cdate(data("OJH_JTDate")) <> Cdate("1/1/1900") then%> 
        <%= cdate(data("OJH_JTDate")) %>
      <% end if %>
    </td>
    <td><%= data("OJH_DiskonALL")%></td>
    <td><%= data("OJH_PPN")%></td>
    <td colspan="2"><%= data("OJH_TimeWork")%></td>
  </tr>
  <% 
    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_Qtysatuan, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_Diskon, dbo.DLK_T_OrJulD.OJD_Keterangan, dbo.DLK_T_OrJulD.OJD_Updatetime, dbo.DLK_T_OrJulD.OJD_UpdateID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_WebLogin.username FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_OrJulD.OJD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrJulD.OJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_OrjulD.OJD_Updateid = DLK_M_webLogin.userid WHERE LEFT(dbo.DLK_T_OrJulD.OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY dbo.DLK_T_OrjulD.OJD_OJHID" ' response.write data_cmd.commandText & "<br>"
    set ddata = data_cmd.execute
  %>
    <% 
    do while not ddata.eof 
    %>
    <tr>
      <td>
      </td>
      <th align="left">
        <%= left(ddata("OJD_OJHID"),2) %>-<%= mid(ddata("OJD_OJHID"),3,3) %>/<%= mid(ddata("OJD_OJHID"),6,4) %>/<%= mid(ddata("OJD_OJHID"),10,4) %>/<%= right(ddata("OJD_OJHID"),3)  %>
      </th>
      <td>
        <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
      </td>
      <td>
        <%= ddata("Brg_Nama") %>
      </td>
      <td>
        <%= ddata("OJD_Qtysatuan")%>
      </td>
      <td>
        <%= ddata("sat_Nama")%>
      </td>
      <td>
        <%= replace(formatCurrency(ddata("OJD_Harga")),"$","")%>
      </td>
      <td>
        <%= ddata("OJD_Diskon")%>
      </td>
      <td>
        <%= ddata("OJD_updatetime")%>
      </td>
      <td>
        <%= ddata("username")%>
      </td>
    </tr>

  <% 
    response.flush
    ddata.movenext
    loop
  response.flush
  data.movenext
  loop
  %>
</table>
