<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT PDD_ID FROM DLK_T_ProduksiD LEFT OUTER JOIN DLK_T_ProduksiH ON LEFT(DLK_T_ProduksiD.PDD_ID,13) = DLK_T_ProduksiH.PDH_ID WHERE DLK_T_ProduksiH.PDH_AgenID = '"& cabang &"' AND DLK_T_ProduksiH.PDH_aktifyn = 'Y' AND NOT EXISTS(SELECT PDI_PDDID FROM DLK_T_PreDevInspectionH WHERE DLK_T_PreDevInspectionH.PDI_PDDID = DLK_T_ProduksiD.PDD_ID AND PDI_AktifYN = 'Y')  GROUP BY PDD_ID ORDER BY PDD_ID ASC"

  set data = data_cmd.execute

%>
  <select class="form-select" aria-label="Default select example" name="pddid" id="pddid" required> 
    <option value="">Pilih</option>
    <% do while not data.eof  %>
    <option value="<%= data("PDD_ID") %>">
      <%= left(data("PDD_id"),2) %>-<%= mid(data("PDD_id"),3,3) %>/<%= mid(data("PDD_id"),6,4) %>/<%= mid(data("PDD_id"),10,4) %>/<%= right(data("PDD_id"),3)  %>
    </option>
    <% 
    Response.flush
    data.movenext
    loop
    %>
  </select>
