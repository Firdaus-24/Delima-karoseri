<% 
' sub tambahPurce()
'     memoId = trim(Request.Form("memoId"))
'     agen = trim(Request.Form("agen"))
'     tgl = trim(Request.Form("tgl"))
'     vendor = trim(Request.Form("vendor"))
'     tgljt = trim(Request.Form("tgljt"))
'     metpem = trim(Request.Form("metpem"))
'     diskon = trim(Request.Form("diskon"))
'     keterangan = trim(Request.Form("keterangan"))
'     if diskon = "" then
'         diskon = 0
'     end if
'     ppn = trim(Request.Form("ppn"))
'     if ppn = "" then
'         ppn = 0
'     end if  

'     set data_cmd =  Server.CreateObject ("ADODB.Command")
'     data_cmd.ActiveConnection = mm_delima_string

'     data_cmd.commandText = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AgenID = '"& agen &"' AND OPH_Date = '"& tgl &"' AND OPH_VenID = '"& vendor &"' AND OPH_JTDate = '"& tgljt &"' AND OPH_MetPem = "& metpem &" AND OPH_DiskonAll = '"& diskon &"' AND OPH_PPn = "& ppn &" AND OPH_memoId = '"& memoId &"' AND OPH_AktifYN = 'Y'"
'     ' response.write data_cmd.commandText & "<br>"
'     set data = data_cmd.execute

'     if data.eof then
'         data_cmd.commandText = "exec sp_AddDLK_T_OrPemH '"& agen &"', '"& tgl &"', '"& vendor &"', '"& tgljt &"', '"& keterangan &"', "& diskon &", "& ppn &", "& metpem &", '"& memoId &"' "
'         ' response.write data_cmd.commandText & "<br>"
'         set p = data_cmd.execute

'         id = p("ID")

'         ' nol = "000"
'         ' no = 0
'         ' for i = 0 to ubound(vitem)  
'         ' no = no + 1
'         '     data_cmd.commandText = "SELECT * FROM DLK_T_OrPemD WHERE left(OPD_OPHID,13) = '"& id &"' AND OPD_Item = '"& vitem(i) &"' AND OPD_QtySatuan = "& vqtty(i) &" AND OPD_Harga = '"& vharga(i) &"' AND OPD_JenisSat = '"& vsatuan(i) &"' AND OPD_Disc1 = '"& vdisc1(i) &"' AND OPD_Disc2 = '"& vdisc2(i) &"'"
'         '     ' response.write data_cmd.commandText & "<br>"
'         '     set q = data_cmd.execute
            
'         '     if q.eof then
                
'         '         iddetail = id & right(nol & no,3)

'         '         call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& vitem(i) &"',"& vqtty(i) &", '"& vharga(i) &"', '"& vsatuan(i) &"', '"& vdisc1(i) &"', '"& vdisc2(i) &"')")

'         '     end if
'         ' next
'         ' response.write id & "<br>"
'         value = 1 'case untuk insert data
'     else
'         value = 2 'case jika gagal insert 
'     end if
'     if value = 1 then
'         call alert("PURCHES ORDER", "berhasil di tambahkan", "success","purcesd_add.asp?id="&id) 
'     elseif value = 2 then
'         call alert("PURCHES ORDER", "sudah terdaftar", "warning", "index.asp")
'     else
'         value = 0
'     end if
' end sub

sub tambahdetailpo()
    poid = trim(Request.Form("poid"))
    ckbrgpo = trim(Request.Form("ckbrgpo"))
    hargapo = trim(replace(replace(Request.Form("hargapo"),",",""),".00",""))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    strbrg = split(ckbrgpo,",")
    ckbrgpo = trim(strbrg(0))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"' AND OPD_Item = '"& ckbrgpo &"'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "SELECT (COUNT(OPD_OPHID)) + 1 AS urut FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        nol = "000"

        iddetail = poid & right(nol & p("urut"),3)

        call query ("INSERT INTO DLK_T_OrpemD (OPD_OPHID, OPD_Item, OPD_QtySatuan, OPD_Harga, OPD_JenisSat, OPD_Disc1, OPD_Disc2) VALUES ( '"& iddetail &"','"& ckbrgpo &"', "& qtty &", "& hargapo &",'"& satuan &"', '"& disc1 &"', '"& disc2 &"')")

        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","purcesd_add.asp?id="&poid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","purcesd_add.asp?id="&poid)
    else
        value = 0
    end if
end sub

sub updatePurce()
    poid = trim(Request.Form("poid"))
    ckbrgpo = trim(Request.Form("ckbrgpo"))
    hargapo = trim(replace(replace(Request.Form("hargapo"),",",""),".00",""))
    qtty = trim(Request.Form("qtty"))
    satuan = trim(Request.Form("satuan"))
    disc1 = trim(Request.Form("disc1"))
    disc2 = trim(Request.Form("disc2"))

    strbrg = split(ckbrgpo,",")
    ckbrgpo = trim(strbrg(0))

    nol = "000"

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_OrpemD WHERE left(OPD_OPHID,13) = '"& poid &"' AND OPD_Item = '"& ckbrgpo &"'"
    ' response.write data_cmd.commandText & "<br>"
    set addetail = data_cmd.execute

    if addetail.eof then
        data_cmd.commandText = "SELECT TOP 1 (right(OPD_OPHID,3)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& poid &"' order by OPD_OPHID DESC"

        set a = data_cmd.execute
        if a.eof then
            data_cmd.commandText = "SELECT (COUNT(OPD_OPHID)) + 1 AS urut FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& poid &"'"

            set p = data_cmd.execute

            iddetail = poid & right(nol & p("urut"),3)

            call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& ckbrgpo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
        else
            iddetail = poid & right(nol & a("urut"),3)

            call query("INSERT INTO DLK_T_OrPemD (OPD_OPHID, OPD_Item,OPD_QtySatuan,OPD_Harga,OPD_JenisSat,OPD_Disc1,OPD_Disc2) VALUES ('"& iddetail &"','"& ckbrgpo &"',"& qtty &", '"& hargapo &"', '"& satuan &"', '"& disc1 &"', '"& disc2 &"') ")
        end if
        value = 1 'case untuk insert data
    else
        value = 2
    end if

    if value = 1 then
        call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","purc_u.asp?id="&poid) 
    elseif value = 2 then
        call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","purc_u.asp?id="&poid)
    else
        value = 0
    end if
end sub
%>