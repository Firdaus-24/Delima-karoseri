<% 
sub tambahAsetH()
    cabang = trim(Request.Form("cabang"))
    tgl = trim(Request.Form("tgl"))
    divisi = trim(Request.Form("divisi"))
    departement = trim(Request.Form("departement"))
    pJawab = trim(Request.Form("pJawab"))
    keterangan = trim(Request.Form("keterangan"))
    id = ""

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_AsetH WHERE AsetAgenID = '"& cabang &"' AND AsetdivID = '"& divisi &"' AND AsetDepID = '"& departement &"' AND AsetUpdateTime = '"& tgl &"' AND AsetPjawab = '"& pJawab &"' AND AsetKeterangan = '"& keterangan &"' AND AsetAktifYN = 'Y'"
    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandTExt = "exec sp_AddDLK_T_AsetH '"& cabang &"','"& divisi &"','"& departement &"', '"& pJawab &"','"& keterangan &"','"& session("username") &"', '"& tgl &"'"

        set data = data_cmd.execute
        id = data("ID")
        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
    if value = 1 then
        call alert("MASTER ASET BARANG", "berhasil di tambahkan", "success","asetd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("MASTER ASET BARANG", "sudah terdaftar", "warning","asetd_add.asp?id="&id)
    else
        value = 0
    end if
end sub

sub tambahAsetD()
    ckaset = trim(Request.Form("ckaset"))
    qtyaset = trim(Request.Form("qtyaset"))
    satuan = trim(Request.Form("satuan"))

    data_cmd.commandTExt = "SELECT * FROM DLK_T_AsetD WHERE AD_Item = '"& ckaset &"' AND LEFT(AD_AsetID,10) = '"& id &"'"

    set asetd = data_cmd.execute

    ' get stok barang
    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemD.IPD_IphID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemD.IPD_IphID HAVING (dbo.DLK_M_Barang.Brg_jualYN = 'N') AND (dbo.DLK_M_Barang.Brg_StokYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("AsetAgenID") &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = '"& ckaset &"') ORDER BY dbo.DLK_T_InvPemH.IPH_Date"
    set getstok = data_cmd.execute

    if asetd.eof then
        qty = Cint(qtyaset)
        tharga = 0
        do while not getstok.eof
        ' get id data 
        data_cmd.commandTExt = "SELECT '"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(AD_AsetID),'000'),3)))+1),3) as id FROM DLK_T_AsetD WHERE LEFT(AD_AsetID,10) = '"& id &"'"

        set ddata = data_cmd.execute

        ' cek barang aset 
        data_cmd.commandTExt = "SELECT SUM(dbo.DLK_T_AsetD.AD_QtySatuan) as aset, dbo.DLK_T_AsetD.AD_Item, dbo.DLK_T_AsetD.AD_IPDIPHID FROM DLK_T_AsetD LEFT OUTER JOIN DLK_T_AsetH ON LEFT(DLK_T_AsetD.AD_AsetID,10) = DLK_T_AsetH.AsetID WHERE (dbo.DLK_T_ASetH.AsetagenID = '"&data("AsetAgenID")&"') AND (dbo.DLK_T_ASetH.AsetAktifYN = 'Y') AND (dbo.DLK_T_AsetD.AD_IPDIPHID = '"& getstok("IPD_IphID") &"') GROUP BY dbo.DLK_T_AsetD.AD_Item, dbo.DLK_T_AsetD.AD_IPDIPHID"

        set asetmaster = data_cmd.execute

        if not asetmaster.eof then
            stok = Cint(getstok("IPD_QtySatuan")) - Cint(asetmaster("aset"))

            if stok > 0 then
                if Cint(stok) > Cint(qty) then 
                    tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))

                    call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& qty &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")

                    qty = 0
                else
                    tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))
                    
                    call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& Cint(stok) &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")
                    
                    qty = qty - stok 
                end if
            end if
        else
            if Cint(qty) > Cint(getstok("IPD_Qtysatuan")) then 
                tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))

                call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& getstok("IPD_Qtysatuan") &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")

                qty = Cint(qty) - Cint(getstok("IPD_Qtysatuan"))
            else
                tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))
                
                call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& Cint(qty) &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")
                
                qty = 0
            end if
        end if
        if qty <= 0 then
            exit do
        end if
        getstok.movenext
        loop
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("DETAIL ASET BARANG", "berhasil di tambahkan", "success","asetd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("DETAIL ASET BARANG", "sudah terdaftar", "warning","asetd_add.asp?id="&id)
    else
        value = 0
    end if
end sub

sub updateAset()
    ckaset = trim(Request.Form("ckaset"))
    qtyaset = trim(Request.Form("qtyaset"))
    satuan = trim(Request.Form("satuan"))

    data_cmd.commandTExt = "SELECT * FROM DLK_T_AsetD WHERE AD_Item = '"& ckaset &"' AND LEFT(AD_AsetID,10) = '"& id &"'"

    set asetd = data_cmd.execute

    ' get stok barang
    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemD.IPD_IphID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_RakID, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemD.IPD_IphID HAVING (dbo.DLK_M_Barang.Brg_jualYN = 'N') AND (dbo.DLK_M_Barang.Brg_StokYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("AsetAgenID") &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = '"& ckaset &"') ORDER BY dbo.DLK_T_InvPemH.IPH_Date"
    set getstok = data_cmd.execute

    if asetd.eof then
        qty = Cint(qtyaset)
        tharga = 0
        do while not getstok.eof
        ' get id data 
        data_cmd.commandTExt = "SELECT '"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(AD_AsetID),'000'),3)))+1),3) as id FROM DLK_T_AsetD WHERE LEFT(AD_AsetID,10) = '"& id &"'"

        set ddata = data_cmd.execute

        ' cek barang aset 
        data_cmd.commandTExt = "SELECT SUM(dbo.DLK_T_AsetD.AD_QtySatuan) as aset, dbo.DLK_T_AsetD.AD_Item, dbo.DLK_T_AsetD.AD_IPDIPHID FROM DLK_T_AsetD LEFT OUTER JOIN DLK_T_AsetH ON LEFT(DLK_T_AsetD.AD_AsetID,10) = DLK_T_AsetH.AsetID WHERE (dbo.DLK_T_ASetH.AsetagenID = '"&data("AsetAgenID")&"') AND (dbo.DLK_T_ASetH.AsetAktifYN = 'Y') AND (dbo.DLK_T_AsetD.AD_IPDIPHID = '"& getstok("IPD_IphID") &"') GROUP BY dbo.DLK_T_AsetD.AD_Item, dbo.DLK_T_AsetD.AD_IPDIPHID"

        set asetmaster = data_cmd.execute

        if not asetmaster.eof then
            stok = Cint(getstok("IPD_QtySatuan")) - Cint(asetmaster("aset"))

            if stok > 0 then
                if Cint(stok) > Cint(qty) then 
                    tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))

                    call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& qty &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")

                    qty = 0
                else
                    tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))
                    
                    call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& Cint(stok) &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")
                    
                    qty = qty - stok 
                end if
            end if
        else
            if Cint(qty) > Cint(getstok("IPD_Qtysatuan")) then 
                tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))

                call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& getstok("IPD_Qtysatuan") &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")

                qty = Cint(qty) - Cint(getstok("IPD_Qtysatuan"))
            else
                tharga = Round(getstok("IPD_Harga") + (getstok("IPD_Harga") * getstok("IPH_PPN") / 100))
                
                call query ("INSERT INTO DLK_T_AsetD (AD_AsetID, AD_IPDIPHID, AD_Item, AD_QtySatuan, AD_Harga, AD_JenisSat, AD_RakID) VALUES('"& ddata("id") &"', '"& getstok("IPD_IPHID") &"', '"& getstok("IPD_Item") &"', '"& Cint(qty) &"', '"& tharga &"','"& satuan &"', '"& getstok("IPD_RakID") &"')")
                
                qty = 0
            end if
        end if
        if qty <= 0 then
            exit do
        end if
        getstok.movenext
        loop
        value = 1
    else
        value = 2
    end if
    if value = 1 then
        call alert("DETAIL ASET BARANG", "berhasil di tambahkan", "success","aset_u.asp?id="&id) 
    elseif value = 2 then
        call alert("DETAIL ASET BARANG", "sudah terdaftar", "warning","aset_u.asp?id="&id)
    else
        value = 0
    end if

end sub 
%>