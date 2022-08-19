<% 
sub tambahKeb()
    id = UCase(trim(Request.Form("id")))
    nama = UCase(trim(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "select * from dlk_m_kebutuhan WHERE kebID = '"& id &"' OR kebNama = '"& nama &"'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data.eof then
        call query("insert into dlk_m_kebutuhan (kebID,KebNama,kebupdateID,kebAktifYN) VALUES ('"& id &"', '"& nama &"','"& session("username") &"','Y')")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
end sub

sub updateKeb()
    id = trim(Request.Form("id"))
    oldnama = UCase(trim(Request.Form("oldnama")))
    nama = UCase(trim(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Kebutuhan WHERE KebId = '"& id &"' AND kebNama = '"& oldnama &"' and kebUpdateID = '"& session("username") &"' and kebAktifYN = 'Y'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_Kebutuhan SET kebID = '"& id &"',kebNama = '"& nama &"', kebUpdateID = '"& session("username") &"' WHERE kebID = '"& id &"'")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if

end sub 
%>