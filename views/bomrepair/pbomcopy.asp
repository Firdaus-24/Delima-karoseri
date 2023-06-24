<!--#include file="../../init.asp"-->
<%

  id = trim(Request.form("id"))
  copyid = trim(Request.form("copyid"))

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT bmrid from DLK_T_BOMRepairH WHERE bmrid = '"& id &"' and bmraktifyn = 'Y'"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

  if not data.eof then

    data_cmd.commandTExt = "SELECT * FROM dbo.DLK_T_BOMRepairD WHERE LEFT(DLK_T_BOMRepairD.BmrdID,13) = '"& copyid &"'"

    set ddata = data_cmd.execute
    qtybaru = 0
    do while not ddata.eof 
      ' cek data barang yang sama
      data_cmd.commandTExt = "SELECT BmrdID,BmrdBrgID, Bmrdqtysatuan FROM DLK_T_BOMRepaird WHERE Bmrdbrgid = '"& ddata("BMRDbrgid") &"' AND LEFT(Bmrdid,13) = '"& id &"'"

      set ckdatadouble = data_cmd.execute

      if not ckdatadouble.eof then
        qtybaru = ckdatadouble("Bmrdqtysatuan") + ddata("Bmrdqtysatuan")
        call query("UPDATE DLK_T_BOMRepaird SET Bmrdqtysatuan = "& qtybaru &" WHERE Bmrdid = '"& ckdatadouble("Bmrdid") &"' AND Bmrdbrgid = '"& ckdatadouble("BMRDbrgid") &"'")
      else
        ' jika data smua kosong
        nol = "000"
        data_cmd.commandText = "SELECT (COUNT(bmrdid)) + 1 AS urut From DLK_T_BOMRepairD Where Left(BmrdID,13) = '"& id &"'"
        set p = data_cmd.execute

        fixid = id & right(nol & p("urut"),3) 

        call query ("INSERT INTO DLK_T_BOMRepairD (BmrdID,BmrdBrgID,BmrdQtysatuan,BmrdSatID,BmrdUpdateID,BmrdKeterangan) VALUES ('"& fixid &"','"& ddata("BmrdBrgID") &"', "& ddata("BmrdQtysatuan") &", '"& ddata("BmrdSatID") &"','"& session("userid") &"','"& ddata("BmrdKeterangan") &"')")

      end if
    Response.flush
    ddata.movenext
    loop

    Response.Write "DONE"
  else
    Response.Write "ERROR"
  end if
  
  
%>