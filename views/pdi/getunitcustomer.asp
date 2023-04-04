<!--#include file="../../init.asp"-->
<% 
  salesorder = trim(Request.Form("salesorder"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_UnitCustomerD1.TFK_ID FROM dbo.DLK_T_UnitCustomerH RIGHT OUTER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_UnitCustomerH.TFK_ID = LEFT(dbo.DLK_T_UnitCustomerD1.TFK_ID, 17) WHERE (dbo.DLK_T_UnitCustomerH.TFK_OJHID = '"& salesorder &"') AND DLK_T_UnitCustomerH.TFK_aktifyn = 'Y' AND NOT EXISTS(SELECT PDI_TFKID FROM DLK_T_PreDevInspectionH WHERE DLK_T_PreDevInspectionH.PDI_TFKID = DLK_T_UnitCustomerD1.TFK_ID AND PDI_AktifYN = 'Y') GROUP BY DLK_T_UnitCustomerD1.TFK_ID ORDER BY TFK_ID ASC"
  ' response.write data_cmd.commandText 
  set data = data_cmd.execute

%>
  <select class="form-select" aria-label="Default select example" name="tfkid" id="pditfkid" required> 
    <option value="">Pilih</option>
    <% do while not data.eof  %>
    <option value="<%= data("TFK_ID") %>">
      <%= LEFT(data("TFK_ID"),11) &"-"& MID(data("TFK_ID"),12,4) &"/"& MID(data("TFK_ID"),16,2) &"/"&  Right(data("TFK_ID"),3) %>
    </option>
    <% 
    Response.flush
    data.movenext
    loop
    %>
  </select>
