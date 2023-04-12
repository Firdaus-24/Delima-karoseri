<!--#include file="../../init.asp"-->
<% 
  if session("ENG8D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_T_SuratJalanH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_SuratJalanH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_SuratJalanH.SJ_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_SuratJalanH.SJ_CustID = dbo.DLK_M_Customer.custId WHERE (DLK_T_SuratJalanH.SJ_AktifYN = 'Y') AND (DLK_T_SuratJalanH.SJ_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_T_SuratJalanD.SJD_TFKID, dbo.DLK_T_SuratJalanD.SJD_Keterangan, dbo.DLK_T_UnitCustomerD1.TFK_Merk, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Norangka, dbo.DLK_T_UnitCustomerD1.TFK_NoMesin, dbo.DLK_T_SuratJalanD.SJD_ID, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_SuratJalanD INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_SuratJalanD.SJD_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_Merk = dbo.DLK_M_Brand.BrandID WHERE LEFT(SJD_ID,10) = '"& data("SJ_ID") &"' ORDER BY SJD_ID"
  '  response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Surat Jalan No. "& id &" .xls"
%>
<table width="100%">
  <tr>
    <th colspan="8">SURAT JALAN</th>
  </tr>
  <tr>
    <th colspan="8"><%= "Delima-DKI-" & left(id,3) %>/<%= mid(id,4,4) %>/<%= right(id,3)  %></th>
  </tr>
  <tr>
    <td colspan="8">&nbsp</td>
  </tr>
  <tr>
    <td colspan="2">Cabang</td>
    <td colspan="2">: <%= data("agenName") %></td>
    <td colspan="2">Tanggal</td>
    <td colspan="2">: <%= cdate(data("SJ_Date")) %></td>
  </tr>
  <tr>
    <td colspan="2">Customer</td>
    <td colspan="2">: <%= data("custnama") %></td>
    <td colspan="2">Keterangan</td>
    <td colspan="2">: <%= data("SJ_Keterangan") %></td>
  </tr>
  <tr>
    <td colspan="8">&nbsp</td>
  </tr>
  <tr>
    <th  style="background-color:#5a6eaf;color:#FFF;">No</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">Brand</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">Type</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">No.Chasist</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">No.Mesin</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">No.Polisi</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">PDI</th>
    <th  style="background-color:#5a6eaf;color:#FFF;">Keterangan</th>
  </tr>
  <% 
  no = 0
  do while not ddata.eof 
  no = no + 1

  ' cek data PDI
  data_cmd.commandTExt = "SELECT PDI_ID FROM DLK_T_PreDevInspectionH WHERE PDI_TFKID = '"& ddata("SJD_TFKID") &"' AND PDI_AktifYN = 'Y'"
  set datapdi = data_cmd.execute
  %>
  <tr>
    <th>
      <%= no %>
    </th>
    <td>
      <%= ddata("brandName") %>
    </td>
    <td>
      <%= ddata("TFK_TYpe") %>
    </td>
    <td>
      <%= ddata("TFK_NOrangka") %>
    </td>
    <td>
      <%= ddata("TFK_Nomesin") %>
    </td>
    <td>
      <%= ddata("TFK_Nopol") %>
    </td>
    <td>
      <% if not datapdi.eof then %>
        <a href="<%= url %>views/pdi/detail.asp?id=<%= datapdi("PDI_ID") %>" style="text-decoration:none;color:black;" target="_blank"> 
          <%= left(datapdi("PDI_ID"),3) &"-"& MID(datapdi("PDI_ID"),4,3) &"/"& MID(datapdi("PDI_ID"),7,4) &"/"& right(datapdi("PDI_ID"),3) %>
        </a>
      <% else %>
        -
      <% end if %>
    </td>
    <td>
      <%= ddata("SJD_Keterangan") %>
    </td>
  </tr>
  <% 
  
  ddata.movenext
  loop
  %>
</table>
