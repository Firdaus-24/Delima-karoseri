<!--#include file="../../init.asp"-->
<% 
  if session("PP5") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_ProduksiRepair LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiRepair.PDR_AgenID = GLB_M_Agen.AgenID WHERE DLK_T_ProduksiRepair.PDR_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute
  ' filter nomor penerimaan
  data_cmd.commandText = "SELECT PDR_TFKID FROM DLK_T_ProduksiRepair WHERE PDR_AktifYN = 'Y' ORDER BY PDR_TFKID ASC"
  set dataserahterima = data_cmd.execute
  ' filter nomor penerimaan
  data_cmd.commandText = "SELECT PDR_IRHID FROM DLK_T_ProduksiRepair WHERE PDR_AktifYN = 'Y' ORDER BY PDR_IRHID ASC"
  set dataincomming = data_cmd.execute

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
  incunit = request.QueryString("incunit")
  if len(incunit) = 0 then 
    incunit = trim(Request.Form("incunit"))
  end if
  tfk = request.QueryString("tfk")
  if len(tfk) = 0 then 
    tfk = trim(Request.Form("tfk"))
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
    filterAgen = "AND DLK_T_ProduksiRepair.PDR_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if

  if incunit <> "" then
    filterincunit = "AND DLK_T_ProduksiRepair.PDR_IRHID = '"& incunit &"'"
  else
    filterincunit = ""
  end if
  if tfk <> "" then
    filtertfk = "AND DLK_T_ProduksiRepair.PDR_TFKID = '"& tfk &"'"
  else
    filtertfk = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_ProduksiRepair.PDR_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_ProduksiRepair.PDR_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_T_ProduksiRepair.*, GLB_M_Agen.AgenName FROM DLK_T_ProduksiRepair LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiRepair.PDR_AgenID = GLB_M_Agen.AgenID WHERE PDR_AktifYN = 'Y' "& filterAgen &"  "& filtertgl &" "& filterincunit &" "& filtertfk &" "
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY PDR_ID, PDR_Date DESC"
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

  call header("Produksi Repair")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
	<div class="row">
		<div class="col-lg-12 mb-3 mt-3 text-center">
			<h3>PRODUKSI REPAIR</h3>
		</div>
	</div>
	<% 'if session("MQ3A") = true then %>
	<div class="row">
		<div class="col-lg-12 mb-3">
			<a href="pdr_add.asp" class="btn btn-primary ">Tambah</a>
		</div>
	</div>
	<% 'end if %>
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
				<label for="prodid">No.Incomming Unit</label>
				<select class="form-select" aria-label="Default select example" name="incunit" id="incunit">
					<option value="">Pilih</option>
					<%Do While not dataincomming.eof %>
            <option value="<%= dataincomming("PDR_IRHID") %>"><%= LEFT(dataincomming("PDR_IRHID"),4) &"-"& mid(dataincomming("PDR_IRHID"),5,3) &"/"& mid(dataincomming("PDR_IRHID"),8,4) &"/"& right(dataincomming("PDR_IRHID"),2) %></option>
          <%
          Response.flush
          dataincomming.movenext
          loop
          %>
				</select>
			</div>
			<div class="col-lg-4 mb-3">
				<label for="prodid">No.Serah terima</label>
				<select class="form-select" aria-label="Default select example" name="tfk" id="tfk">
					<option value="">Pilih</option>
					<%Do While not dataserahterima.eof %>
            <option value="<%= dataserahterima("PDR_TFKID") %>"><%= LEFT(dataserahterima("PDR_TFKID"),11) &"/"& MID(dataserahterima("PDR_TFKID"),12,4) &"/"& MID(dataserahterima("PDR_TFKID"),16,2) &"/"& RIGHT(dataserahterima("PDR_TFKID"),3) %></option>
          <%
          Response.flush
          dataserahterima.movenext
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
								<th>No.Produksi</th>
								<th>Tanggal</th>
								<th>No.Incomming</th>
								<th>Cabang</th>
								<th class="text-center">Aksi</th>
						</thead>
						<tbody>
								<% 
								'prints records in the table
								showrecords = recordsonpage
								recordcounter = requestrecords
								do until showrecords = 0 OR  rs.EOF
								recordcounter = recordcounter + 1
								%>
										<tr><TH><%= recordcounter %></TH>
										<th>
                      <%=LEFT(rs("PDR_ID"),3) &"-"& MID(rs("PDR_ID"),4,2) &"/"& RIGHT(rs("PDR_ID"),3) %>
										</th>
										<td><%= Cdate(rs("PDR_Date")) %></td>
										<td><a href="<%=url%>views/incunit/detail.asp?id=<%=rs("PDR_IRHID")%>" style="text-decoration:none;color:black;cursor:pointer;" target="_blank"><%= LEFT(rs("PDR_IRHID"),4) &"-"& mid(rs("PDR_IRHID"),5,3) &"/"& mid(rs("PDR_IRHID"),8,4) &"/"& right(rs("PDR_IRHID"),2) %></a></td>
										<td><%= rs("AgenNAme")%></td>
										<td class="text-center">
                      <div class="btn-group" role="group" aria-label="Basic example">
                        <%' if session("MQ3B") = true then %>    
                          <a href="pdr_u.asp?id=<%= rs("PDR_ID") %>" class="btn badge text-bg-primary" >Update</a>
                        <%' end if %>
                        <%' if session("MQ3C") = true then %>    
                          <a href="aktif.asp?id=<%= rs("PDR_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event, 'Produksi Repair')">Delete</a>
                        <%' end if %>
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
											<a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&incunit=<%=incunit%>&tfk=<%=tfk%>">&#x25C4; Prev </a>
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
													<a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&incunit=<%=incunit%>&tfk=<%=tfk%>"><%= pagelistcounter %></a> 
											<%else%>
													<a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&incunit=<%=incunit%>&tfk=<%=tfk%>"><%= pagelistcounter %></a> 
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
													<a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&incunit=<%=incunit%>&tfk=<%=tfk%>">Next &#x25BA;</a>
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

