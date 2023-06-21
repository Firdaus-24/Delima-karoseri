<!--#include file="../../init.asp"-->
<% 
  if session("PP6F") = false then
    Response.Redirect("./")
  end if

    ajuan = Request.Form("ajuanbomke")
    id = Request.Form("idbomrepair")
    email = Request.Form("email")
    subject = Request.Form("subject")

    set data_cmd = Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' data header
    data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.DLK_M_Brand.BrandName, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_BOMRepairH.* FROM  dbo.DLK_M_Customer INNER JOIN dbo.DLK_T_IncRepairH ON dbo.DLK_M_Customer.custId = LEFT(dbo.DLK_T_IncRepairH.IRH_TFKID, 11) INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_IncRepairH.IRH_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID INNER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID RIGHT OUTER JOIN dbo.DLK_T_BOMRepairH ON dbo.DLK_T_IncRepairH.IRH_ID = dbo.DLK_T_BOMRepairH.BmrIRHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMRepairH.BmrAgenId = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_BOMRepairH.BmrID = '"& id &"') AND (dbo.DLK_T_BOMRepairH.BmrAktifYN = 'Y')"
    set data = data_cmd.execute

    ' detail
    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_BOMRepairD.*, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM  dbo.DLK_M_JenisBarang RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_BOMRepairD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMRepairD.BmrdSatID = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_BOMRepairD.BmrdBrgID WHERE LEFT(DLK_T_BOMRepairD.BmrdID,13) = '"& data("BmrID") &"' ORDER BY Brg_Nama ASC"
    ' Response.Write data_cmd.commandTExt 
    set ddata = data_cmd.execute

    if data.eof then
      Response.Redirect("./")
    end if

    no = 0
    tabledata = ""
    do while not ddata.eof
    no = no + 1
      tabledata = tabledata & "<tr style='border:1px solid black'>"&_
              "<th style='border:1px solid black'>"& no &"</th>"&_
              "<td style='border:1px solid black'>"& ddata("KategoriNama") &" - "& ddata("jenisNama") &"</td>"&_
              "<td style='border:1px solid black'>"& ddata("Brg_Nama")&"</td>"&_
              "<td style='border:1px solid black'>"& ddata("BmrdQtysatuan")&"</td>"&_
              "<td style='border:1px solid black'>"& ddata("Sat_nama")&"</td>"&_
              "</tr>"
    response.flush
    ddata.movenext
    loop
  
    dataBody = "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
        "<div class='col'>"&_
            "<img src='"& url &"public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
        "</div>"&_
    "</div>"&_
    "<table width='100%' style='font-size:16px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td align='center'>DETAIL B.O.M.REPAIR</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td align='center'>"& left(data("BMRID"),3)&"-"&MID(data("BMRID"),4,3)&"/"&MID(data("BMRID"),7,4)&"/"&right(data("BMRID"),3) &"</td>"&_
        "</tr>"&_
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td width='6%'>Tanggal </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& Cdate(data("BmrDate"))&"</td>"&_ 
            "<td width='6%'>Cabang</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("AgenName")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>No.Produksi </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& LEFT(data("BMRPDRID"),3) &"-"& MID(data("BMRPDRID"),4,2) &"/"& RIGHT(data("BMRPDRID"),3) &"</td>"&_
            "<td width='6%'>No.Incomming</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&LEFT(data("BmrIRHID"),4) &"-"& mid(data("BmrIRHID"),5,3) &"/"& mid(data("BmrIRHID"),8,4) &"/"& right(data("BmrIRHID"),2)&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>Customer </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& data("custnama") &"</td>"&_
            "<td width='6%'>Brand</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("BrandName")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>Type </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& data("TFK_Type") &"</td>"&_
            "<td width='6%'>No.Polisi</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("TFK_Nopol")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>Total Man Power </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& data("BmrManPower") &"</td>"&_
            "<td width='6%'>Anggaran Manpower</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&Replace(formatCurrency(data("BmrTotalSalary")),"$","")&"</td>"&_
        "</tr>"&_
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px;border-collapse: collapse;text-align: center;right:10px;'>"&_
        "<tbody>"&_
            "<tr style='border:1px solid black'>"&_
                "<th style='border:1px solid black'>No</th>"&_
                "<th style='border:1px solid black'>Kode</th>"&_
                "<th style='border:1px solid black'>Barang</th>"&_
                "<th style='border:1px solid black'>Quantity</th>"&_
                "<th style='border:1px solid black'>Satuan</th>"&_
            "</tr>"&_
                tabledata &_
        "</tbody>"&_
    "</table>"&_
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
            "<tr>"&_
                "<td width='6%'>Note</td>"&_
                "<td width='10px'>:</td>"&_
                "<td>"& data("BMRKeterangan")&"</td>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
        "<tr>"&_
            "<td  colspan=2 align=center >"&_
              "<h2>"&_
                "<a href='"& url &"views/bomrepair/verifikasi.asp?d="& id &"&p="& ajuan &"' style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> VERIFIKASI SEKARANG </a>"&_
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
    Mail.To = email
    'Mail.Bcc="emailyangdiCCkan@gmail.com" 'Carbon Copy
    ' Response.Write dataBody
    Mail.HTMLBody=dataBody

    Mail.Send
    Set Mail = Nothing

    call header("Send Email")
%>
<!--#include file="../../navbar.asp"-->
<% 
    call alert("Email", "berhasil di kirim", "success", Request.ServerVariables("HTTP_REFERER")) 
    call footer()
%>
