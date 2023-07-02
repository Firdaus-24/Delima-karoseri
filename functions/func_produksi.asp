<% 
Sub tambahProduksiH()
    agen = trim(Request.Form("agen"))
    tgl = trim(Request.Form("tgl"))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))
    keterangan = trim(Request.Form("keterangan"))
    prototype = trim(Request.Form("prototype"))
    model = trim(Request.Form("model"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiH WHERE PDH_AgenID = '"& agen &"' AND PDH_Date = '"& tgl &"' AND PDH_StartDate = '"& tgla &"' AND PDH_EndDate = '"& tgle &"' AND PDH_ProtoTypeYN = '"& prototype &"' AND PDH_Model = '"& model &"'"

    set data = data_cmd.execute

    if data.eof then
        data_cmd.commandText = "exec sp_AddDLK_T_ProduksiH '"& agen &"', '"& tgl &"', '"& tgla &"', '"& tgle &"', '"& keterangan &"', '"& prototype &"', '"& model &"'"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute

        id = p("ID")

        value = 1 'case untuk insert data
    else
        value = 2 'case jika gagal insert 
    end if
    if value = 1 then
        call alert("FORM PRODUKSI", "berhasil ditambahkan", "success","prodd_add.asp?id="&id) 
    elseif value = 2 then
        call alert("FORM PRODUKSI", "sudah terdaftar", "warning","prod_add.asp")
    else
        value = 0
    end if
End Sub
sub tambahProduksiD()
    id = trim(Request.Form("id"))
    bomid = trim(Request.Form("bomid"))
    picname = trim(Request.Form("picname"))
    capacity = Cint(trim(Request.Form("capacity")))

    a = split(bomid,",")

    ' set id bom
    strbomid = a(0)
    ' set brg id
    strbrgid = a(1)

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiD WHERE LEFT(PDD_ID,13) = '"& id &"' AND PDD_BMID = '"& strbomid &"'"

    set data = data_cmd.execute

    if not data.eof then
        call alert("FORM DETAIL PRODUKSI", "sudah terdaftar", "error","prodd_add.asp?id="&id)
    else
        dim i
        for i=1 to capacity 
            data_cmd.commandTExt = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(PDD_ID),'000'),3)))+1),3)) as id From DLK_T_ProduksiD Where Left(PDD_ID,13) = '"& id &"'"

            set getID = data_cmd.execute

            call query("INSERT INTO DLK_T_ProduksiD (PDD_ID,PDD_BMID,PDD_Item,PDD_PICName) VALUES ('"& getID("id") &"','"& strbomid &"', '"& strbrgid &"', '"& picname &"') ")
        response.flush
        next
        call alert("FORM DETAIL PRODUKSI", "berhasil didaftarkan", "success","prodd_add.asp?id="&id)
    end if 
end sub
sub updateProduksiD()
    id = trim(Request.Form("id"))
    bomid = trim(Request.Form("bomid"))
    picname = trim(Request.Form("picname"))
    capacity = Cint(trim(Request.Form("capacity")))

    a = split(bomid,",")

    ' set id bom
    strbomid = a(0)
    ' set brg id
    strbrgid = a(1)

    data_cmd.commandTExt = "SELECT * FROM DLK_T_ProduksiD WHERE LEFT(PDD_ID,13) = '"& id &"' AND PDD_BMID = '"& strbomid &"'"

    set data = data_cmd.execute

    if not data.eof then
        call alert("FORM DETAIL PRODUKSI", "sudah terdaftar", "error","prod_u.asp?id="&id)
    else
        dim i
        for i=1 to capacity 
            data_cmd.commandTExt = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(PDD_ID),'000'),3)))+1),3)) as id From DLK_T_ProduksiD Where Left(PDD_ID,13) = '"& id &"'"

            set getID = data_cmd.execute

            call query("INSERT INTO DLK_T_ProduksiD (PDD_ID,PDD_BMID,PDD_Item,PDD_PICName) VALUES ('"& getID("id") &"','"& strbomid &"', '"& strbrgid &"','"& picname &"') ")
        response.flush
        next
        call alert("FORM DETAIL PRODUKSI", "berhasil didaftarkan", "success","prod_u.asp?id="&id)
    end if 
end sub

sub reqAnggaran()
    pdhid = trim(Request.Form("pdhid"))
    tgl = trim(Request.Form("tgl"))
    agen = trim(Request.Form("agen"))
    divisi = trim(Request.Form("divisi"))
    departement = trim(Request.Form("departement"))
    keterangan = trim(Request.Form("keterangan"))
    kebutuhan = trim(Request.Form("kebutuhan"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' cek data terserdia
    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoagenID = '"& agen &"' AND memopdhID = '"& pdhid &"' AND memoKebutuhan = "& kebutuhan &" AND memoApproveYN = 'N' AND memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

    if data.eof then
        ' cek data bom di nomor produksi
        data_cmd.commandTExt = "SELECT COUNT(PDD_BMID) AS jmlbom, PDD_BMID FROM   dbo.DLK_T_ProduksiD WHERE (LEFT(PDD_ID, 13) = '"& pdhid &"') GROUP BY PDD_BMID"
        set ckpd = data_cmd.execute

        capacity = 0
        qtybaru = 0
        do while not ckpd.EOF
            capacity = Cint(ckpd("jmlbom"))
            data_cmd.commandText = "sp_addDLK_T_Memo_H '"& tgl &"','"& agen &"','"& departement &"', '"& divisi &"', '"& keterangan &"', '"& session("userid") &"', "& kebutuhan &", '' ,'"& ckpd("PDD_BMID") &"','"& pdhid &"' ,"& capacity &" "
            set data = data_cmd.execute

            idheaderbaru = data("ID")

            ' cek detail bom 
            data_cmd.commandTExt = "SELECT * FROM DLK_M_BOMD WHERE LEFT(bmDbmID,12) = '"& ckpd("PDD_BMID") &"'"

            set getbom = data_cmd.execute
            
            
            if not getbom.eof then
                do while not getbom.eof
                    qtybaru =  getbom("BMDQtty") * capacity
                    ' get id detail bom
                    data_cmd.commandTExt = "SELECT ('"& idheaderbaru &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(memoID),'000'),3)))+1),3)) as newid FROM DLK_T_Memo_D WHERE LEFT(memoid,17) = '"& idheaderbaru &"'"

                    set newid = data_cmd.execute

                    ' get harga tertinggi di vendor
                    data_cmd.commandTExt = "SELECT ISNULL(MAX(Dven_Harga),0) as harga FROM DLK_T_VendorD where Dven_BrgID = '"& getbom("BMDItem") &"'"

                    set ckharga = data_cmd.execute


                    call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& newid("newid") &"','"& getbom("BMDItem") &"', '', "& qtybaru &",'"& getbom("BMDJenisSat") &"','', '"& ckharga("harga") &"')")

                response.flush
                getbom.movenext
                loop
            end if


        response.flush
        ckpd.movenext
        loop
        call alert("PERMINTAAN ANGGARAN PRODUKSI", "berhasil di tambahkan", "success","./") 
    else
        call alert("PERMINTAAN ANGGARAN PRODUKSI", "sudah terdaftar", "warning","./")
    end if
end sub
%>
