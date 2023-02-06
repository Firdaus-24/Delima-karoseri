<% 
sub tambahDep()
    id = UCase(trim(Request.Form("id")))
    nama = UCase(trim(Request.Form("nama")))
    divid = UCase(trim(Request.Form("divid")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "select * from dlk_m_Departement WHERE DepID = '"& id &"'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if not data.eof then
        value = 2 'case jika gagal insert 
    else
        call query ("insert into dlk_m_Departement (DepID, DepNama, DepDivID,DepupdateID,DepAktifYN) VALUES ('"& id &"', '"& nama &"', '"& divid &"','"& session("username") &"','Y')")
        value = 1 'case untuk insert data
    end if
end sub

sub updateDep()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))
    divid = trim(Request.Form("divid"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Departement WHERE DepId = '"& id &"' AND DepNama = '"& oldnama &"' and DepAktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Departement SET DepID = '"& id &"',DepNama = '"& nama &"', depDivID = '"& divid &"', DepUpdateID = '"& session("username") &"' WHERE DepID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>