<!--#include file="../../init.asp"-->
<% call header("Email B.O.M") %>
<!--#include file="../../navbar.asp"-->
<% 
   id = trim(Request.Form("idproduksi"))
   typeapp = trim(Request.Form("typeapp"))
   userEmail = trim(Request.Form("userEmail"))
   subject = trim(Request.Form("subject"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' header
   data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.MKT_T_OrJulH.OJH_TimeWork FROM dbo.DLK_M_Customer INNER JOIN dbo.MKT_T_OrJulH ON dbo.DLK_M_Customer.custId = dbo.MKT_T_OrJulH.OJH_CustID RIGHT OUTER JOIN dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID ON dbo.MKT_T_OrJulH.OJH_ID = dbo.DLK_T_ProduksiH.PDH_OJHID WHERE PDH_ID = '"& id &"' AND PDH_AktifYN = 'Y'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   if not data.eof then
   ' getbarang by vendor
   data_cmd.commandText = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(PDD_ID,13) = '"& data("PDH_ID") &"' ORDER BY PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute
   
   tabledata = ""
   do while not ddata.eof
      
   tabledata = tabledata &"<tr style='border:1px solid black'>"&_
               "<th style='border:1px solid black'>"&left(ddata("PDD_id"),2) &"-"& mid(ddata("PDD_id"),3,3) &"/"& mid(ddata("PDD_id"),6,4) &"/"& mid(ddata("PDD_id"),10,4) &"/"& right(ddata("PDD_id"),3)&"</th>"&_
               "<td style='border:1px solid black'>"&left(ddata("PDD_BMID"),2) &"-"& mid(ddata("PDD_BMID"),3,3) &"/"& mid(ddata("PDD_BMID"),6,4) &"/"& right(ddata("PDD_BMID"),3) &"</td>"&_
               "<td style='border:1px solid black'>"&ddata("KategoriNama") &"</td>"&_
               "<td style='border:1px solid black'>"&ddata("jenisNama") &"</td>"&_
               "<td style='border:1px solid black'>"&ddata("Brg_Nama") &"</td>"&_
            "</tr>"
   response.flush
   ddata.movenext
   loop

   dataBody = "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
      "<div class='col'>"&_
         "<img src='"& url &"public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
      "</div>"&_
   "</div>"&_
   "<table width='100%' style='font-size:12px'>"&_
      "<tr>"&_
         "<td align='center' colspan='4' style='font-size:16px'>DETAIL FORM PRODUKSI</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Nomor </td>"&_
         "<td align='left'>: <b>"& left(data("PDH_ID"),2) &"-"& mid(data("PDH_ID"),3,3) &"/"& mid(data("PDH_ID"),6,4) &"/"&right(data("PDH_ID"),4)  &"</b></td>"&_ 
         "<td>Cabang</td>"&_
         "<td align='left'>: " &data("AgenName")&"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Tanggal </td>"&_
         "<td align='left'>: "& Cdate(data("PDH_Date"))&"</td>"&_
         "<td>Prototype</td>"&_
         "<td align='left'>: "&data("PDH_PrototypeYN")&"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Customer</td>"&_
         "<td align='left'>: "&data("CustNama")&"</td>"&_
         "<td>Estimasi Pengerjaan</td>"&_
         "<td align='left'>: "&data("OJH_TimeWork")&" Hari</td>"&_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Start Date</td>"&_
         "<td align='left'>: "&Cdate(data("PDH_StartDate"))&"</td>"&_
         "<td>End Date</td>"&_
         "<td align='left'>: "&Cdate(data("PDH_EndDate"))&"</td>"&_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Pengaju</td>"&_
         "<td align='left'>: "&session("username")&"</td>"&_
         "<td>Keterangan</td>"&_
         "<td align='left'>: "&data("PDH_Keterangan")&"</td>"&_
      "</tr>"&_ 
   "</table>"&_ 
   "<table width='100%' style='font-size:12px;border-collapse: collapse;right:10px;'>"&_
      "<tr style='border:1px solid black;text-align: center'>"&_
         "<th style='border:1px solid black'>No. Produksi</th>"&_
         "<th style='border:1px solid black'>No B.O.M</th>"&_
         "<th style='border:1px solid black'>Kategori</th>"&_
         "<th style='border:1px solid black'>Jenis</th>"&_
         "<th style='border:1px solid black'>Model</th>"&_
      "</tr>"&_
      tabledata &_
    "</table>"&_
   "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
      "<tr>"&_
         "<td  colspan=2 align=center >"&_
            "<h2>"&_
               "<a href='"& url &"views/produksi/p_approveProd.asp?d="& id &"&p="&typeapp&"' style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> APPROVE SEKARANG </a>"&_
            "</h2>"&_
         "</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td style=padding:10px;font-size:8px; align=center>"&_
            "Email ini dikirim secara otomatis, mohon untuk tidak membalas email ini"&_
         "</td>"&_
      "</tr>"&_
   "</table>"

   Set Mail = CreateObject("CDO.Message")

   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465

   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = 1
   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") ="delimakaroseri8008@gmail.com" 
   Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") ="tugcoogrhsqaunnl"

   Mail.Configuration.Fields.Update

   ' custEmail = "larasdelimakaroseri27@gmail.com"
   Mail.Subject= subject
   Mail.From="delimakaroseri8008@gmail.com"
   Mail.To = userEmail
   'Mail.Bcc="emailyangdiCCkan@gmail.com" 'Carbon Copy

   Mail.HTMLBody=dataBody
   Mail.Send
   Set Mail = Nothing
   end if
%>
<% 
   call alert("Email", "berhasil di kirim", "success","./") 
   call footer()
%>