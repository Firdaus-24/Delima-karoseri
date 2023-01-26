<!--#include file="../../init.asp"-->
<% 
    call header("Purcase Order Proses")

    memoId = trim(Request.Form("memoId"))
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    vendor = trim(Request.Form("vendor"))
    tgljt = trim(Request.Form("tgljt"))
    acpdate = trim(Request.Form("acpdate"))
    diskon = trim(Request.Form("diskon"))
    asuransi = trim(Request.Form("asuransi"))
    lain = trim(Request.Form("lain"))
    keterangan = trim(Request.Form("keterangan"))
    kebutuhan = trim(Request.Form("kebutuhan"))
    if diskon = "" then
        diskon = 0
    end if
    ppn = trim(Request.Form("ppn"))
    if ppn = "" then
        ppn = 0
    end if  

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AgenID = '"& agen &"' AND OPH_Date = '"& tgl &"' AND OPH_VenID = '"& vendor &"' AND OPH_JTDate = '"& tgljt &"' AND OPH_DiskonAll = '"& diskon &"' AND OPH_PPn = "& ppn &" AND OPH_memoId = '"& memoId &"' AND OPH_AcpDate = '"& acpdate &"' AND OPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_OrPemH '"& agen &"', '"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& acpdate &"', '"& keterangan &"', "& diskon &", "& ppn &", '"& asuransi &"', '"& lain &"', '"& memoId &"', "& kebutuhan &" "
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
%>
<!--#include file="../../navbar.asp"-->
<% 
    if value = 1 then
        call alert("PURCHES ORDER", "berhasil di tambahkan", "success","purcesd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("PURCHES ORDER", "sudah terdaftar", "warning", "index.asp")
    else
        value = 0
    end if
    call footer()
 %>