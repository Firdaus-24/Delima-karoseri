<% 
sub tambahAppPermintaan()
    no = trim(Request.Form("no"))
    tgl = trim(Request.Form("tgl"))
    dana = trim(Request.Form("dana"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoID = '"& no &"' AND memoAktifYN = 'Y'"
    set data = data_cmd.execute
   
    if not data.eof then
        call query("UPDATE DLK_T_Memo_H SET memoApproveYN = 'Y' WHERE memoID = '"& no &"'")
        call query("sp_addDLK_T_AppPermintaan '"& no &"','"& tgl &"','"& dana &"','"& keterangan &"' ")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

' sub updateJenis()
'     id = trim(Request.Form("id"))
'     oldnama = UCase(trim(Request.Form("oldnama")))
'     nama = UCase(trim(Request.Form("nama")))
'     keterangan = trim(Request.Form("keterangan"))

'     set data_cmd =  Server.CreateObject ("ADODB.Command")
'     data_cmd.ActiveConnection = mm_delima_string

'     data_cmd.commandText = "SELECT * FROM DLK_M_JenisBarang WHERE JenisId = '"& id &"' AND JenisNama = '"& oldnama &"'"
'     set data = data_cmd.execute

'     if not data.eof then
'         call query("UPDATE DLK_M_JenisBarang SET JenisNama = '"& nama &"', JenisKeterangan = '"& keterangan &"' WHERE JenisID = '"& id &"'")
'         value = 1 'case untuk insert data
'     else
'         value = 2 'case jika gagal insert 
'     end if

' end sub 
%>