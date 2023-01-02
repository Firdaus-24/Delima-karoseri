<!--#include file="../../init.asp"-->
<% call header("Email Destroy Barang") %>
<!--#include file="../../navbar.asp"-->
<style>
   .gambar{
      width:80px;
      height:80px;
      position:absolute;
      right:70px;
   }
   .gambar img{
      position:absolute;
      width:100px;
      height:50px;
   }
   /* @page {
      size: A4;
      size: auto;  
      margin: 0;  
    } */
</style>
<% 
   id = trim(Request.Form("iddestroy"))
   ndestroy = trim(Request.Form("ndestroy"))
   emailTo = trim(Request.Form("emailTo"))
   subject = trim(Request.Form("subject"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_DelBarang.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.GLB_M_Agen.AgenID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_DelBarang.DB_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_Jenisbarang.JenisID WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') AND (dbo.DLK_T_DelBarang.DB_id = '"& id &"')"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   ' cek file document pdf
   set fs = server.createObject("Scripting.FileSystemObject")
   path =  "D:Delima\document\pdf\"& data("DB_ID") &".pdf"

   if fs.FileExists(path) then
      tdpath = "<td>: <a href='"&url&"\views\klaim\openPdf.asp?id="&data("DB_ID")&"' target='_blank'>Lihat</a></td>"
   else
      tdpath = "<td>: -</td>"
   end if
   set fs = Nothing

   ' cek gambar
   if data("DB_Image1") = "" then
      img1 = "<td align='left'>: -</td>"
   else
      img1 = "<td align='left'>: <img src='"&url&"document/image/"& data("DB_image1") &".jpg' width='40px'></td>"
   end if

   if data("DB_Image2") = "" then
      img2 = "<td align='left'>: -</td>"
   else
      img2 = "<td align='left'>: <img src='"&url&"document/image/"& data("DB_image2") &".jpg' width='40px'></td>"
   end if
   
   if data("DB_Image3") = "" then
      img3 = "<td align='left'>: -</td>"
   else
      img3 = "<td align='left'>: <img src='"&url&"document/image/"& data("DB_image3") &".jpg' width='40px'></td>"
   end if

   dataBody = "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
      "<div class='col'>"&_
         "<img src='"& url &"/public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
      "</div>"&_
   "</div>"&_
   "<div class='row'>"&_
      "<div class='col' style='text-align:center;font-size:16px'>"&_
         "DATA BARANG RUSAK"&_
      "</div>"&_
   "</div>"&_
   "<table width='100%' style='font-size:12px;border-collapse: collapse;right:10px;'>"&_
      "<tr>"&_
         "<td>Nomor </td>"&_
         "<td align='left'>: <b>"&data("DB_ID")&"</b></td>"&_ 
      "<tr>"&_
         "<td>Tanggal </td>"&_
         "<td align='left'>: "& Cdate(data("DB_Date"))&"</td>"&_
      "</tr>"&_
      "</tr>"&_
         "<td>Cabang</td>"&_
         "<td align='left'>: " &data("AgenName")&"</td>"&_
      "<tr>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Barang</td>"&_
         "<td align='left'>: "& data("brg_nama")&"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Kode</td>"&_
         "<td align='left'>: "& data("kategoriNama") &"-"& data("JenisNama") &"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Quantity</td>"&_
         "<td align='left'>: "&data("DB_Qtysatuan")&"</td>"&_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Satuan</td>"&_
         "<td align='left'>: "&data("sat_Nama")&"</td>"&_
      "</tr>"&_ 
      "<tr>"&_
         "<td colspan='2'>Document</td>"&_
      "</tr>"&_ 
      "<tr>"&_ 
         "<td>FIle Pendukung</td>"&_
         tdpath &_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Gambar 1</td>"&_
         img1 &_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Gambar 2</td>"&_
         img2 &_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Gambar 3</td>"&_
         img3 &_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Keterangan</td>"&_
         "<td align='left'>: "&data("DB_Keterangan")&"</td>"&_
      "</tr>"&_ 
   "</table>"&_ 
   
   "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
      "<tr>"&_
         "<td  colspan=2 align=center >"&_
            "<h2>"&_
               "<a href='"&url&"views/klaim/p_accDB.asp?d="& id &"&p="&ndestroy&"' style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> APPROVE SEKARANG </a>"&_
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

   Mail.Subject= subject
   Mail.From="delimakaroseri8008@gmail.com"
   Mail.To = emailTo

   Mail.HTMLBody=dataBody

   Mail.Send
   Set Mail = Nothing
%>
<% 
   call alert("Email", "berhasil di kirim", "success","index.asp") 
   call footer()
%>