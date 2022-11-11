<% 
    sub tambahTypeBarang()
    nama = Ucase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_M_TypeBarang WHERE UPPER(T_Nama) = '"& nama &"'"
    set data = data_cmd.execute

    if data.eof then
        call query("exec sp_addDLK_M_TypeBarang '"& nama &"', '"& session("username") &"', '"& keterangan &"'")
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("MASTER TYPE BARANG", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER TYPE BARANG", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
    end sub

    sub updateTypeBarang()
    nama = Ucase(trim(Request.Form("nama")))
    keterangan = trim(Request.Form("keterangan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_M_TypeBarang WHERE T_ID = '"& id &"'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_M_TypeBarang SET T_Nama = '"& nama &"', T_UpdateID = '"& session("username") &"', T_Keterangan = '"& keterangan &"' WHERE T_ID = '"& id &"'")
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("MASTER TYPE BARANG", "berhasil di rubah", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER TYPE BARANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
    end sub
%>