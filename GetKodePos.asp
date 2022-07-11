<!--#include file="Connections/cargo.asp"-->



<% 
dim kelurahan

kelurahan = Request.QueryString("kelurahan")
kecamatan = Request.QueryString("kecamatan")
kodepos = request.QueryString("kodePos")
provinsi = request.QueryString("provinsi")
kota = request.QueryString("kota")

'if  (trim(kelurahan)<>"") and (trim(kecamatan)<>"") and (trim(kodepos)<>"") and (trim(provinsi)<>"") and (trim(kota)<>"") then

	dim KodePos_cmd 
	dim rs_Kodepos

	set KodePos_cmd = server.CreateObject("ADODB.Command")
	KodePos_cmd.activeConnection = MM_Kodepos_String
	kodePos_cmd.commandtext = "SELECT top 40 KodePos, DesaKelurahan, KecamatanDistrik, KotaKabupaten, Propinsi FROM GLB_M_eKodePos where DesaKelurahan like '%" & kelurahan & "%' and KecamatanDistrik like '%" & kecamatan &"%' and kodePos like '%" & kodepos & "%' and Propinsi like '%" & provinsi & "%' and KotaKabupaten like '%" & kota & "%' ORDER BY Propinsi, KotaKabupaten, KecamatanDistrik, DesaKelurahan, KodePos"
	'kodePos_cmd.commandtext = "SELECT TOP (5) GLB_M_eKodePos.KodePos, GLB_M_eKodePos.DesaKelurahan, GLB_M_eKodePos.KecamatanDistrik, GLB_M_eKodePos.KotaKabupaten, GLB_M_eKodePos.Propinsi, OPR_M_eArea.area_agenID, GLB_M_Agen.Agen_Nama, MKT_M_eHarga.minimalKG, MKT_M_eHarga.hargapokok, MKT_M_eHarga.hargakgselanjutnya, MKT_M_eHarga.keterangan FROM MKT_M_eHarga RIGHT OUTER JOIN OPR_M_eArea ON MKT_M_eHarga.Tujuan_Kecamatan = OPR_M_eArea.tujuan_kecamatan AND MKT_M_eHarga.Tujuan_Kabupaten = OPR_M_eArea.tujuan_kabupaten AND MKT_M_eHarga.Tujuan_Propinsi = OPR_M_eArea.tujuan_propinsi LEFT OUTER JOIN GLB_M_Agen ON OPR_M_eArea.area_agenID = GLB_M_Agen.Agen_ID RIGHT OUTER JOIN GLB_M_eKodePos ON OPR_M_eArea.tujuan_kecamatan = GLB_M_eKodePos.KecamatanDistrik AND OPR_M_eArea.tujuan_kabupaten = GLB_M_eKodePos.KotaKabupaten AND OPR_M_eArea.tujuan_propinsi = GLB_M_eKodePos.Propinsi WHERE DesaKelurahan like '%" & kelurahan & "%' and KecamatanDistrik like '%" & kecamatan &"%' and kodePos like '%" & kodepos & "%' and Propinsi like '%" & provinsi & "%' and KotaKabupaten like '%" & kota & "%' AND (MKT_M_eHarga.agenID_asal = '"& session("server-id") &"') ORDER BY Propinsi, KotaKabupaten, KecamatanDistrik, DesaKelurahan, KodePos"
	'response.write(kodePos_cmd.commandtext) & "<br>"
	set rs_kodepos = kodepos_cmd.execute


	%>

	<table>
	<tr>
	<th>PROPINSI</th>
	<th>KOTA/KABUPATEN</th>
	<th>KECAMATAN/DISTRIK</th>
	<th>KELURAHAN/DESA</th>
	<th>KODE POS</th>
	</tr>


	<%
	do while not rs_kodepos.eof	%>
		
	<tr>
		<td><%= rs_kodepos.fields.item("propinsi").value %></td>
		<td><%= rs_kodepos.fields.item("kotakabupaten").value %></td>
		<td><%= rs_kodepos.fields.item("kecamatandistrik").value %></td>
		<td><%= rs_kodepos.fields.item("desaKelurahan").value %></td>
		<td><%= rs_kodepos.fields.item("KodePos").value %></td>
	</tr>

	<%
	rs_kodepos.movenext
	loop
	%>

	</table>

<%'end if%>