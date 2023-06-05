<!--#include file="../../init.asp"-->
<% 
  ' if session("PR4A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' header
  data_cmd.commandTExt = "SELECT dbo.DLK_T_PreDevInspectionH.*, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Divisi.DivNama, dbo.GLB_M_Agen.AgenName FROM   dbo.DLK_T_PreDevInspectionH LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_PreDevInspectionH.PDI_DivId = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_PreDevInspectionH.PDI_DepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_PreDevInspectionH.PDI_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_PreDevInspectionH.PDI_AktifYN = 'Y') AND (dbo.DLK_T_PreDevInspectionH.PDI_ID = '"& id &"')"
  set data = data_cmd.execute


  ' detail
  data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& data("PDI_ID") &"' ORDER BY PDI_Description ASC"
  set ddata = data_cmd.execute

  
  ' get data item unit
  set conn = Server.CreateObject("ADODB.Connection")
  conn.open MM_Delima_string

  dim recordsonpage, requestrecords, allrecords, hiddenrecords, showrecords, lastrecord, recordconter, pagelist, pagelistcounter, sqlawal
  dim angka
  dim code, nama, aktifId, UpdateId, uTIme, orderBy
  ' untuk angka
  angka = request.QueryString("angka")
  if len(angka) = 0 then 
  angka = Request.form("urut") + 1
  end if

  ' untuk data paggination
  page = Request.QueryString("page")

  strquery = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& data("PDI_ID") &"'"

  orderBy = " ORDER BY PDI_Description ASC"
  set rs = Server.CreateObject("ADODB.Recordset")
  sqlawal = strquery

  sql= sqlawal + orderBy
  rs.open sql, conn
  ' records per halaman
  recordsonpage = 10
  ' count all records
  allrecords = 0
  do until rs.EOF
    allrecords = allrecords + 1
    response.flush
    rs.movenext
  loop
  ' if offset is zero then the first page will be loaded
  offset = Request.QueryString("offset")
  if offset = 0 OR offset = "" then
    requestrecords = 0
  else
    requestrecords = requestrecords + offset
  end if
  rs.close
  set rs = server.CreateObject("ADODB.RecordSet")
  sqlawal = strquery
  sql=sqlawal + orderBy
  rs.open sql, conn
  ' reads first records (offset) without showing them (can't find another solution!)
  hiddenrecords = requestrecords
  do until hiddenrecords = 0 OR rs.EOF
    hiddenrecords = hiddenrecords - 1
    response.flush
    rs.movenext
    if rs.EOF then
    lastrecord = 1
    end if	
  loop

  call header("Detail PDI")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL PRE DELIVERY INSPECTION</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= LEFT(data("PDI_ID"),3) &"-"& MID(data("PDI_ID"),4,3) &"/"& "DKI-" & LEFT(UCase(data("DivNama")),3) & "/" & data("PDI_DepID") & "/" & MID(data("PDI_ID"),7,4) & "/" & right("00" + cstr(data("PDI_Revisi")),2)  & "/" &  right(data("PDI_ID"),3) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangPdi" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("PDI_Date")) %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">Divisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("divNama") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">Departement</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("depNama") %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= left(data("PDI_PDDid"),2) %>-<%= mid(data("PDI_PDDid"),3,3) %>/<%= mid(data("PDI_PDDid"),6,4) %>/<%= mid(data("PDI_PDDid"),10,4) %>/<%= right(data("PDI_PDDid"),3)  %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdiaddrevisi" class="col-form-label">Refisi Ke -</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group">
        <input type="hidden" id="idrevisi" name="idrevisi" class="form-control" value="<%= data("PDI_id") %>" autocomplete="off">
        <input type="text" id="pdiaddrevisi" name="pdiaddrevisi" class="form-control" value="<%= data("PDI_Revisi") %>" autocomplete="off">
        <span class="input-group-text p-0 m-0" id="basic-addon2"><button type="button" style="border:none;width:75px;" onclick="updateRevisiPdi()">Update</button></span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("PDI_Keterangan") %>"  autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center d-flex justify-content-between mb-3">
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
      <% if session("MQ3D") = true then %>
        <button type="button" class="btn btn-secondary" onclick="window.open('export-xlspdi.asp?id=<%=data("PDI_ID")%>', '_self')">Export</button>
      <% end if %>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12">
      <table class="table table-bordered border-dark table-hover">
        <thead class="">
          <tr>
            <th scope="col" rowspan="2" class="text-center">No</th>
            <th scope="col" rowspan="2" class="text-center">Description</th>
            <th scope="col" colspan="3" class="text-center">Condition</th>
            <tr>
              <td class="text-center">Good</td>
              <td class="text-center">Bad</td>
              <td class="text-center">Not</td>
            </tr>
          </tr>
        </thead>
        <tbody>
          <% 
         showrecords = recordsonpage
          recordcounter = requestrecords
          do until showrecords = 0 OR  rs.EOF
          recordcounter = recordcounter + 1
          %>
          <tr>
            <th scope="row" class="text-center"><%= recordcounter %></th>
            <td><%= rs("PDI_description") %></td>
              <!-- cek kondisi -->
              <td class="text-center">
                <%if rs("PDI_Condition") = "G" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                  <span><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
              <td class="text-center">
                <%if rs("PDI_Condition") = "B" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                  <span><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
              <td class="text-center">
                <%if rs("PDI_Condition") = "N" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                   <span><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
          </tr>
          <tr>
          <% 
          response.flush
          showrecords = showrecords - 1
          rs.movenext
          if rs.EOF then
          lastrecord = 1
          end if
          loop
          rs.close
          %>
        </tbody>
      </table>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12">
      <!-- paggination -->
      <nav aria-label="Page navigation example">
        <ul class="pagination">
          <li class="page-item">
          <% 
            if page = "" then
              npage = 1
            else
              npage = page - 1
            end if
            if requestrecords <> 0 then 
          %>
            <a class="page-link prev" href="detail.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&id=<%=id%>">&#x25C4; Prev </a>
          <% else %>
            <p class="page-link prev-p">&#x25C4; Prev </p>
          <% end if %>
          </li>
          <li class="page-item d-flex" style="overflow-y:auto;height: max-content;">	
          <%
          pagelist = 0
          pagelistcounter = 0
          do until pagelist > allrecords  
          pagelistcounter = pagelistcounter + 1
          if page = "" then
            page = 1
          else
            page = page
          end if
          if Cint(page) = pagelistcounter then
          %>
            <a class="page-link hal bg-primary text-light" href="detail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>"><%= pagelistcounter %></a> 
          <%else%>
            <a class="page-link hal" href="detail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>"><%= pagelistcounter %></a> 
          <%
          end if
          pagelist = pagelist + recordsonpage
          loop
          %>
          </li>
          <li class="page-item">
            <% 
            if page = "" then
              page = 1
            else
              page = page + 1
            end if
            %>
            <% if(recordcounter > 1) and (lastrecord <> 1) then %>
              <a class="page-link next" href="detail.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&id=<%=id%>">Next &#x25BA;</a>
            <% else %>
              <p class="page-link next-p">Next &#x25BA;</p>
            <% end if %>
          </li>	
        </ul>
      </nav> 
    </div>
  </div>

</div>  

<% 
  call footer()
%>