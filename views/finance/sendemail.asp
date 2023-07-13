<!--#include file="../../init.asp"-->
<% 
    if session("FN1F") = false then
        Response.Redirect("appmemo.asp")
    end if
    
    id = Request.Form("idappmemo")
    custEmail = Request.Form("custEmail")
    subject = Request.Form("subject")

    set data_cmd = Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoBMRID, dbo.DLK_T_Memo_H.memobmid, dbo.DLK_T_Memo_H.memopdhid, dbo.DLK_T_Memo_H.memoTgl, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoKeterangan, dbo.DLK_T_Memo_H.memoAktifYN, dbo.DLK_T_Memo_H.memoKebutuhan, dbo.DLK_T_Memo_D.memoID AS Expr1, dbo.DLK_T_Memo_D.memoSpect, dbo.DLK_T_Memo_D.memoQtty, dbo.DLK_T_Memo_D.memoKeterangan AS ket2,dbo.DLK_T_Memo_D.memoHarga, dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Divisi.DivNama,dbo.HRD_M_Departement.DepNama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, DLK_M_Kebutuhan.K_Name, DLK_M_Weblogin.realname FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_Memo_D.memoItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_Memo_D.memoSatuan = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_Memo_H.memoDepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_Memo_H.memoDivID = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_Memo_H.memoAgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_Memo_H.memoupdateid = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_Memo_H.memoID = '"& id &"') AND (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') ORDER BY dbo.DLK_M_Barang.Brg_Nama"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data("memobmid") <> "" then
        document = "<tr>"&_
                        "<td width='6%'>No. Produksi</td>"&_
                        "<td width='10px'>:</td>"&_
                        "<td align='left'>"&left(data("memopdhid"),2) &"-"& mid(data("memopdhid"),3,3) &"/"& mid(data("memopdhid"),6,4) &"/"& right(data("memopdhid"),4) &"</td>"&_
                        "<td width='6%'>B.O.M Master</td>"&_
                        "<td width='10px'>:</td>"&_
                        "<td align='left'>"&left(data("memobmid"),2) &"-"&mid(data("memobmid"),3,3) &"/"& mid(data("memobmid"),6,4) &"/"& right(data("memobmid"),3)&"</td>"&_
                    "</tr>"
    elseIf data("memoBMRID") <> "" then
        document = "<tr>"&_
                    "<td width='6%'>B.O.M REPAIR</td>"&_
                    "<td width='10px'>:</td>"&_
                    "<td align='left'>"&left(data("memoBMRID"),3)&"-"&MID(data("memoBMRID"),4,3)&"/"&MID(data("memoBMRID"),7,4)&"/"&right(data("memoBMRID"),3)&"</td>"&_
                "</tr>"
    else
        document = "" 
    end if

    if not data.eof then
    no = 0
    total = 0
    do while not data.eof
    no = no + 1
    tharga = data("memoHarga") * data("memoQtty")
    total = total + tharga
        tabledata = tabledata &"<tr style='border:1px solid black'>"&_
                    "<th style='border:1px solid black'>"& no&"</th>"&_
                    "<td style='border:1px solid black'>"& data("Brg_Nama")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("memoSpect")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("memoQtty")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("Sat_Nama")&"</td>"&_
                    "<td style='border:1px solid black'>"& replace(formatCurrency(data("memoHarga")),"$","Rp.")&"</td>"&_
                    "<td style='border:1px solid black'>"& data("ket2")&"</td>"&_
                    "<td style='border:1px solid black'>"& replace(formatCurrency(tharga),"$","Rp.")&"</td>"&_
                    "</tr>"
    response.flush
    data.movenext
    loop
    data.movefirst

    onclickBtn = "<a href='"& url &"views/finance/verifikasi.asp?d="& id &"' style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0; > VERIFIKASI </a>"

    dataBody =  "<div class='row gambar' style='width:80px;height:80px;position:absolute;right:70px;'>"&_
        "<div class='col'>"&_
            "<img src='"& url &"/public/img/delimalogo.png' alt='delimalogo' style='position:absolute;width:100px;height:50px;'>"&_
        "</div>"&_
    "</div>"&_
    "<table width='100%' style='font-size:16px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td align='center'>DETAIL PERMINTAAN ANGGARAN</td>"&_
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
            "<td width='6%'>Tanggal </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& Cdate(data("memoTgl"))&"</td>"&_
            "<td width='6%'>Kebutuhan</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("K_Name")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>Divisi</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("Divnama")&"</td>"&_
            "<td width='6%'>Departement</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("DepNama")&"</td>"&_
        "</tr>"&_ 
        document&_
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
                "<th style='border:1px solid black'>Harga</th>"&_
                "<th style='border:1px solid black'>Keterangan</th>"&_
                "<th style='border:1px solid black'>Total</th>"&_
            "</tr>"&_
                tabledata &_
            "<tr style='border:1px solid black'>"&_
                "<th style='border:1px solid black' colspan='7'>Grand Total</th>"&_
                "<th style='border:1px solid black'>"&replace(formatCurrency(total),"$","Rp.")&"</th>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
            "<tr>"&_
                "<td width='6%'>Note</td>"&_
                "<td width='10px'>:</td>"&_
                "<td>"& data("memoketerangan")&"</td>"&_
            "</tr>"&_
            "<tr>"&_
                "<td width='6%'>Pengaju</td>"&_
                "<td width='10px'>:</td>"&_
                "<td>"& data("realname")&"</td>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
        "<tr>"&_
            "<td  colspan=2 align=center >"&_
                "<h2>"&_
                    onclickBtn&_
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
    Mail.To = custEmail

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