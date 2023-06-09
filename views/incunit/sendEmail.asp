<!--#include file="../../init.asp"-->
<% 
  if session("MQ4F") = false then
    Response.Redirect("./")
  end if

    ajuan = Request.Form("ajuanincrepair")
    id = Request.Form("idincrepair")
    email = Request.Form("email")
    subject = Request.Form("subject")

    set data_cmd = Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' data header
    data_cmd.commandTExt = "SELECT DLK_T_IncRepairH.*, GLB_M_Agen.AgenName, DLK_M_Customer.custnama FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Customer ON LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = DLK_M_Customer.custid WHERE DLK_T_IncRepairH.IRH_aktifYN = 'Y' AND IRH_ID = '"& id &"'"
    set data = data_cmd.execute

    ' detail
    data_cmd.commandTExt = "SELECT DLK_T_IncRepairD.*, DLK_M_Weblogin.username FROM DLK_T_IncRepairD LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_IncRepairD.IRD_Updateid = DLK_M_Weblogin.userid WHERE LEFT(IRD_IRHID,13) = '"& data("IRH_ID") &"' ORDER BY IRD_IRHID"
    set ddata = data_cmd.execute

    if data.eof then
      Response.Redirect("./")
    end if

    no = 0
    tabledata = ""
    do while not ddata.eof
    if ddata("IRD_Img") <> "" then
      imgpath = "<img src="&getpathdoc&"/"&data("IRH_ID") &"/"&ddata("IRD_Img")&".jpg width='50' height='70'>"
    else
      imgpath = "-"
    end if

    no = no + 1
      tabledata = tabledata &"<tr style='border:1px solid black'>"&_
              "<th style='border:1px solid black'>"& no&"</th>"&_
              "<td style='border:1px solid black'>"& imgpath &"</td>"&_
              "<td style='border:1px solid black'>"& ddata("IRD_Description")&"</td>"&_
              "<td style='border:1px solid black'>"& ddata("IRD_Remarks")&"</td>"&_
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
            "<td align='center'>INCOMMING UNIT INSPECTION</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td align='center'>"& LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2) &"</td>"&_
        "</tr>"&_
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
        "<tr>"&_
            "<td width='6%'>Tanggal </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& Cdate(data("IRH_Date"))&"</td>"&_ 
            "<td width='6%'>Cabang</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("AgenName")&"</td>"&_
        "</tr>"&_
        "<tr>"&_
            "<td width='6%'>No.Penerimaan </td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"& LEFT(data("IRH_TFKID"),11) &"/"& MID(data("IRH_TFKID"),12,4) &"/"& MID(data("IRH_TFKID"),16,2) &"/"& right(data("IRH_TFKID"),3) &"</td>"&_
            "<td width='6%'>Customer</td>"&_
            "<td width='10px'>:</td>"&_
            "<td align='left'>"&data("custnama")&"</td>"&_
        "</tr>"&_
        "</tbody>"&_
    "</table>"&_ 
    "<table width='100%' style='font-size:12px;border-collapse: collapse;text-align: center;right:10px;'>"&_
        "<tbody>"&_
            "<tr style='border:1px solid black'>"&_
                "<th style='border:1px solid black'>No</th>"&_
                "<th style='border:1px solid black'>Image</th>"&_
                "<th style='border:1px solid black'>Description</th>"&_
                "<th style='border:1px solid black'>Remarks</th>"&_
            "</tr>"&_
                tabledata &_
        "</tbody>"&_
    "</table>"&_
    "<table width='100%' style='font-size:12px'>"&_
        "<tbody>"&_
            "<tr>"&_
                "<td width='6%'>Note</td>"&_
                "<td width='10px'>:</td>"&_
                "<td>"& data("IRH_Keterangan")&"</td>"&_
            "</tr>"&_
        "</tbody>"&_
    "</table>"&_
    "<table border=0 width=640 style=margin:auto;border-collapse:collapse;font-size:12px;font-family:Arial,Helvetica,sans-serif;>"&_
        "<tr>"&_
            "<td  colspan=2 align=center >"&_
              "<h2>"&_
                "<a href='"& url &"views/incunit/verifikasi.asp?d="& id &"&p="& ajuan &"' style=text-decoration:none;color:white;padding:10px;background-color:#0dcaf0;> VERIFIKASI SEKARANG </a>"&_
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
