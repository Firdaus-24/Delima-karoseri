<% 
sub tambahReturnBarang()
    cabang = trim(Request.Form("cabang")) 
    tgl = trim(Request.Form("tgl")) 
    venid = trim(Request.Form("venid")) 
    keterangan = trim(Request.Form("keterangan")) 

    data_cmd.commandText = "SELECT * FROM DLK_T_ReturnBarangH WHERE RB_AgenID = '"& cabang &"' AND RB_Date = '"& tgl &"' AND RB_VenID = '"& venid &"' AND RB_keterangan = '"& keterangan &"'"

    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_addDLK_T_ReturnBarangH '"& cabang &"', '"& tgl &"', '"& venid &"', '"& keterangan &"', '"& session("username") &"'"
        
        set dataid = data_cmd.execute

        id = dataid("ID")
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("RETURN BARANG PEMBELIAN", "berhasil di tambahkan", "success","rbd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("RETURN BARANG PEMBELIAN", "sudah terdaftar", "warning","rb_add.asp")
    else
        value = 0
    end if
end sub
%> 