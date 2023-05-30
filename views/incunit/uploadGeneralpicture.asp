<!--#include file="../../functions/func_uploadjpg.asp"-->
<%
  if session("MQ4E") = false then
    Response.Redirect("./")
  end if

  dim id, responback, ckid, strfield
  id = trim(Request.QueryString("id"))
  responback = Request.ServerVariables("HTTP_REFERER") 'kembali ke halaman sebelumnya
  ' cek nomor id
  ckid = left(id,13)

  ' cek urutan gambar
  if right(id,1) = "A" then
    strfield = "IRH_Img1"
  Elseif right(id,1) = "B" then
    strfield = "IRH_Img2"
  Elseif right(id,1) = "C" then
    strfield = "IRH_Img3"
  Elseif right(id,1) = "D" then
    strfield = "IRH_Img4"
  Elseif right(id,1) = "E" then
    strfield = "IRH_Img5"
  else
    call alert("DOCUMENT TIDAL TERDAFTAR!!", "", "error", "./")
  end if

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
  diagnostics = TestEnvironment()
  if diagnostics<>"" then
    response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
    response.write diagnostics
    response.write "<p>After you correct this problem, reload the page."
    response.write "</div>"
  else
    OutputForm()
  end if
else
  call query("UPDATE DLK_T_IncRepairH SET "& strfield &" = '"& id &"' WHERE IRH_ID = '"& ckid &"'")

  OutputForm()
  response.write SaveFiles()
end if
%>