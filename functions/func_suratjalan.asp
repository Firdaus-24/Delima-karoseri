<% 
  sub tambahsurat()
    cabang = trim(Request.Form("cabang"))
    cust = trim(Request.Form("cust"))
    tgl = trim(Request.Form("tgl"))
    keterangan = trim(Request.Form("keterangan"))

     set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string


    data_cmd.commandText = "SELECT * FROM DLK_T_SuratJalanH WHERE SJ_AgenID = '"& cabang &"' AND SJ_CustID = '"& cust &"' AND SJ_Date = '"& tgl &"'"
    set data = data_cmd.execute

    if data.eof then
      data_cmd.commandText = "exec sp_AddDLK_T_SuratJalanH '"& cabang &"', '"& tgl &"', '"& cust &"', '"& keterangan &"','"& session("userid") &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      id = p("ID")
      call alert("SURAT JALAN", "berhasil di tambahkan", "success","sjd_add.asp?id="&id)
   else 
      call alert("SURAT JALAN", "sudah terdaftar!!", "error","sj_add.asp")
    end if

  end sub

  sub detailsurat()
    id = trim(Request.Form("strid"))
    tfkid = trim(Request.Form("tfkid"))
    keterangan = trim(Request.Form("keterangan"))

   
    data_cmd.commandTExt = "SELECT * FROM DLK_T_SuratJalanD WHERE LEFT(SJD_ID,10) = '"& id &"' AND SJD_TFKID = '"& tfkid &"'"
    set detail = data_cmd.execute

    if detail.eof then
      data_cmd.commandTExt = "SELECT ('"& id &"' + Right('00' + Convert(varchar,Convert(int,(Right(isnull(Max(SJD_ID),'00'),2)))+1),2) ) as id FROM DLK_T_SuratJalanD WHERE LEFT(SJD_ID,10) = '"& id &"'"

      set p  = data_cmd.execute

      call query("INSERT INTO DLK_T_SuratJalanD (SJD_ID,SJD_TFKID,SJD_Keterangan) VALUES ('"& p("id") &"','"& tfkid &"', '"& keterangan &"') ")

      call alert("DETAIL UNIT SURAT JALAN", "berhasil di tambahkan", "success","sjd_add.asp?id="&id)
    else 
      call alert("DETAIL UNIT SURAT JALAN", "sudah terdaftar!!", "error","sjd_add.asp?id="&id)
    end if

  end sub
%>