<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT DLK_T_OrjulH.OJH_ID FROM DLK_T_OrjulH WHERE DLK_T_OrjulH.OJH_AgenID = '"& cabang &"' AND DLK_T_OrjulH.OJH_aktifyn = 'Y' AND NOT EXISTS(SELECT PDI_OJHID FROM DLK_T_PreDevInspectionH WHERE DLK_T_PreDevInspectionH.PDI_OJHID = DLK_T_OrjulH.OJH_ID AND PDI_AktifYN = 'Y')  GROUP BY DLK_T_OrjulH.OJH_ID ORDER BY OJH_ID ASC"

  set data = data_cmd.execute

%>
  <select class="form-select" aria-label="Default select example" name="ojhid" id="pdiojhid" onchange="getSO(this.value)" required> 
    <option value="">Pilih</option>
    <% do while not data.eof  %>
    <option value="<%= data("OJH_ID") %>">
      <%= left(data("OJH_ID"),2) %>-<%= mid(data("OJH_ID"),3,3) %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4)  %>
    </option>
    <% 
    Response.flush
    data.movenext
    loop
    %>
  </select>

  <script>
  function getSO(e){
    let salesorder = String(e)
    if (salesorder !== "") {
      // untuk nomor unit
      $.post("getunitcustomer.asp", { salesorder }, function (data) {
        $(".contentTfk").html(data)
      })
    } else {
      // untuk nomor unit
      $(".contentTfk").html(`<select class="form-select" aria-label="Default select example" id="tfkid" name="tfkid" required><option value="" readonly disabled>Pilih No Sales Order dahulu</option></select>`)
    }
    
  }
  </script>
