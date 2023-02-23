<!-- koneksi untuk ke database -->
<!-- #include file="../../init.asp"-->
<%

 if session("HR5") = false then
		Response.Redirect("../index.asp")
	end if

	'terima variable tambah data karyawan
	dim karyawan, allkaryawan
	dim karyawan_cmd, p, q, r, s, t, u, a,b,c,d,e
	
	Set karyawan_cmd = Server.CreateObject ("ADODB.Command")
	karyawan_cmd.ActiveConnection = MM_Delima_STRING
	if p = "" OR p = "Y" then
		karyawan_cmd.commandText ="SELECT * from HRD_M_Karyawan WHERE (ISNULL(Kry_DivID, '') <> '') and Kry_AktifYN = 'Y' AND Kry_Nip NOT LIKE '%A%' AND Kry_Nip NOT LIKE '%H%'"
		set karyawan = karyawan_cmd.execute
	else
		karyawan_cmd.commandText ="SELECT * from HRD_M_Karyawan WHERE (ISNULL(Kry_DivID, '') <> '') and Kry_AktifYN = 'N' AND Kry_Nip NOT LIKE '%A%' AND Kry_Nip NOT LIKE '%H%'"
		set karyawan = karyawan_cmd.execute
	end if

	' filter cabang
	karyawan_cmd.commandText = "select AgenName,agenID from HRD_M_Karyawan LEFT OUTER JOIN glb_m_agen ON HRD_M_Karyawan.Kry_AgenID = GLB_M_Agen.AgenID WHERE AgenAktifYN ='Y' GROUP BY AgenName,agenID  ORDER BY AgenName"
	set cabang = karyawan_cmd.execute


	set cabang_cmd = Server.CreateObject("ADODB.Command")
	cabang_cmd.ActiveConnection = MM_Delima_STRING

	set cabangaktif_cmd = Server.CreateObject("ADODB.Command")
	cabangaktif_cmd.ActiveConnection = MM_Delima_STRING

	Set Connection = Server.CreateObject("ADODB.Connection")
	Connection.Open MM_Delima_string

	dim recordsonpage, requestrecords, allrecords, hiddenrecords, showrecords, lastrecord, recordconter, pagelist, pagelistcounter, sqlawal
	dim tglmasuk, tglkeluar, nip, nama, aktif, orderBy
	dim angka
	dim filtertanggal, keyword, filterkeyword, tombolCari

	angka = request.QueryString("angka")
	if len(angka) = 0 then 
		angka = 1
	else 
		angka = angka + 1
	end if
	filtercabang = Request.QueryString("filtercabang")
	if len(filtercabang) = 0 then 
		filtercabang = Request.form("filtercabang")
	end if
	nama = Request.QueryString("nama")
	if len(nama) = 0 then 
		nama = Request.form("nama")
	end if
	nip = Request.QueryString("nip")
	if len(nip) = 0 then 
		nip = Request.form("nip")
	end if

	'filter ascending
	p = Request.QueryString("p")
	q = Request.QueryString("q")
	r = Request.QueryString("r")
	s = Request.QueryString("s")
	t = Request.QueryString("t")
	u = Request.QueryString("u")
	' filter descending
	a = Request.QueryString("a")
	b = Request.QueryString("b")
	c = Request.QueryString("c")
	d = Request.QueryString("d")
	e = Request.QueryString("e")

	If q <> "" then
		orderBy = "ORDER BY Kry_Nip ASC"
	elseIf r <> "" then
		orderBy = "ORDER BY Kry_Nama ASC"
	elseIf s <> "" then
		orderBy = "ORDER BY Kry_AgenID ASC"
	elseIf t <> "" then
		orderBy = "ORDER BY Kry_TglMasuk ASC" 
	elseIf u <> "" then
		orderBy = "ORDER BY Kry_TglKeluar ASC" 
	elseIf a <> "" then
		orderBy = "ORDER BY Kry_Nip DESC" 
	elseIf b <> "" then
		orderBy = "ORDER BY Kry_Nama DESC" 
	elseIf d <> "" then
		orderBy = "ORDER BY Kry_TglMasuk DESC" 
	elseIf e <> "" then
		orderBy = "ORDER BY Kry_TglKeluar DESC" 
	else 
		orderBy = " order by Kry_Nip, Kry_Nama, Kry_TglMasuk, Kry_TglKeluar"
	end if

	if filtercabang <> "" then
		filtercbg = " AND Kry_AgenID = '"& filtercabang &"'"
	else	
		filtercbg = ""
	end if

	if nama <> "" then
		filternama = " AND UPPER(Kry_Nama) LIKE '%"& nama &"%'"
	else
		filternama = ""
	end if

	if nip <> "" then
		filternip = " AND Kry_Nip = '"& nip &"'"
	else
		filternip = ""
	end if

	set rs = Server.CreateObject("ADODB.Recordset")

	if p = "" OR p = "Y" then
		sqlawal = "SELECT dbo.HRD_M_Karyawan.Kry_NIP, dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Karyawan.Kry_Nama, dbo.HRD_M_Karyawan.Kry_TglMasuk, dbo.HRD_M_Karyawan.Kry_TglKeluar, dbo.HRD_M_Karyawan.Kry_AktifYN FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.HRD_M_Karyawan.Kry_AktifYN = 'Y')"& filtercbg &""& filternama &""& filternip &""
	elseIf  p = "N" then
		sqlawal = "SELECT dbo.HRD_M_Karyawan.Kry_NIP, dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Karyawan.Kry_Nama, dbo.HRD_M_Karyawan.Kry_TglMasuk, dbo.HRD_M_Karyawan.Kry_TglKeluar, dbo.HRD_M_Karyawan.Kry_AktifYN FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID WHERE Kry_AktifYN = 'N' "& filtercbg &""& filternama &""& filternip &""
	end if

	sql=sqlawal + orderBy
	rs.open sql, Connection
	' records per halaman
	recordsonpage = 15
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
	set rs = server.CreateObject("adodb.recordset")
	if p = "" OR p = "Y" then
		sqlawal = "SELECT dbo.HRD_M_Karyawan.Kry_NIP, dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Karyawan.Kry_Nama, dbo.HRD_M_Karyawan.Kry_TglMasuk, dbo.HRD_M_Karyawan.Kry_TglKeluar, dbo.HRD_M_Karyawan.Kry_AktifYN FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.HRD_M_Karyawan.Kry_AktifYN = 'Y')"& filtercbg &""& filternama &""& filternip &""	
	elseIf  p = "N" then
		sqlawal = "SELECT dbo.HRD_M_Karyawan.Kry_NIP, dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Karyawan.Kry_Nama, dbo.HRD_M_Karyawan.Kry_TglMasuk, dbo.HRD_M_Karyawan.Kry_TglKeluar, dbo.HRD_M_Karyawan.Kry_AktifYN FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.HRD_M_Karyawan.Kry_AktifYN = 'N')"& filtercbg &""& filternama &""& filternip &""
	end if
	sql=sqlawal + orderBy
	rs.open sql, Connection
	' reads first records (offset) without showing them (can't find another solution!)
	hiddenrecords = requestrecords
	do until hiddenrecords = 0 OR rs.EOF
	hiddenrecords = hiddenrecords - 1
	rs.movenext
	if rs.EOF then
		lastrecord = 1
	end if	
	loop

	call header("Master Karyawan")
 %>
<!--#include file="../../navbar.asp"-->
<div class="container">
	<div class='row mb-3 mt-3'>
		<div class='col-sm-12 text-center'>
			<h3>DAFTAR KARYAWAN</h3>
		</div>
	</div>
	<div class="row">
		<div class="col md-3">
		<div class='row'>
			<div class='d-grid gap-2 d-md-block'>
			<%if session("HR5A") = true then %>
				<a class ="btn btn-primary mb-2" href="kary_add.asp">Tambah Data</a>	
			<%end if %>
			</div>
		</div>
	</div>
	<form action="index.asp" method="post">
			<div class="row mb-3 formcari">
				<div class="col-sm-3">
					<select class="form-select" aria-label="Default select example" name="filtercabang" id="filtercabang">
						<option value="">Pilih Area</option>	
					<%
					do until cabang.eof
					%>
						<option value="<%= cabang("agenID") %> "><%= cabang("agenName") %> </option>
					<% 
					cabang.movenext
					loop
					%> 
					</select>
				</div>
				<div class="col-sm-3">
					<input type="text" class="form-control" placeholder="Cari Berdasarkan Nama" name="nama" id="nama" autocomplete="off">
				</div>
				<div class="col-sm-3">
					<input type="text" class="form-control" placeholder="Cari Berdasarkan Nip" name="nip" id="nip" autocomplete="off">
				</div>
				<div class="col-sm-1">
					<div class="form-check form-switch">
						<%' if rs("Kry_AktifYN") = "Y" then%>
							<input class="form-check-input" type="checkbox" name="aktif" id="keywordNonAktif" value="Y" onclick="return window.location.href='index.asp?p=N'" checked>
						<%' else %>
							<input class="form-check-input" type="checkbox" name="aktif" id="keywordNonAktif" value="N" onclick="return window.location.href='index.asp?p=Y'">
						<%' end if %>
						<label class="form-check-label" for="flexSwitchCheckChecked">Aktif </label>
					</div>
				</div>
				<div class='col-sm-2'>
					<button type="submit" class="btn btn-success" name="submit" id="submit">Cari</button>
				</div>
			</div>
		<input name="urut" id="urut"  type="hidden" value="<%response.write angka%>" size="1" hidden="">
	</form>	
	<div class="row">
		<div class="col-sm-12">
			<table class="table table-dark table-striped" cellpadding="10" cellspacing="0" id="table" style="font-size:14px;">
						<thead>
							<tr>
								<th>
									<% if orderBy = "ORDER BY Kry_Nip ASC" then %>
										<a href="index.asp?a=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i> NIP</a> 
									<% else %>
										<a href="index.asp?q=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i> NIP</a>
									<% end if %>
								</th>
								<th>
									<% if orderBy = "ORDER BY Kry_Nama ASC" then %>
										<a href="index.asp?b=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i> NAMA</a>
									<% else %>
										<a href="index.asp?r=OBK_NM&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i> NAMA</a>
									<% end if %>
								</th>
								<th>
									<% if orderBy = "ORDER BY Kry_AgenID ASC" then %>
										<a href="index.asp?c=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i> Cabang</a>
									<% else %>
										<a href="index.asp?s=OBK_A&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i> Cabang</a>
									<% end if %>
								</th>
								<th>
									<% if orderBy = "ORDER BY Kry_TglMasuk ASC" then %>
										<a href="index.asp?d=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i> TGL.MASUK</a>
									<% else %>
										<a href="index.asp?t=OBK_TM&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i> TGL.MASUK</a>
									<% end if %>
								</th>
								<th>
									<% if orderBy = "ORDER BY Kry_TglKeluar ASC" then %>
										<a href="index.asp?e=OBK_N&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i> TGL.KELUAR</a>
									<% else %>
										<a href="index.asp?u=OBK_TK&p=<%= p %>" style="text-decoration:none;color:#fff;font-size:14px;"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i> TGL.KELUAR</a>
									<% end if %>
								</th>
								<th class="text-center" id="thaktif" style="font-size:14px;">AKTIF</th>
								<th class="text-center" id="thdetail" style="font-size:14px;">DETAIL</th>
							</tr>
						</thead>
						<%
							'prints records in the table
							showrecords = recordsonpage
							recordcounter = requestrecords
							do until showrecords = 0 OR  rs.EOF
							recordcounter = recordcounter + 1
							
						%>
							<tr>
								<td><%= rs("Kry_NIP")%></td>
								<td><%= rs("Kry_Nama")%></td> 
								<td><%= rs("agenName")%></td>
								<td><%= rs("Kry_TglMasuk")%></td>
								<td>
									<% if rs("Kry_TglKeluar") = "1/1/1900" then %>
										
									<% else %>
										<%= rs("Kry_TglKeluar") %>
									<% end if %>
								</td>
								<td class="text-center">
									<% if session("HR5C") = true then %>
										<% if rs("Kry_AktifYN") = "Y" then %>
											<button type="button" class="btn btn-outline-success btn-sm" onclick="return confirm('YAKIN UNTUK DIRUBAH???') == true?window.location.href='updateaktif.asp?p=Y&q=<%= rs("Kry_Nip") %>': false"><%= rs("Kry_AktifYN")%></button>
										<% else %>
											<button type="button" class="btn btn-outline-danger btn-sm" onclick="return confirm('YAKIN UNTUK DIRUBAH???') == true? window.location.href='updateaktif.asp?p=N&q=<%= rs("Kry_Nip") %>': false"><%= rs("Kry_AktifYN")%></button>
										<% end if %>
									<% else %>
										<% if rs("Kry_AktifYN") = "Y" then %>
											Aktif
										<% else %>
											NonAktif
										<% end if %>
									<% end if %>
								</td>
								<td>
									<a href="detail.asp?nip=<%= rs("Kry_NIP")%>" class="btn btn-outline-info btn-sm btn-detail" name="detail">Detail</a>
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
					</table>
		</div>
	</div>
					
				<!-- paggination -->
					<nav aria-label="Page navigation example">
						<ul class="pagination">
							<li class="page-item">
								<% 
								page = Request.QueryString("page")
								if page = "" then
									npage = 1
								else
									npage = page - 1
								end if
								if requestrecords <> 0 then %>
								<a class="page-link" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&p=<%=p%>&q=<%= q %>&r=<%= r %>&s=<%= s %>&t=<%= t %>&u=<%= u %>&a=<%= a %>&b=<%= b %>&c=<%= c %>&d=<%= d %>&e=<%= e %>">&#x25C4; Previous </a>
								<% else %>
								<p class="page-link-p">&#x25C4; Previous </p>
								<% end if %>
							</li>
							<li class="page-item d-flex" style="overflow-y:auto;">	
								<%
								pagelist = 0
								pagelistcounter = 0
								maxpage = 5
								nomor = 0
								do until pagelist > allrecords  
								pagelistcounter = pagelistcounter + 1
									if page = "" then
										page = 1
									else
										page = page
									end if
									
									if Cint(page) = pagelistcounter then
								%>	
									<a class="page-link hal d-flex bg-primary text-light" href="index.asp?offset=<%= pagelist %>&page=<%=pagelistcounter%>&p=<%=p%>&q=<%= q %>&r=<%= r %>&s=<%= s %>&t=<%= t %>&u=<%= u %>&a=<%= a %>&b=<%= b %>&c=<%= c %>&d=<%= d %>&e=<%= e %>"><%= pagelistcounter %></a>  
									<% else %>
									<a class="page-link hal d-flex" href="index.asp?offset=<%= pagelist %>&page=<%=pagelistcounter%>&p=<%=p%>&q=<%= q %>&r=<%= r %>&s=<%= s %>&t=<%= t %>&u=<%= u %>&a=<%= a %>&b=<%= b %>&c=<%= c %>&d=<%= d %>&e=<%= e %>"><%= pagelistcounter %></a>  
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
								<a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&p=<%=p%>&q=<%= q %>&r=<%= r %>&s=<%= s %>&t=<%= t %>&u=<%= u %>&a=<%= a %>&b=<%= b %>&c=<%= c %>&d=<%= d %>&e=<%= e %>">Next &#x25BA;</a>
								<% else %>
								<p class="page-link next-p">Next &#x25BA;</p>
								<% end if %>
							</li>	
						</ul>
					</nav>
				<!-- end pagging -->
			</div>
		</div>
  
<% call footer() %>
