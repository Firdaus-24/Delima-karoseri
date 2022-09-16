<!--#include file="../../init.asp"-->
<% 
    id = Request.Form("idappmemo")
    custEmail = Request.Form("custEmail")
    subject = Request.Form("subject")

    set data_cmd = Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoTgl, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoKeterangan, dbo.DLK_T_Memo_H.memoAktifYN, dbo.DLK_T_Memo_H.memoApproveYN1,dbo.DLK_T_Memo_D.memoID AS Expr1, dbo.DLK_T_Memo_D.memoSpect, dbo.DLK_T_Memo_D.memoQtty, dbo.DLK_T_Memo_D.memoKeterangan AS ket2, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Divisi.DivNama,dbo.DLK_M_Departement.DepNama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_Memo_D.memoItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_Memo_D.memoSatuan = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Departement ON dbo.DLK_T_Memo_H.memoDepID = dbo.DLK_M_Departement.DepID LEFT OUTER JOIN dbo.DLK_M_Divisi ON dbo.DLK_T_Memo_H.memoDivID = dbo.DLK_M_Divisi.DivId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_Memo_H.memoAgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_Memo_H.memoID = '"& id &"') AND (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN1 <> 'Y') ORDER BY dbo.DLK_M_Barang.Brg_Nama"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if not data.eof then
    no = 0
    ' tabledata = ""
    do while not data.eof
    no = no + 1
        tabledata = tabledata &"<tr style='border:1px solid black'>"&_
                    "<th style='border:1px solid black'>"& no&"</th>"&_
                    "<td style='border:1px solid black'>"& data("Brg_Nama")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("memoSpect")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("memoQtty")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("Sat_Nama")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("memoKeterangan")&"</td>"&_
                    "</tr>"
    data.movenext
    loop
    data.movefirst

    dataBody = "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
        "<div class='col'>"&_
            "<img src='http://103.111.190.162:8008/public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
        "</div>"&_
    "</div>"&_
    "<table width='100%' style='font-size:16px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td align='center'>DETAIL PERMINTAAN BARANG</td>"&_
        "</tr>"&_
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td width='6%'>Nomor </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'><b>"&data("memoID")&"</b></td>"&_ 
            "<td width='6%'>Cabang</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("AgenName")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>Hari</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("memoTgl")&"</td>"&_
            "<td width='6%'>Departement</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("DepNama")&"</td>"&_
        "</tr>"&_ 
        "<tr>"&_
            "<td width='6%'>Tanggal </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& Cdate(data("memoTgl"))&"</td>"&_
            "<td width='6%'>Divisi</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("Divnama")&"</td>"&_
        "</tr>"&_ 
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px;border-collapse: collapse;text-align: center;right:10px;'>"&_
        "<tbody>"&_
            "<tr style='border:1px solid black'>"&_
                "<th style='border:1px solid black'>No</th>"&_
                "<th style='border:1px solid black'>Item</th>"&_
                "<th style='border:1px solid black'>Spesification</th>"&_
                "<th style='border:1px solid black'>Quantity</th>"&_
                "<th style='border:1px solid black'>Satuan</th>"&_
                "<th style='border:1px solid black'>Keterangan</th>"&_
            "</tr>"&_
                tabledata &_
        "</tbody>"&_
    "</table>"&_
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
            "<tr>"&_
                "<td width='6%'>Note</td>"&_
                "<td width='10px'>:</td>"&_
                "<td>"& data("memoketerangan")&"</td>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table width='50%' style='font-size:20px;'>"&_
        "<tbody>"&_
            "<tr>"&_
                "<td style='padding:10px;' >"&_ 
                    "Formulir Pengajuan Anggaran "& data("DepNama")&""&_
                "</td>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
        "<tr>"&_
            "<td  colspan=2 align=center >"&_
                
                "<h2>"&_
                    "<a href=http://103.111.190.162:8008/views/finance/verifikasi.asp?d="& id &" style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> VERIFIKASI SEKARANG </a>"&_
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
    Mail.To = custEmail
    'Mail.Bcc="emailyangdiCCkan@gmail.com" 'Carbon Copy

    Mail.HTMLBody=dataBody

    Mail.Send
    Set Mail = Nothing
    end if

    call header("Send Email")
%>
<!--#include file="../../navbar.asp"-->
<% 
    call alert("Email", "berhasil di kirim", "success","appmemo.asp") 
    call footer()
 %>