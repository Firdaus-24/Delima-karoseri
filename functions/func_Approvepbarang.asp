<% 
sub tambahAppPermintaan()
    no = trim(Request.Form("no"))
    tgl = trim(Request.Form("tgl"))
    dana = trim(Request.Form("dana"))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_AppPermintaan WHERE AppOPHID = '"& no &"' AND AppTgl = '"& tgl &"' AND AppDana = '"& dana &"' AND AppKeterangan = '"& keterangan &"' AND AppAktifYN = 'Y'"
    set data = data_cmd.execute
   
    if data.eof then
        call query("sp_addDLK_T_AppPermintaan '"& no &"','"& tgl &"','"& dana &"','"& keterangan &"' ")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateAppPermintaan()
    no = trim(Request.Form("no"))
    tgl = trim(Request.Form("tgl"))
    dana = replace(replace(trim(Request.Form("dana")),".00",""),",","")
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_AppPermintaan WHERE appID = '"& no &"' AND appAktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_AppPermintaan SET apptgl = '"& tgl &"', appDana = "& dana &",appKeterangan = '"& keterangan &"' WHERE appID = '"& no &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>