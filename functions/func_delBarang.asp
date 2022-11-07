<% 
sub tambahDelbarang()
    delcabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    brg = trim(Request.Form("brg"))
    qty = trim(Request.Form("qty"))
    satuan = trim(Request.Form("satuan"))
    acc1 = trim(Request.Form("acc1"))
    acc2 = trim(Request.Form("acc2"))
    ket = trim(Request.Form("ket"))

    data_cmd.CommandText = "SELECT * FROM DLK_T_DelBarang WHERE DB_AgenID = '"& delcabang &"' AND DB_Date = '"& tgl &"' AND DB_Item = '"& brg &"' AND DB_Acc1 = '"& acc1 &"' AND DB_Acc2 = '"& acc2 &"' AND DB_AktifYN = 'Y'"

    set headerdata = data_cmd.execute

    ' cek data 
    data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_Disc1 FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& delcabang &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = '"& brg &"') ORDER BY DLK_T_invPemH.IPH_Date ASC"
    ' response.write data_cmd.commandText & "<br>"
    set pembelian = data_cmd.execute
    
    if headerdata.eof then
        do while not pembelian.eof

        data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan),0) AS qty, dbo.DLK_T_InvJulD.IJD_IPDIPHID, dbo.DLK_T_InvJulD.IJD_Item FROM dbo.DLK_T_InvJulD LEFT OUTER JOIN dbo.DLK_T_InvJulH ON LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) = dbo.DLK_T_InvJulH.IJH_ID WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& delcabang &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_IPDIPHID = '"& pembelian("IPD_IPHID") &"') GROUP BY dbo.DLK_T_InvJulD.IJD_IPDIPHID, dbo.DLK_T_InvJulD.IJD_Item"
        ' response.write data_cmd.commandText & "<br>"
        set penjualan = data_cmd.execute

        if penjualan.eof then
            jual = 0
        else
            jual = penjualan("qty")
        end if

        ' cek klaim barang
        data_cmd.commandTExt = "SELECT DB_IPDIPHID, DB_Date, ISNULL(SUM(DB_QtySatuan),0) AS tklaim FROM dbo.DLK_T_DelBarang WHERE DB_AktifYN = 'Y' AND DB_IPDIPHID = '"& pembelian("IPD_IPHID") &"' AND DB_AgenID = '"& delcabang &"' GROUP BY DB_IPDIPHID, DB_Date ORDER BY DB_Date ASC"
        ' response.write data_cmd.commandText & "<br>"
        set klaim = data_cmd.execute

        if not klaim.eof then
            tklaim = klaim("tklaim")
        else
            tklaim = 0
        end if

        ' cek aset 
        data_cmd.commandTExt = "SELECT ISNULL(SUM(AD_QtySatuan),0) AS taset FROM dbo.DLK_T_AsetD LEFT OUTER JOIN DLK_T_AsetH ON LEFT(DLK_T_AsetD.AD_AsetID,10) = DLK_T_AsetH.ASetID WHERE asetAktifYN = 'Y' AND AD_IPDIPHID = '"& pembelian("IPD_IPHID") &"' AND asetAgenID = '"& delcabang &"' GROUP BY AD_IPDIPHID"
        ' response.write data_cmd.commandText & "<br>"
        set aset = data_cmd.execute

        if not aset.eof then
            taset = aset("taset")
        else 
            taset = 0
        end if


        angka = Cint(pembelian("IPD_Qtysatuan")) - CInt(jual) - Cint(tklaim) - Cint(taset) 
        
        
        if angka > 0 then
            disc1 = (pembelian("IPD_Harga") * pembelian("IPD_Disc1")) / 100
            disc2 = (pembelian("IPD_Harga") * pembelian("IPD_Disc2")) / 100
            
            tharga = (pembelian("IPD_Harga") + (pembelian("IPD_Harga") * pembelian("IPH_PPn")) / 100) - disc1 - disc2
            
            if angka > Cint(qty) then
                call query ("sp_AddDLK_T_DelBarang '"& delcabang &"', '"& tgl &"', '"& brg &"', '"& pembelian("IPD_IPHID") &"', '"& qty &"', '"& tharga &"', '"& satuan &"', '"& ket &"', '','','','"& acc1 &"','"& acc2 &"'")

                qty = 0
            else
                call query ("sp_AddDLK_T_DelBarang '"& delcabang &"', '"& tgl &"', '"& brg &"', '"& pembelian("IPD_IPHID") &"','"& angka &"', '"& tharga &"', '"& satuan &"', '"& ket &"', '','','','"& acc1 &"','"& acc2 &"'")

                qty = Cint(qty) - angka
            end if
            if qty <= 0 then
                exit do
            end if
        end if
        response.flush
        pembelian.movenext
    loop
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("PENGHAPUSAN BARANG", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("PENGHAPUSAN BARANG", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end sub

sub updateDelbarang()
    delcabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    brg = trim(Request.Form("brg"))
    qty = trim(Request.Form("qty"))
    satuan = trim(Request.Form("satuan"))
    acc1 = trim(Request.Form("acc1"))
    acc2 = trim(Request.Form("acc2"))
    ket = trim(Request.Form("ket"))
    nilai = false
    nilai2 = false

    data_cmd.commandTExt = "SELECT * FROM DLK_T_DelBarang WHERE DB_ID = '"& id &"' AND DB_AktifYN = 'Y'"

    set ddata = data_cmd.execute  

    ' cek data 
    data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_Disc1 FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& delcabang &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = '"& brg &"') ORDER BY DLK_T_invPemH.IPH_Date ASC"
    ' response.write data_cmd.commandText & "<br>"
    set pembelian = data_cmd.execute  

    if not ddata.eof then
        call query("UPDATE DLK_T_DelBarang SET DB_IPDIPHID = '', DB_QtySatuan = 0, DB_Harga = '', DB_JenisSat = '', DB_Keterangan = '',DB_Acc1 = '', DB_Acc2 = '' WHERE DB_Id = '"& id &"'")

        do while not pembelian.eof
        
        data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan),0) AS qty, dbo.DLK_T_InvJulD.IJD_IPDIPHID, dbo.DLK_T_InvJulD.IJD_Item FROM dbo.DLK_T_InvJulD LEFT OUTER JOIN dbo.DLK_T_InvJulH ON LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) = dbo.DLK_T_InvJulH.IJH_ID WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& delcabang &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_IPDIPHID = '"& pembelian("IPD_IPHID") &"') GROUP BY dbo.DLK_T_InvJulD.IJD_IPDIPHID, dbo.DLK_T_InvJulD.IJD_Item"
        ' response.write data_cmd.commandText & "<br>"
        set penjualan = data_cmd.execute

        if not penjualan.eof then
            jual = penjualan("qty")
        else
            jual = 0
        end if

        ' cek klaim barang
        data_cmd.commandTExt = "SELECT DB_IPDIPHID, ISNULL(SUM(DB_QtySatuan),0) AS tklaim FROM dbo.DLK_T_DelBarang WHERE DB_AktifYN = 'Y' AND DB_IPDIPHID = '"& pembelian("IPD_IPHID") &"' AND DB_AgenID = '"& delcabang &"' GROUP BY DB_IPDIPHID "
        ' response.write data_cmd.commandText & "<br>"
        set klaim = data_cmd.execute

        if not klaim.eof then
            tklaim = klaim("tklaim")
        else
            tklaim = 0
        end if

        ' cek aset 
        data_cmd.commandTExt = "SELECT ISNULL(SUM(AD_QtySatuan),0) AS taset FROM dbo.DLK_T_AsetD LEFT OUTER JOIN DLK_T_AsetH ON LEFT(DLK_T_AsetD.AD_AsetID,10) = DLK_T_AsetH.ASetID WHERE asetAktifYN = 'Y' AND AD_IPDIPHID = '"& pembelian("IPD_IPHID") &"' AND asetAgenID = '"& delcabang &"' GROUP BY AD_IPDIPHID"
        ' response.write data_cmd.commandText & "<br>"
        set aset = data_cmd.execute

        if not aset.eof then
            taset = aset("taset")
        else 
            taset = 0
        end if

        angka = Cint(pembelian("IPD_Qtysatuan")) - CInt(jual) - Cint(tklaim) - Cint(taset)
           
        if Cint(angka) > 0 then
            disc1 = (pembelian("IPD_Harga") * pembelian("IPD_Disc1")) / 100
            disc2 = (pembelian("IPD_Harga") * pembelian("IPD_Disc2")) / 100
            
            tharga = (pembelian("IPD_Harga") + (pembelian("IPD_Harga") * pembelian("IPH_PPn")) / 100) - disc1 - disc2
            
            if angka > Cint(qty) then
                if nilai2 = false then
                    call query("UPDATE DLK_T_DelBarang SET DB_AgenID = '"& delcabang &"', DB_Date = '"& tgl &"', DB_Item = '"& brg &"',DB_IPDIPHID ='"& pembelian("IPD_IPHID") &"', DB_QtySatuan= '"& qty &"', DB_Harga = '"& tharga &"', DB_JenisSat = '"& satuan &"',DB_Keterangan = '"& ket &"', DB_Acc1 = '"& acc1 &"', DB_Acc2 = '"& acc2 &"' WHERE DB_Id = '"& id &"'")
                    nilai2 = true
                    qty = 0
                else
                    call query ("sp_AddDLK_T_DelBarang '"& delcabang &"', '"& tgl &"', '"& brg &"', '"& pembelian("IPD_IPHID") &"','"& qty &"', '"& tharga &"', '"& satuan &"', '"& ket &"', '','','','"& acc1 &"','"& acc2 &"'")
                    qty = 0
                end if
            else
                if nilai = false then
                    call query ("UPDATE DLK_T_DelBarang SET DB_AgenID ='"& delcabang &"', DB_Date = '"& tgl &"', DB_Item = '"& brg &"',DB_IPDIPHID = '"& pembelian("IPD_IPHID") &"', DB_QtySatuan = '"& angka &"', DB_Harga ='"& tharga &"', DB_JenisSat = '"& satuan &"', DB_Keterangan = '"& ket &"', DB_Acc1 = '"& acc1 &"', DB_Acc2 = '"& acc2 &"' WHERE DB_Id = '"& id &"'")
                    nilai = true 'flage untuk cek quantyty
                    qty = Cint(qty) - angka
                else    
                    call query ("sp_AddDLK_T_DelBarang '"& delcabang &"', '"& tgl &"', '"& brg &"', '"& pembelian("IPD_IPHID") &"','"& qty &"', '"& tharga &"', '"& satuan &"', '"& ket &"', '','','','"& acc1 &"','"& acc2 &"'")
                    qty = 0
                end if
                
            end if
            if qty < 0 then
                exit do
            end if
        end if

        response.flush
        pembelian.movenext
        loop
        ' value = 1
    else
        ' value = 2
    end if
    if value = 1 then
        call alert("PENGHAPUSAN BARANG", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("PENGHAPUSAN BARANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end sub
%>