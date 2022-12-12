<!--#include file="../../init.asp"-->
<% call header("Email B.O.M") %>
<!--#include file="../../navbar.asp"-->
<% 
   id = trim(Request.Form("idbom"))
   typeapp = trim(Request.Form("typeapp"))
   userEmail = trim(Request.Form("userEmail"))
   subject = trim(Request.Form("subject"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_BOMH.BMH_ID, dbo.DLK_T_BOMH.BMH_AgenID, dbo.DLK_T_BOMH.BMH_Date, dbo.DLK_T_BOMH.BMH_PDID, dbo.DLK_T_BOMH.BMH_Day, dbo.DLK_T_BOMH.BMH_Month, dbo.DLK_T_BOMH.BMH_Keterangan,dbo.DLK_T_BOMH.BMH_Approve1, dbo.DLK_T_BOMH.BMH_Approve2, dbo.DLK_T_BOMH.BMH_AktifYN, dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_T_ProductH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_BOMH ON dbo.DLK_T_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMH.BMH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.DLK_T_BomH.BMH_ID = '"& id &"' AND dbo.DLK_T_BomH.BMH_AktifYN = 'Y'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   if not data.eof then
   ' getbarang by vendor
   data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMD.BMD_ID, dbo.DLK_T_BOMD.BMD_Item, dbo.DLK_T_BOMD.BMD_Qtysatuan, dbo.DLK_T_BOMD.BMD_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_BOMD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMD.BMD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_BOMD.BMD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_BOMD.BMD_ID, 13) = '"& data("BMH_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
   ' response.write data_cmd.commandText & "<br>"
   set barang = data_cmd.execute
   
   tabledata = ""
   do while not barang.eof
   tabledata = tabledata &"<tr style='border:1px solid black'>"&_
               "<th style='border:1px solid black'>"&barang("BMD_ID")&"</th>"&_
               "<td style='border:1px solid black'>"&barang("KategoriNama") &"-"& barang("jenisNama") &"</td>"&_
               "<td style='border:1px solid black'>"&barang("Brg_Nama") &"</td>"&_
               "<td style='border:1px solid black:text-align:center'>"&barang("BMD_QtySatuan") &"</td>"&_
               "<td style='border:1px solid black'>"&barang("Sat_nama") &"</td>"&_
            "</tr>"
   barang.movenext
   loop

   dataBody = "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
      "<div class='col'>"&_
         "<img src='http://103.111.190.162:8008/public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
      "</div>"&_
   "</div>"&_
   "<table width='100%' style='font-size:12px'>"&_
      "<tr>"&_
         "<td align='center' colspan='4' style='font-size:16px'>DETAIL FORM B.O.M</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Nomor </td>"&_
         "<td align='left'>: <b>"&data("BMH_ID")&"</b></td>"&_ 
         "<td>Cabang</td>"&_
         "<td align='left'>: " &data("AgenName")&"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Tanggal </td>"&_
         "<td align='left'>: "& Cdate(data("BMH_Date"))&"</td>"&_
         "<td>Nomor Produksi</td>"&_
         "<td align='left'>: "&data("BMH_PDID") &" | "& data("brg_nama")&"</td>"&_
      "</tr>"&_
      "<tr>"&_
         "<td>Capacity Day</td>"&_
         "<td align='left'>: "&data("BMH_day")&"</td>"&_
         "<td>Capacity Month</td>"&_
         "<td align='left'>: "&data("BMH_Month")&"</td>"&_
      "</tr>"&_ 
      "<tr>"&_
         "<td>Keterangan</td>"&_
         "<td align='left'>: "&data("BMH_Keterangan")&"</td>"&_
         "<td>Pengaju</td>"&_
         "<td align='left'>: "&session("username")&"</td>"&_
      "</tr>"&_ 
   "</table>"&_ 
   "<table width='100%' style='font-size:12px;border-collapse: collapse;right:10px;'>"&_
      "<tr style='border:1px solid black;text-align: center'>"&_
         "<th style='border:1px solid black'>ID</th>"&_
         "<th style='border:1px solid black'>Kode</th>"&_
         "<th style='border:1px solid black'>Item</th>"&_
         "<th style='border:1px solid black'>Quantity</th>"&_
         "<th style='border:1px solid black'>Satuan</th>"&_
      "</tr>"&_
      tabledata &_
    "</table>"&_
   "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
      "<tr>"&_
         "<td  colspan=2 align=center >"&_
            "<h2>"&_
               "<a href=http://103.111.190.162:8008/views/bom/p_approveBom.asp?d="& id &"&p="&typeapp&" style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> APPROVE SEKARANG </a>"&_
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
   call alert("Email", "berhasil di kirim", "success","index.asp") 
   call footer()
%>