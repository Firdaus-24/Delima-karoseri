<% response.buffer=false
server.ScriptTimeout=300000
%>
<!--#include file="Connections/ehistory.asp" -->
<!--#include file="Connections/cargo.asp" -->
<!--#include file="securestring.asp" -->



<html>
<head>

	<title>Print Label</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style media="screen" type="text/css">/*<![CDATA[*/@import 'css/stylesheet.css';/*]]>*/</style>
	<!-- QR -->
	<script src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery.qrcode.js"></script>
	<script type="text/javascript" src="js/qrcode.js"></script>

	<script type="text/javascript">
		function printpage() {
			//Get the print button and put it into a variable
			var printButton = document.getElementById("divprintpagebutton");
			//Set the print button visibility to 'hidden' 
		   printButton.style.visibility = 'hidden';
		   
			//Print the page content
			window.print()
			//Set the print button to 'visible' again 
			//[Delete this line if you want it to stay hidden after printing]
			printButton.style.visibility = 'visible';
				   
		}
	</script>
	
	
<style>

#btt{
     width: 265px;
     height: 189px;
     border-top: 3px solid white;
     border-bottom: 3px solid white;
     border-left: 3px solid white;
     border-right: 3px solid white;
	 
   }
 
 
p {
  font-size: 12px;
}

.bold { font-weight: bold; }


.tebal{
	font-weight: bold;
}


 .Tanggal{
	position: absolute;
	left: 175px;
	padding: 0px;
	top: 5px;
   
}


 .From{
	position: absolute;
	left: 15px;
	padding: 0px; 
	top: 60px;
   
}
.Hp2{
	position: relative;
	left: -40px;
	padding: 0px;
	height: 0px;
	top: 55px;
	
} 

 .To{
	position: absolute;
	left: 15px;
	padding: 0px;
	top: 35px;
   
}

.Hp1{
	position: relative;
	left: -40px;
	padding: 0px;
	height: 0px;
	top: 30px;
	
}

   
  .Deskripsi{
	position: absolute;
	left: 15px;
	padding: 0px;
	top: 85px;
	
}

  .Jumlah{
	position: absolute;
	left: 15px;
	padding: 0px;
	top: 100px;
	
	
}

.Asuransi{
	position: absolute;
	left: 15px;
	padding: 0px;
	top: 115px;
	
	
} 

.Total{
	position: absolute;
	left: 14px;
	padding: 0px;
	top: 130px;

}
   
  .Informasi{
	position: absolute;
	left: 15px;
	padding: 0px;
	top: 170px;
	font-size:8px;
	
	
}  


 


  

.nobtt{
	position: absolute;
	left: 170px;
	padding: 0px;
	height: 0px;
	top: 130px;
	
}  
  
.scanuntukpelacakan{
	position: absolute;
	left: 185px;
	padding: 0px;
	height: 0px;
	top: 145px;
	font-size:9px;
	
} 

.otp{
	position: absolute;
	left: 160px;
	padding: 0px;
	height: 0px;
	top: 155px;
	font-size:12px;
	
} 


#qrcodeCanvas2 {
           
			position: absolute;
			width: 60px;
			height: 50px;
			left: 175px;
			padding: 0px;
			top: 30px;
	
        }
   
   
.kiri {
    float: left;
	width: 40px;
	height: 20px;
    margin: 9px;
	left: 35px;
	top: 0px;
}
   
</style>
	
	<style type="text/css">
		@font-face
		{
		   font-family:Code39;
		   src:url(css/free3of9.ttf);
		   src:url(css/FREE3OF9.woff);
		}
	<!--
		@media screen(min-resolution: 300pi){
		img{
			image-resolution: 300dpi; 
			width: 50%;
			height: auto;
		}
		}
	-->

		.font
		{
			font-family:"Free 3 of 9 Regular";
			font-size: 23px;
			margin: 0;
			
		}



	
	
		.wrap-barcode{
			width: 264px;
			height: 182px;
			<!--border: 1px dotted #111111;-->
			
			margin: 0;
		
			
			
			display: block;
					
		}
		.barcode{
			width: 200px;
			height: 40px;
			margin: 0;
			
		
					
		}
		span, h1, h2, h3, h4{
			padding: 5px;
			margin: 0;
		
		}
		body{
			padding: 0;
			margin: 0;
		
		}
		p, hr{
			margin: 0;
			padding: 0;
		
		
		}
		
		
		
		.image-icon{
			width: 70%;
			
		}
		.new_logo{
			width: 100%;
			
		}
	#divprintpagebutton
	{
		position:fixed;
		top:1%;
		right:1%;
		background-color:#00F;
		padding-top:2%;
		margin: 10px;
		width:35%;
		text-align:center;
		color:#FF0;
		z-index:2;
	}
	table{
			width: 100%;
	
		}
	</style>

	
	
<%

dim b
b= decode(request.QueryString("b"))

nmrBTT = left(trim(b),16)

dim nobtt, bpck, cetakan
dim nmrbtt_cmd
Set nmrbtt_cmd = Server.CreateObject ("ADODB.Command")
nmrbtt_cmd.ActiveConnection = MM_cargo_STRING

nmrbtt_cmd.CommandText = "SELECT MKT_T_eConote.*, MKT_M_Customer.Cust_Name AS namapt, GLB_M_Agen.Agen_Nama AS nmtujuancabang, PCK_T_Packing.PCK_ID, isnull(PCK_T_Packing.PCK_Biaya,0) as TotalPacking, isnull(MKT_T_Asuransi.TotalBiaya,0) as TotalBiaya FROM MKT_T_eConote LEFT OUTER JOIN MKT_T_Asuransi ON MKT_T_eConote.BTTT_ID = MKT_T_Asuransi.BTTT_ID LEFT OUTER JOIN PCK_T_Packing ON MKT_T_eConote.BTTT_PackingID = PCK_T_Packing.PCK_ID LEFT OUTER JOIN GLB_M_Agen ON MKT_T_eConote.BTTt_TujuanAgenID = GLB_M_Agen.Agen_ID LEFT OUTER JOIN MKT_M_Customer ON MKT_T_eConote.BTTT_AsalCustID = MKT_M_Customer.Cust_ID WHERE mkt_t_econote.bttt_id= '"& nmrBTT &"'" 
'response.write (nmrbtt_cmd.commandtext) & "<br><br>"
Set nobtt = nmrbtt_cmd.Execute

if noBTT("BTTT_Service") = "K" then

%>

<%
				url = "https://www.dakotacargo.co.id/get-eHistory-hash.asp?hash=" & encode(nobtt("bttt_id"))
				%>
</head>

<body>
<!-- Lembar BTT untuk customer pengirim -->
		<div class="wrap-barcode" >
			
				 <div id="BTT">
				  
				  <p class="Tanggal">Tanggal : <%=nobtt("BTTT_Tanggal")%></p>
				  <img class="kiri" src="image/dlb logo.png" />
				  <h3 style="border-bottom: 2px solid white;"></h3>
				 <% if len(nobtt("BTTT_TujuanNama")) >= 21 then %>
				  <p class="To" style="font-size:7.5px;"> To : <b><%=mid(nobtt("BTTT_TujuanNama"),1,25)%></b></p>
				 <% else %>
				 <p class="To"> To : <b><%=nobtt("BTTT_TujuanNama")%></b></p>
				 <% end if %>
				 <p class="Hp1"><%=nobtt("BTTT_TujuanKota")%> - <b><%=noBTT("BTTT_TujuanTelp")%></b></p>
				 <% if len(nobtt("BTTT_AsalName")) >= 21 then %>
					<p class="From" style="font-size:7.5px;"> From : <b><%=mid(nobtt("BTTT_AsalName"),1,25)%></b></p>
				 <% else %>
				  <p class="From"> From : <b><%=nobtt("BTTT_AsalName")%></b></p>
				 <% end if %>
				  <p class="Hp2"><%=nobtt("BTTT_asalKota")%> - <b><%=nobtt("BTTT_AsalTelp")%></b></p>
				  <h3 style="border-bottom: 2px solid white;">  </h3>
				  <div id="qrcodeCanvas2" ></div>
				
			<script>
				jQuery('#qrcodeCanvas2').qrcode({
					text	: "<%=url%>",
					width 	:100,
					height	:100
				});	
			</script>
			
  <p class="Deskripsi">Deskripsi : <%=noBTT("BTTT_namaBarang")%></p>
  <p class="Jumlah">Jumlah : <%=nobtt("BTTT_Berat")%>KG / <%=nobtt("BTTT_JmlUnit")%> Colly</p>
  <p class="Asuransi">Asuransi : <% if nobtt("totalbiaya") > 0 then %> Ya <%else%> Tidak <%end if%>
  <p class="Total">Total Bayar : <span class="tebal">Rp. <%=formatnumber(nobtt("TotalPacking")+nobtt("totalBiaya")+nobtt("BTTT_Harga")+nobtt("BTTT_BiayaPenerus"),0)%></span></p>
  <p class="nobtt"><span class="tebal"><%=nobtt("BTTT_ID")%></span></p>
  <p class="scanuntukpelacakan">Scan untuk Pelacakan</p>
  <p class="otp">[ Kode OTP : <b><%=encode(nobtt("BTTT_TujuanKodepos"))%></b> ]</p>
  <p class="Informasi">untuk informasi & pengecekan kiriman www.dakotacargo.co.id</p>

				  </div>			
					
					
				
				
			</div>

	<!-- END lembar btt untuk customer pengirim -->
		
	

<!-- Lembar BTT untuk dibarang -->
		<div class="wrap-barcode" >
					
					<span></span> 
					<span style="font-size: 10px; ">
					NO BTT/RESI : [ <%=nobtt("BTTT_ID")%> ] <br/> 
					
					</span>
					
					<hr>
					<span style="font-size: 10px;margin-left:10px; letter-spacing: 10px; ">
					<B>PENERIMA<B> <br/> 
					
					</span>
					<HR>
					<span style="font-size: 12px;margin-left:10px; ">					
						<% if len(nobtt("BTTT_TujuanNama")) >= 21 then %>
								<b><%=mid(nobtt("BTTT_TujuanNama"),1,25)%> / <%=nobtt("BTTT_UP")%> </b>
						<% else %>							
								<b><%=mid(nobtt("BTTT_TujuanNama"),1,25)%> / <%=nobtt("BTTT_UP")%> </b>
						<% end if %>
					</span>
					
					<table style="font-size: 9px;padding-left:12px;">
					<tr>
						<td width="100%" colspan="2"><%=nobtt("BTTT_TujuanAlamat")%></td>
					</tr>
					<TR>
						<td colspan="2">Kel : <%=noBTT("BTTT_TujuanKelurahan")%>, Kec : <%=noBTT("BTTT_TujuanKecamatan")%>, Kota/Kab : <%=noBTT("BTTT_TujuanKota")%>, <%=noBTT("BTTT_TujuanPulau") & " "%> <%=noBTT("BTTT_TujuanKodepos")%></td>
					</TR>
					<tr>
						<td width="100%" style="font-size:14px;"><b><%=nobtt("BTTT_TujuanTelp")%></b></td>
						<td>
									<table width="100%" >
									<tr>
										
										<td width="50%" align="right">
										
											<img src="image/new_logo.png" alt="Logo Dakota Cargo" class="new_logo" style="width: 50%;">
											<br />
											<p style="font-size: 8px;">www.dakotacargo.co.id</p>
												
										</td>
										
									</tr>
								</table>
						
						</td>
					</tr>
					
					</table>
					</span>
					<hr>
					<span style="font-size: 10px;margin-left:10px; letter-spacing: 10px; ">
					<B>PENGIRIM<B> <br/> 
					</span>
					<HR>
					<span style="font-size: 12px;margin-left:10px; ">					
						<% if len(nobtt("BTTT_aSALName")) >= 21 then %>
								<b><%=mid(nobtt("BTTT_AsalName"),1,25)%></b>
						<% else %>							
								<b><%=mid(nobtt("BTTT_AsalName"),1,25)%></b>
						<% end if %>
					</span>
					<table style="font-size: 10px;padding-left:12px;">
					<tr>
						<td width="100%"><b><%=nobtt("BTTT_AsalTelp")%></b></td>
					</tr>
					
					
					</table>
					
					<span style="font-size: 6px; text-align:right;padding-top:9px;padding-left:165px; ">
					<i>[UNTUK DITEMPEL DIBARANG]</i>
					
					</span>
		
				
				
			</div>
<% end if %>
	<!-- END lembar btt untuk dibarang -->
	

		<% 
			
			dim i
			i = 0
			f = request.QueryString("f")
			t = Request.QueryString("t")

			dim btt_basekoli
			dim btt_basekoliCMD
			dim jumkol
			jumkol = 0
			set btt_basekoliCMD = server.CreateObject("ADODB.Command")
			btt_basekoliCMD.activeConnection = MM_cargo_STRING
			
			btt_basekoliCMD.commandText = "SELECT [BTTT_JmlUnit] FROM [dbs].[dbo].[MKT_T_eConote] where BTTT_ID =  '"& b &"'"
			
			set btt_basekoli = btt_basekoliCMD.execute
			
			jumkol = btt_basekoli("BTTT_JmlUnit")
			
			dim btt
			dim btt_cmd
			dim proseskoli
			proseskoli = 0
			
			set btt_cmd = server.CreateObject("ADODB.Command")
			btt_cmd.activeConnection = MM_ehistory_string
		   
		    if t <= 0 then

			'btt_cmd.commandText = "SELECT dbo.mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama AS Agen_kirim FROM  dbo.mkt_t_eConote_koli_temp LEFT OUTER JOIN dbs.dbo.MKT_T_eConote ON  dbo.mkt_t_eConote_koli_temp.BTTT_ID = dbs.dbo.MKT_T_eConote.BTTT_ID LEFT OUTER JOIN dbs.dbo.GLB_M_Agen ON dbs.dbo.MKT_T_eConote.BTTt_TujuanAgenID = dbs.dbo.GLB_M_Agen.Agen_ID LEFT OUTER JOIN                      dbo.GLB_M_Agen AS GLB_M_Agen_1 ON dbs.dbo.MKT_T_eConote.BTTt_AsalAgenID = GLB_M_Agen_1.Agen_ID WHERE  (MKT_T_eConote.BTTT_ID = '"& b &"') order by BTTT_KoliID " 			
			btt_cmd.commandText = "SELECT mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama AS Agen_kirim, COUNT(OPR_T_LoadingD.LoadD_BTTKoliID) as BTTT_Proses FROM mkt_t_eConote_koli_temp LEFT OUTER JOIN dbs.dbo.MKT_T_eConote ON mkt_t_eConote_koli_temp.BTTT_ID = dbs.dbo.MKT_T_eConote.BTTT_ID LEFT OUTER JOIN dbs.dbo.GLB_M_Agen ON dbs.dbo.MKT_T_eConote.BTTt_TujuanAgenID = dbs.dbo.GLB_M_Agen.Agen_ID LEFT OUTER JOIN GLB_M_Agen AS GLB_M_Agen_1 ON dbs.dbo.MKT_T_eConote.BTTt_AsalAgenID = GLB_M_Agen_1.Agen_ID LEFT OUTER JOIN OPR_T_LoadingD ON mkt_t_eConote_koli_temp.BTTT_KoliID = OPR_T_LoadingD.LoadD_BTTKoliID WHERE (MKT_T_eConote.BTTT_ID = '"& b &"') GROUP BY  mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama order by BTTT_KoliID " 			
		
			else
		
			'btt_cmd.commandText = "SELECT dbo.mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama AS Agen_kirim FROM  dbo.mkt_t_eConote_koli_temp LEFT OUTER JOIN dbs.dbo.MKT_T_eConote ON  dbo.mkt_t_eConote_koli_temp.BTTT_ID = dbs.dbo.MKT_T_eConote.BTTT_ID LEFT OUTER JOIN dbs.dbo.GLB_M_Agen ON dbs.dbo.MKT_T_eConote.BTTt_TujuanAgenID = dbs.dbo.GLB_M_Agen.Agen_ID LEFT OUTER JOIN                      dbo.GLB_M_Agen AS GLB_M_Agen_1 ON dbs.dbo.MKT_T_eConote.BTTt_AsalAgenID = GLB_M_Agen_1.Agen_ID WHERE (MKT_T_eConote.BTTT_ID = '"& b &"') and (substring(BTTT_KoliID,17,4) between "& f & " and " & t & ") order by BTTT_KoliID"
			btt_cmd.commandText = "SELECT mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama AS Agen_kirim, COUNT(OPR_T_LoadingD.LoadD_BTTKoliID) as BTTT_Proses FROM mkt_t_eConote_koli_temp LEFT OUTER JOIN dbs.dbo.MKT_T_eConote ON mkt_t_eConote_koli_temp.BTTT_ID = dbs.dbo.MKT_T_eConote.BTTT_ID LEFT OUTER JOIN dbs.dbo.GLB_M_Agen ON dbs.dbo.MKT_T_eConote.BTTt_TujuanAgenID = dbs.dbo.GLB_M_Agen.Agen_ID LEFT OUTER JOIN GLB_M_Agen AS GLB_M_Agen_1 ON dbs.dbo.MKT_T_eConote.BTTt_AsalAgenID = GLB_M_Agen_1.Agen_ID LEFT OUTER JOIN OPR_T_LoadingD ON mkt_t_eConote_koli_temp.BTTT_KoliID = OPR_T_LoadingD.LoadD_BTTKoliID WHERE (MKT_T_eConote.BTTT_ID = '"& b &"') and (substring(BTTT_KoliID,17,4) between "& f & " and " & t & ") GROUP BY  mkt_t_eConote_koli_temp.BTTT_KoliID, dbs.dbo.MKT_T_eConote.BTTT_ID, dbs.dbo.GLB_M_Agen.Agen_Nama, dbs.dbo.MKT_T_eConote.BTTT_TujuanAlamat, dbs.dbo.MKT_T_eConote.BTTT_TujuanKota, dbs.dbo.MKT_T_eConote.BTTT_TujuanKelurahan, dbs.dbo.MKT_T_eConote.BTTT_TujuanNama, dbs.dbo.MKT_T_eConote.BTTT_TujuanKecamatan, dbs.dbo.MKT_T_eConote.BTTT_TujuanPulau, dbs.dbo.MKT_T_eConote.BTTT_TujuanKodepos, dbs.dbo.MKT_T_eConote.BTTT_JmlUnit, GLB_M_Agen_1.Agen_Nama order by BTTT_KoliID"
		
			'response.write btt_cmd.commandText & "<HR>"
		
			end if
			
			'response.write btt_cmd.commandText
			set btt = btt_cmd.execute

			'if inSTR(btt("BTTT_KoliID"),"P") >= 1 then
			'	response.write "Sudah Dicetak Packing KOLI, tidak bisa cetak barcode koli lagi"
			'else	
			
				
			do while not btt.eof
			
			proseskoli = proseskoli + INT(btt("BTTT_Proses"))	
				
			
			
		%>

	

			<div class="wrap-barcode" >
					
					<span></span> 
					<span style="font-size: 10px; text-align:center;">
						ASAL <%=btt("Agen_Kirim")%> <br/> 
					</span> 	
					
					<table width="100%">
						<tr>	
							
						
							<td width="40%" align="center">
							
								<p style="font-size: 24px;"><b><%=int(right(btt("BTTT_KoliID"),4)) %>/</b></p>
								<p style="font-size: 10px;"><%=btt("BTTT_JmlUnit")  %></p>
								<p style="font-size: 9px;">Koli</p>
									<%' response.write i  
									%>	
							</td>
							
							<td width="60%" align="right">
								<p style="font-size: 12px;"><%=btt("BTTT_KoliID")%></p>
								<p class="font">*<%=btt("BTTT_KoliID")%>*</p>
								<p class="font">*<%=btt("BTTT_KoliID")%>*</p>
								<p style="font-size: 9px;">	<%=session("server-id")%> | Kota : <%=btt("BTTT_TujuanKota")%></p>
								
								
							</td>
						
						
						</tr>
					
					</table>
					 
					
				
				<table width="100%" >
						<tr>
							
							<td width="40%" align="right">
								<div id="qrcodeCanvas<%=btt("BTTT_KoliID")%>" ></div>
								<script>
									jQuery('#qrcodeCanvas'+'<%=btt("BTTT_KoliID")%>').qrcode({
										text	: "<%=btt("BTTT_KoliID")%>"
									});	
								</script>
							</td>
							<td width="60%" align="left">
								
								<p style="font-size: 9px;">Tujuan :</p>
								<p><b style="font-size: 11px;"> <%=btt("Agen_Nama") %></b></p>
								<p style="font-size: 9px;">To :</p>
								<p><b style="font-size: 9px;"> <%=btt("bttt_tujuanNama")%></b></p>
							
							
								<table width="100%" >
									<tr>
										
										<td width="50%" align="left">
										
											<img src="image/new_logo.png" alt="Logo Dakota Cargo" class="new_logo" style="width: 50%;">
											<br />
											<p style="font-size: 8px;">www.dakotacargo.co.id</p>
												
										</td>
										<td width="50%" align="right">
											<img src="image/up_icon.png" alt="BTT Barcode" class="image-icon" >
										</td>
									</tr>
								</table>
							
								
								
							
							</td>
						
						
						</tr>
					</table>
					
				
					
					
					
					
					
				
					
				
				
			</div>
		
	
		
		<%
				
				btt.moveNext
				loop

			'end if
		%>

		
	
	
	<div id="divprintpagebutton">
		
		<h2> KLIK CETAK BARCODE DENGAN PRINT ZEBRA </h2>
		<!--

		<button onclick="myFunction()">Tambah Ruang</button>
		<button onclick="myFunction2()">Hapus Ruang</button> 
		
		
		
		
		<br />
		<hr />
		
			<label> Cetak Urutan Ke </label>
			<input id="fromkoli" type="number" width="20" 
			<% if request.QueryString("f") = "" then 
				response.write "value=""1"""
				else
				response.write "value=" & request.QueryString("f") & ""
				end if
			%>	
			>
			<br />
			<label>Sampai</label>
			<input id="tokoli" type="number" 
			<% if request.QueryString("f") = "" then 
				response.write "value=" & i & ""
				else
				response.write "value=" & request.QueryString("t") & ""
				end if
			%>	
			>
			<br />
			<input type="button" value="Refresh" onClick="window.open('mkt_t_print_label_koli.asp?b=<%=encode(b)%>&f='+		document.getElementById('fromkoli').value+'&t='+document.getElementById('tokoli').value,'_self')">
			<input type="button" value="Reset" onclick="window.open('mkt_t_print_label_koli.asp?b=<%=encode(b)%>&f=1&t=<%=i%>','_self')">
		   
		
	
		-->
	
		<input type="button" name="printpagebutton" id="printpagebutton" value="CETAK BARCODE" onClick="printpage()" />
		<% 
		'cek dulu klo proses sudah pernah maka tidak boleh di ubah jumlah kolinya
		
		'if inSTR(btt("BTTT_KoliID"),"P") <= 0 then
				
		
		if proseskoli <= 1 then%>
<input type="button" name="regenerateKoli" id="regenerateKoli" value="Koreksi jumlah koli yang selisih" onClick="window.open('p-mkt_t_eConote_eKoliTemp_barcode.asp?b=<%=b%>&jumkol=<%=jumkol%>&pg=zeb','_self')"/>		
		<% end if 
		
		'end if
		%>
		<br>

		<%if trim(nobtt("TotalBiaya"))="0" then%>
			Untuk Menambah Asuransi Klik Tombol Tambah Asuransi<br />
			<input type="submit" name="printpagebutton" id="printpagebutton" value="Tambah Asuransi" onClick="window.open('mkt_t_econote_asuransi_a.asp?b=<%=encode(b)%>','_self')" />
			<hr>
		<%end if%>




		<BR>
		<BR>
		<input type="submit" name="printpagebutton" id="printpagebutton" value="TAMBAH BTT LAGI" onClick="window.open('mkt_t_econote_a.asp','_self')" />
		<br />
		<br />

	</div>
	
	
</body>
</html>

