<!--#include file="../../init.asp"-->
<% 
  if session("MQ3") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_PreDevInspectionH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_PreDevInspectionH.PDI_AgenID = GLB_M_Agen.AgenID WHERE DLK_T_PreDevInspectionH.PDI_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute
  ' filter nomor produksi
  data_cmd.commandText = "SELECT DLK_T_PreDevInspectionH.PDI_PDDid FROM DLK_T_PreDevInspectionH WHERE DLK_T_PreDevInspectionH.PDI_AktifYN = 'Y' ORDER BY DLK_T_PreDevInspectionH.PDI_PDDid ASC"
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
  agen = request.QueryString("agen")
  if len(agen) = 0 then 
    agen = trim(Request.Form("agen"))
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

  if agen <> "" then
    filterAgen = "AND DLK_T_PreDevInspectionH.PDI_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if

  if prodid <> "" then
    filterprodid = "AND DLK_T_PreDevInspectionH.PDI_PDDID = '"& prodid &"'"
  else
    filterprodid = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_PreDevInspectionH.PDI_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_PreDevInspectionH.PDI_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_T_PreDevInspectionH.*, GLB_M_Agen.AgenName, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Divisi.DivNama FROM DLK_T_PreDevInspectionH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_PreDevInspectionH.PDI_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_PreDevInspectionH.PDI_DivId = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_PreDevInspectionH.PDI_DepID = dbo.HRD_M_Departement.DepID WHERE PDI_AktifYN = 'Y' "& filterAgen &"  "& filtertgl &" "& filterprodid &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY PDI_Date DESC"
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
			<h3>PRE DELIVERY INSPECTION</h3>
		</div>
	</div>
	<% if session("MQ3A") = true then %>
	<div class="row">
		<div class="col-lg-12 mb-3">
			<a href="pdi_add.asp" class="btn btn-primary ">Tambah</a>
		</div>
	</div>
	<% end if %>
	<form action="index.asp" method="post">
		<div class="row">
			<div class="col-lg-4 mb-3">
				<label for="Agen">Cabang</label>
				<select class="form-select" aria-label="Default select example" name="agen" id="agen">
					<option value="">Pilih</option>
					<% do while not agendata.eof %>
					<option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
					<% 
					agendata.movenext
					loop
					%>
				</select>
			</div>
			<div class="col-lg-4 mb-3">
				<label for="prodid">No.Produksi</label>
				<select class="form-select" aria-label="Default select example" name="prodid" id="prodid">
					<option value="">Pilih</option>
					<% Do While not dprod.eof%>
					<option value="<%=dprod("PDI_PDDid")%>"><%= left(dprod("PDI_PDDid"),2) %>-<%= mid(dprod("PDI_PDDid"),3,3) %>/<%= mid(dprod("PDI_PDDid"),6,4) %>/<%= mid(dprod("PDI_PDDid"),10,4) %>/<%= right(dprod("PDI_PDDid"),3)  %></option>
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
								<th>No.PDI</th>
								<th>Tanggal</th>
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

								data_cmd.commandTExt = "SELECT PDI_ID FROM DLK_T_PreDevInspectionD WHERE PDI_ID = '"& rs("PDI_ID") &"'"
								set p = data_cmd.execute
								%>
										<tr><TH><%= recordcounter %></TH>
										<td>
											<%= LEFT(rs("PDI_ID"),3) &"-"& MID(rs("PDI_ID"),4,3) &"/"& "DKI-" & LEFT(UCase(rs("DivNama")),3) & "/" & rs("PDI_DepID") & "/" & MID(rs("PDI_ID"),7,4) & "/" & right("00" + cstr(rs("PDI_Revisi")),2)  & "/" &  right(rs("PDI_ID"),3) %>
										</td>
										<td><%= Cdate(rs("PDI_Date")) %></td>
										<td><%= rs("AgenNAme")%></td>
										<td><%= rs("PDI_Keterangan")%></td>
										<td class="text-center">
												<div class="btn-group" role="group" aria-label="Basic example">
														<% if not p.eof then %>
																<a href="detail.asp?id=<%= rs("PDI_ID") %>" class="btn badge text-light bg-warning">Detail</a>
														<% end if %>
														<% if session("MQ3B") = true then %>    
														<a href="pdid_u.asp?id=<%= rs("PDI_ID") %>" class="btn badge text-bg-primary" >Update</a>
														<% end if %>
														<% if session("MQ3C") = true then %>    
																<% if p.eof then %>
																		<a href="aktifh.asp?id=<%= rs("PDI_ID") %>" class="btn badge text-bg-danger btn-fakturh">Delete</a>
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
											<a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
													<a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
											<%else%>
													<a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
													<a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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

