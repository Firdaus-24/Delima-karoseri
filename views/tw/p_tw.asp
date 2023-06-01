<!--#include file="../../init.asp"-->
<% 
  if session("PP2E") = false then
    Response.Redirect("../index.asp")
  end if

  id = trim(Request.QueryString("id"))
  days = right("00" + trim(Request.QueryString("days")),2)
  tahun = trim(Request.QueryString("tahun"))
  bulan = right("00" + trim(Request.QueryString("bulan")),2)

  strtw = " TW_"&days

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_TWMP WHERE TW_MPID = '"& id &"' AND TW_Tahun = '"& tahun &"' AND TW_Bulan = '"& bulan &"' "
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  if data.eof then
    call query( "sp_AddDLK_T_TWMP '"& id &"','"& tahun &"','"& bulan &"', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0")

    call query("UPDATE DLK_T_TWMP SET "& strtw &" = 1  WHERE TW_MPID = '"& id &"' AND TW_Tahun = '"& tahun &"' AND TW_Bulan = '"& bulan &"'")
  else
    data_cmd.commandText = "SELECT "&strtw&" as result FROM DLK_T_TWMP WHERE  TW_MPID = '"& id &"' AND TW_Tahun = '"& tahun &"' AND TW_Bulan = '"& bulan &"'"
    ' response.write data_cmd.commandText & "<br>"
    set ddata = data_cmd.execute

    if not ddata.eof then
      if ddata("result") = 1 then
        call query("UPDATE DLK_T_TWMP SET "&strtw&" = 0  WHERE TW_MPID = '"& id &"' AND TW_Tahun = '"& tahun &"' AND TW_Bulan = '"& bulan &"'")
      else
        call query("UPDATE DLK_T_TWMP SET "&strtw&" = 1  WHERE TW_MPID = '"& id &"' AND TW_Tahun = '"& tahun &"' AND TW_Bulan = '"& bulan &"'")
      end if
    end if
  end if
%>