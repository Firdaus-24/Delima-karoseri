<%
  sub Tambah()
    tgl = trim(Request.Form("tgl"))
    cabang = trim(Request.Form("cabang"))
    tfkid = trim(replace(Request.Form("tfkid"),"/",""))
    startdate = trim(Request.Form("startdate"))
    enddate = trim(Request.Form("enddate"))
    keterangan = trim(Request.Form("keterangan"))


    set data_cmd = Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string 

    data_cmd.commandTExt = "SELECT * FROM DLK_T_IncRepairH WHERE IRH_TFKID = '"& tfkid &"' AND IRH_AgenID = '"& cabang &"'"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddDLK_T_IncRepairH '"& cabang &"', '"& tfkid &"', '"& tgl &"', '"& startdate &"', '"& enddate &"', '"& keterangan &"', '"& session("userid") &"' "
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      call alert("INCOMMING UNIT INSPECTION", "berhasil di tambahkan", "success","incrd_add.asp?id="&id)
    else 
      call alert("INCOMMING UNIT INSPECTION", "sudah terdaftar!!", "error","incr_add.asp")
    end if

  end sub

  sub detailTambah()
    id = trim(Request.Form("id"))
    descripsi = trim(Request.Form("descripsi"))
    remarks = trim(Request.Form("remarks"))

    data_cmd.commandTExt = "SELECT IRH_ID FROM DLK_T_IncRepairH WHERE IRH_ID = '"& id &"'"
    set data = data_cmd.execute

    if not data.eof then
      ' settting urutan id 
      data_cmd.commandTExt = "Select ('"& id &"' + Right('00' + Convert(varchar,Convert(int,(Right(isnull(Max(IRD_IRHID),'00'),2)))+1),2)) as newid From DLK_T_IncRepairD Where Left(IRD_IRHID,13)= '"& id &"'"

      set ckid = data_cmd.execute

      call query ("INSERT INTO DLK_T_IncRepairD (IRD_IRHID,IRD_Description,IRD_Img,IRD_Remarks,IRD_Updateid) VALUES ('"& ckid("newid") &"', '"& descripsi &"' , '', '"& remarks &"', '"& session("userid") &"')")
      call alert("DETAIL KERUSAKAN UNIT", "berhasil disimpan", "success",Request.ServerVariables("HTTP_REFERER"))
    else
      call alert("NOMOR HEADER KEDATANGAN", "tidak terdaftar", "error", "./")
    end if

  end sub
%>