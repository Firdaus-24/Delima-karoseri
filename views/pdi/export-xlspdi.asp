<!--#include file="../../init.asp"-->
<% 
  if session("MQ3D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' header
  data_cmd.commandTExt = "SELECT dbo.DLK_T_PreDevInspectionH.*, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Divisi.DivNama, dbo.GLB_M_Agen.AgenName FROM   dbo.DLK_T_PreDevInspectionH LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_PreDevInspectionH.PDI_DivId = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_PreDevInspectionH.PDI_DepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_PreDevInspectionH.PDI_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_PreDevInspectionH.PDI_AktifYN = 'Y') AND (dbo.DLK_T_PreDevInspectionH.PDI_ID = '"& id &"')"
  set data = data_cmd.execute


  ' detail
  data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& data("PDI_ID") &"' ORDER BY PDI_Description ASC"
  set rs = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=Pre Delivery Inspection "& LEFT(data("PDI_ID"),3) &"-"& MID(data("PDI_ID"),4,3) &"/"& "DKI-" & LEFT(UCase(data("DivNama")),3) & "/" & data("PDI_DepID") & "/" & MID(data("PDI_ID"),7,4) & "/" & right("00" + cstr(data("PDI_Revisi")),2)  & "/" &  right(data("PDI_ID"),3)&" .xls"

%>
<style>
.borderd{
  border:1px solid black;
  text-align:center;
  background-color:cyan;
}
.tbody{
   border:1px solid black;
}
</style>

<table width="100%">
  <tr>
    <th colspan="6" style="text-align:center">DETAIL PRE DELIVERY INSPECTION</th>
  </tr>
  <tr>
    <th colspan="6" style="text-align:center">
      <%= LEFT(data("PDI_ID"),3) &"-"& MID(data("PDI_ID"),4,3) &"/"& "DKI-" & LEFT(UCase(data("DivNama")),3) & "/" & data("PDI_DepID") & "/" & MID(data("PDI_ID"),7,4) & "/" & right("00" + cstr(data("PDI_Revisi")),2)  & "/" &  right(data("PDI_ID"),3) %>
    </th>
  </tr>
  <tr>
    <td colspan="6">&nbsp</td>
  </tr>
  <tr>
    <td colspan="2">
      Cabang / Agen
    </td>
    <td colspan="2">
      : <%= data("AgenName") %>
    </td>
    <td colspan="2">
      Tanggal
    </td>
    <td colspan="2">
      : <%= Cdate(data("PDI_Date")) %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Divisi
    </td>
    <td colspan="2"> 
      : <%= data("divNama") %>
    </td>
    <td colspan="2">
      Departement
    </td>
    <td colspan="2">
      : <%= data("depNama") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      No.Produksi
    </td>
    <td colspan="2">
      : <%= left(data("PDI_PDDid"),2) %>-<%= mid(data("PDI_PDDid"),3,3) %>/<%= mid(data("PDI_PDDid"),6,4) %>/<%= mid(data("PDI_PDDid"),10,4) %>/<%= right(data("PDI_PDDid"),3)  %>
    </td>
    <td colspan="2">
      Refisi Ke -
    </td>
    <td colspan="2">
      : <%= data("PDI_Revisi") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Keterangan
    </td>
    <td colspan="2">
      : <%= data("PDI_Keterangan") %>
    </td>
  </tr>
  <tr>
    <td colspan="6">&nbsp</td>
  </tr>
  <tr>
    <th scope="col" rowspan="2" class="borderd">No</th>
    <th scope="col" rowspan="2" class="borderd">Description</th>
    <th scope="col" colspan="3" class="borderd">Condition</th>
    <tr>
      <td class="borderd">Good</td>
      <td class="borderd">Bad</td>
      <td class="borderd">Not</td>
    </tr>
  </tr>
       
  <% 
  no = 0
  do while not rs.eof
  no = no + 1
  %>
  <tr>
    <th scope="row" class="tbody"><%= no %></th>
    <td class="tbody"><%= rs("PDI_description") %></td>
      <!-- cek kondisi -->
      <td class="tbody" style="text-align:center">
        <%if rs("PDI_Condition") = "G" then %>
          &#10004;
        <% else %>
          &#88;
        <% end if %>
      </td>
      <td class="tbody" style="text-align:center">
        <%if rs("PDI_Condition") = "B" then %>
          &#10004;
        <% else %>
          &#88;
        <% end if %>
      </td>
      <td class="tbody" style="text-align:center">
        <%if rs("PDI_Condition") = "N" then %>
          &#10004;
        <% else %>
            &#88;
        <% end if %>
      </td>
  </tr>
  <% 
  response.flush
  rs.movenext
  loop
  rs.close
  %>
</table>
