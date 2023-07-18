<!--#include file="../../init.asp"-->
<% 
  if session("MQ5") = false then
    Response.Redirect("../")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter incomming
  data_cmd.commandText = "SELECT PDIR_IRHID FROM DLK_T_PDIRepairH ORDER BY PDIR_IRHID ASC"
  set incdata = data_cmd.execute

  ' filter nomor produksi
  data_cmd.commandText = "SELECT DLK_T_PDIRepairH.PDIR_PDRID FROM DLK_T_PDIRepairH WHERE DLK_T_PDIRepairH.PDIR_AktifYN = 'Y' ORDER BY DLK_T_PDIRepairH.PDIR_PDRID ASC"
  set dprod = data_cmd.execute

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
  inc = request.QueryString("inc")
  if len(inc) = 0 then 
    inc = trim(Request.Form("inc"))
  end if
  prodid = request.QueryString("prodid")
  if len(prodid) = 0 then 
    prodid = trim(Request.Form("prodid"))
  end if
  tgla = request.QueryString("tgla")
  if len(tgla) = 0 then 
    tgla = trim(Request.Form("tgla"))
  end if
  tgle = request.QueryString("tgle")
  if len(tgle) = 0 then 
    tgle = trim(Request.Form("tgle"))
  end if

  if inc <> "" then
    filterinc = "AND DLK_T_PDIRepairH.PDIR_IRHID = '"& inc &"'"
  else
    filterinc = ""
  end if

  if prodid <> "" then
    filterprodid = "AND DLK_T_PDIRepairH.PDIR_PDRID = '"& prodid &"'"
  else
    filterprodid = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_PDIRepairH.PDIR_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_PDIRepairH.PDIR_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_T_PDIRepairH.*, GLB_M_Agen.AgenName, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Divisi.DivNama FROM DLK_T_PDIRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_PDIRepairH.PDIR_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_PDIRepairH.PDIR_DivId = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_PDIRepairH.PDIR_DepID = dbo.HRD_M_Departement.DepID WHERE PDIR_AktifYN = 'Y' "& filterinc &"  "& filtertgl &" "& filterprodid &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY PDIR_ID, PDIR_Date DESC"
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
      rs.movenext
      if rs.EOF then
      lastrecord = 1
      end if	
  loop

  call header("Pre Delivery Inspection")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
	<div class="row">
		<div class="col-lg-12 mb-3 mt-3 text-center">
			<h3>PRE DELIVERY INSPECTION REPAIR</h3>
		</div>
	</div>
	<% if session("MQ5A") = true then %>
	<div class="row">
		<div class="col-lg-12 mb-3">
			<a href="pdir_add.asp" class="btn btn-primary ">Tambah</a>
		</div>
	</div>
	<% end if %>
	<form action="index.asp" method="post">
		<div class="row">
			<div class="col-lg-4 mb-3">
				<label for="incpdireapair">No.Incomming</label>
				<select class="form-select" aria-label="Default select example" name="inc" id="incpdireapair">
					<option value="">Pilih</option>
					<% do while not incdata.eof %>
					<option value="<%= incdata("PDIR_IRHID") %>"><%= LEFT(incdata("PDIR_IRHID"),4) &"-"& mid(incdata("PDIR_IRHID"),5,3) &"/"& mid(incdata("PDIR_IRHID"),8,4) &"/"& right(incdata("PDIR_IRHID"),2)%></option>
					<% 
					incdata.movenext
					loop
					%>
				</select>
			</div>
			<div class="col-lg-4 mb-3">
				<label for="prodid">No.Produksi</label>
				<select class="form-select" aria-label="Default select example" name="prodid" id="prodid">
					<option value="">Pilih</option>
					<% Do While not dprod.eof%>
					<option value="<%=dprod("PDIR_PDRID")%>"><%= left(dprod("PDIR_PDRID"),3) %>-<%= mid(dprod("PDIR_PDRID"),4,2) %>/<%= right(dprod("PDIR_PDRID"),3)  %></option>
					<%
					Response.flush
					dprod.movenext
					loop
					%>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-4 mb-3">
				<label for="tgla">Tanggal Pertama</label>
				<input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
			</div>
			<div class="col-lg-4 mb-3">
				<label for="tgle">Tanggal Kedua</label>
				<input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
			</div>
			<div class="col-lg-2 mt-4 mb-3">
				<button type="submit" class="btn btn-primary">Cari</button>
			</div>
		</div>
	</form>
	<div class="row">
		<div class="col-lg-12">
				<table class="table table-hover">
						<thead class="bg-secondary text-light">
								<th>No</th>
								<th>Tanggal</th>
								<th>No.PDI</th>
								<th>No.Incomming</th>
								<th>Cabang</th>
								<th>Keterangan</th>
								<th class="text-center">Aksi</th>
						</thead>
						<tbody>
								<% 
								'prints records in the table
								showrecords = recordsonpage
								recordcounter = requestrecords
								do until showrecords = 0 OR  rs.EOF
								recordcounter = recordcounter + 1

								data_cmd.commandTExt = "SELECT PDIR_ID FROM DLK_T_PDIRepairD WHERE LEFT(PDIR_ID,14) = '"& rs("PDIR_ID") &"'"
								set p = data_cmd.execute
								%>
										<tr><TH><%= recordcounter %></TH>
										<td><%= Cdate(rs("PDIR_Date")) %></td>
										<td>
											<%= LEFT(rs("PDIR_ID"),4) &"-"& MID(rs("PDIR_ID"),5,3) &"/"& "DKI-" & LEFT(UCase(rs("DivNama")),3) & "/" & rs("PDIR_DepID") & "/" & MID(rs("PDIR_ID"),7,4) & "/" & right("00" + cstr(rs("PDIR_Revisi")),2)  & "/" &  right(rs("PDIR_ID"),3) %>
										</td>
										<td><%= LEFT(rs("PDIR_IRHID"),4) &"-"& mid(rs("PDIR_IRHID"),5,3) &"/"& mid(rs("PDIR_IRHID"),8,4) &"/"& right(rs("PDIR_IRHID"),2)%></td>
										<td><%= rs("AgenNAme")%></td>
										<td><%= rs("PDIR_Keterangan")%></td>
										<td class="text-center">
											<div class="btn-group" role="group" aria-label="Basic example">
													<% if not p.eof then %>
														<a href="detail.asp?id=<%= rs("PDIR_ID") %>" class="btn badge text-light bg-warning">Detail</a>
													<% end if %>
													<% if session("MQ5B") = true then %>    
													<a href="pdird_add.asp?id=<%= rs("PDIR_ID") %>" class="btn badge text-bg-primary" >Update</a>
													<% end if %>
													<% if session("MQ5C") = true then %>    
														<% if p.eof then %>
															<a href="aktifh.asp?id=<%= rs("PDIR_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'hapus header PDI Repair')">Delete</a>
														<% end if %>
													<% end if %>
											</div>
										</td>
								</tr>
								<%      
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
											<a class="page-link prev" href="./?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
													<a class="page-link hal bg-primary text-light" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
											<%else%>
													<a class="page-link hal" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
													<a class="page-link next" href="./?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
											<% else %>
													<p class="page-link next-p">Next &#x25BA;</p>
											<% end if %>
									</li>	
							</ul>
					</nav> 
			</div>
	</div>
</div>  
<% call footer() %>

