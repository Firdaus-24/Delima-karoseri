<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_pdi.asp"-->
<% 
  if session("MQ3B") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' header
  data_cmd.commandTExt = "SELECT dbo.DLK_T_PreDevInspectionH.PDI_ID, dbo.DLK_T_PreDevInspectionH.PDI_Date, dbo.DLK_T_PreDevInspectionH.PDI_PDDID, dbo.DLK_T_PreDevInspectionH.PDI_TFKID, dbo.DLK_T_PreDevInspectionH.PDI_Keterangan,dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_M_Customer.custNama, HRD_M_Divisi.DIvNama, dbo.DLK_T_PreDevInspectionH.PDI_DepID, dbo.DLK_T_PreDevInspectionH.PDI_Revisi, HRD_M_Departement.DepNama FROM dbo.DLK_M_Customer INNER JOIN dbo.DLK_T_OrJulH ON dbo.DLK_M_Customer.custId = dbo.DLK_T_OrJulH.OJH_CustID RIGHT OUTER JOIN dbo.DLK_T_PreDevInspectionH ON dbo.DLK_T_OrJulH.OJH_ID = dbo.DLK_T_PreDevInspectionH.PDI_OJHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_PreDevInspectionH.PDI_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_PreDevInspectionH.PDI_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_PreDevInspectionH.PDI_Divid = HRD_M_DIvisi.diviD LEFT OUTER JOIN HRD_M_Departement ON DLK_T_PreDevInspectionH.PDI_DepID = HRD_M_Departement.Depid WHERE (dbo.DLK_T_PreDevInspectionH.PDI_AktifYN = 'Y') AND (dbo.DLK_T_PreDevInspectionH.PDI_ID = '"& id &"')"
  set data = data_cmd.execute


  ' detail
  data_cmd.commandTExt = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& data("PDI_ID") &"' ORDER BY PDI_Initial ASC"
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

  ckey1 = trim(Request.QueryString("ckey1"))
  ckey2 = trim(Request.QueryString("ckey2"))

  if ckey1 <> "" then
    filterckey1 = "AND UPPER(PDI_Initial) LIKE '%"& ucase(ckey1) &"%'"
  else
    filterckey1 = ""
  end if
  if ckey2 <> "" then
    filterckey2 = "AND UPPER(PDI_Description) LIKE '%"& ucase(ckey2) &"%'"
  else
    filterckey2 = ""
  end if

  ' untuk data paggination
  page = Request.QueryString("page")

  strquery = "SELECT * FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& data("PDI_ID") &"' "& filterckey1 &" "& filterckey2 &" "

  orderBy = " ORDER BY PDI_Initial ASC"
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

  call header("UPdate Detail PDI")
%>
<!--#include file="../../navbar.asp"--> 
<style>
#key{
  position:absolute;
  right:0;
  margin:-10px 80px 0 0;
  background-color:#fff;
  display:inline-block;
  width:10em;
  padding-left:10px;
  padding-right:2px;
  font-family:Arial, Helvetica, sans-serif;
  font-weight:bold;
  letter-spacing: -1px;
  text-transform:uppercase;
}
.formCariPdi{
  border:1.5px solid black;
  border-style:dashed;
  padding:10px;
  margin-left:1px;
  margin-right:1px;
  margin-bottom:8px;
  border-radius:10px;
}

</style>

<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>UPDATE DETAIL PRE DELIVERY INSPECTION</h3>
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
      <label for="noso" class="col-form-label">No.Sales Order</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= left(data("OJH_ID"),2) %>-<%= mid(data("OJH_ID"),3,3) %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4)  %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tfkid" class="col-form-label">No.Unit</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= LEFT(data("PDI_TFKID"),11) &"/"& MID(data("PDI_TFKID"),12,4) &"/"& MID(data("PDI_TFKID"),16,2) &"/"& Right(data("PDI_TFKID"),3) %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="customer" name="customer" class="form-control" value="<%= data("custnama") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
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
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("PDI_Keterangan") %>"  autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center d-flex justify-content-between mb-3">
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDetailPdi">Rincian</button>
    </div>
  </div>


  <form action="pdid_u.asp?id=<%= id %>" method="get" style="position:relative">
    <span id="key">From Pencarian</span>
    <div class="row formCariPdi">
      <div class="col-lg-2 mb-3">
        <label for="ckey1">Initial</label>
        <input type="hidden" class="form-control" name="id" id="id" value="<%= id %>" autocomplete="off" >
        <input type="text" class="form-control" name="ckey1" id="ckey1" autocomplete="off" >
      </div>
      <div class="col-lg-4 mb-3">
          <label for="ckey2">Description</label>
          <input type="text" class="form-control" name="ckey2" id="ckey2" autocomplete="off" >
      </div>
      <div class="col-lg-2 mt-4 mb-3">
        <button type="submit" class="btn btn-secondary">Cari</button>
      </div>
    </div>
  </form>

  <div class="row">
    <div class="col-sm-12">
      <table class="table table-bordered border-dark table-hover">
        <thead class="">
          <tr>
            <th scope="col" rowspan="2" class="text-center">No</th>
            <th scope="col" rowspan="2" class="text-center">Inisial</th>
            <th scope="col" rowspan="2" class="text-center">Description</th>
            <th scope="col" colspan="3" class="text-center">Condition</th>
            <th scope="col" rowspan="2" class="text-center">Aksi</th>
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
            <td><%= rs("PDI_Initial") %></td>
            <td><%= rs("PDI_description") %></td>
              <!-- cek kondisi -->
              <td class="text-center">
                <%if rs("PDI_Condition") = "G" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                   <span onclick="ckUpdateCondition('<%=rs("PDI_id")%>', '<%= rs("PDI_Initial") %>', 'G')"><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
              <td class="text-center">
                <%if rs("PDI_Condition") = "B" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                   <span onclick="ckUpdateCondition('<%=rs("PDI_id")%>', '<%= rs("PDI_Initial") %>', 'B')"><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
              <td class="text-center">
                <%if rs("PDI_Condition") = "N" then %>
                  <i class="bi bi-check-lg text-success"></i>
                <% else %>
                   <span onclick="ckUpdateCondition('<%=rs("PDI_id")%>', '<%= rs("PDI_Initial") %>', 'N')"><i class="bi bi-x-lg text-danger"></i></span>
                <% end if %>
              </td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <a href="aktifd.asp?id=<%= rs("PDI_ID") %>&init=<%= rs("PDI_Initial") %>&p=pdid_u" class="btn badge text-bg-danger" onclick="deleteItem(event,'hapus detail PDI')">Delete</a>
              </div>
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
            <a class="page-link prev" href="pdid_u.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&id=<%=id%>">&#x25C4; Prev </a>
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
            <a class="page-link hal bg-primary text-light" href="pdid_u.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>"><%= pagelistcounter %></a> 
          <%else%>
            <a class="page-link hal" href="pdid_u.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="pdid_u.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&id=<%=id%>">Next &#x25BA;</a>
            <% else %>
              <p class="page-link next-p">Next &#x25BA;</p>
            <% end if %>
          </li>	
        </ul>
      </nav> 
    </div>
  </div>

</div>  

<!-- Modal -->
<div class="modal fade" id="modalDetailPdi" tabindex="-1" aria-labelledby="modalDetailPdiLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalDetailPdiLabel">Detail PDI</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="pdid_u.asp?id=<%= data("PDI_ID") %>" method="post">
      <input type="hidden" name="id" value="<%= data("PDI_ID") %>">
      <div class="modal-body">
        <div class="mb-3 row">
          <label for="initial" class="col-sm-3 col-form-label">Initial</label>
          <div class="col-sm-5">
            <input type="text" class="form-control" id="initial" name="initial" maxlength="5" required>
          </div>
        </div>
        <div class="mb-3 row">
          <label for="desc" class="col-sm-3 col-form-label">Description</label>
          <div class="col-sm-9">
            <textarea class="form-control" placeholder="Leave a comment here" id="desc" name="desc" maxlength="50" style="height: 80px" required></textarea>
          </div>
        </div>
        <div class="mb-3 row">
          <label for="desc" class="col-sm-3 col-form-label">Condition</label>
          <div class="col-sm-9">
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="condition" id="good" value="G" required>
              <label class="form-check-label" for="good">Good</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="condition" id="bad" value="B">
              <label class="form-check-label" for="bad">Bad</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="condition" id="not" value="N">
              <label class="form-check-label" for="not">Not Avallable</label>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
    </form>
  </div>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateDetailPDI()
  end if
  call footer()
%>
<script>
  const updateRevisiPdi = () => {
    let revisi = $("#pdiaddrevisi").val()
    let id = $("#idrevisi").val()
    $.post('Revisi_u.asp', {id, revisi}, function(data){
      if(!alert('data berhasil di ubah')){window.location.reload();}
      
    })
  }

  const ckUpdateCondition = (id,int,type) => {
   $.post('condition_u.asp', {id, int, type}, function(data){
    if(!alert(data)){window.location.reload();}
   })
    
  }
</script>