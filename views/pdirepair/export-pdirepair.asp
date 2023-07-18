<!--#include file="../../init.asp"-->
<% 
  if session("MQ5D") = false then
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' header
  data_cmd.commandTExt = "SELECT dbo.DLK_T_PDIRepairH.*, dbo.DLK_M_Brand.BrandName, dbo.GLB_M_Agen.AgenName, HRD_M_Divisi.divnama, HRD_M_Departement.depnama FROM dbo.DLK_T_PDIRepairH LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_PDIRepairH.PDIR_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_PDIRepairH.PDIR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_PDIRepairH.PDIR_DivId = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN HRD_M_Departement ON DLK_T_PDIRepairH.PDIR_DepID = HRD_M_Departement.depid WHERE (dbo.DLK_T_PDIRepairH.PDIR_AktifYN = 'Y') AND (dbo.DLK_T_PDIRepairH.PDIR_ID = '"& id &"')"
  set data = data_cmd.execute

  ' detail
  data_cmd.commandTExt = "SELECT * FROM DLK_T_PDIRepairD WHERE LEFT(PDIR_ID,14) = '"& data("PDIR_ID") &"' ORDER BY PDIR_id ASC"
  set ddata = data_cmd.execute

  ' income unit detail
  data_cmd.commandTExt = "SELECT dbo.DLK_T_IncRepairD.IRD_Img, dbo.DLK_T_IncRepairH.IRH_ID, dbo.DLK_T_IncRepairD.IRD_IRHID FROM dbo.DLK_T_IncRepairH RIGHT OUTER JOIN dbo.DLK_T_IncRepairD ON dbo.DLK_T_IncRepairH.IRH_ID = LEFT(dbo.DLK_T_IncRepairD.IRD_IRHID, 13) WHERE irh_id = '"& data("PDIR_irhID") &"' ORDER BY dbo.DLK_T_IncRepairD.IRD_IRHID"

  set dird = data_cmd.execute

  call header("PDI Repair")
%>
<link href="../../public/css/pdirepair.css" rel="stylesheet" />
<body onload="window.print()"> 
  <div class="rowpdirepair gambar">
    <div class="col ">
      <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
    </div>
  </div>
  <div class='labelHeaderPdirepair'>
    <span><h3>DETAIL PRE DELIVERY INSPECTION  REPAIR</h3></span>
    <span><h3><%= LEFT(data("PDIR_ID"),4) &"-"& MID(data("PDIR_ID"),5,3) &"/"& "DKI-" & LEFT(UCase(data("DivNama")),3) & "/" & data("PDIR_DepID") & "/" & MID(data("PDIR_ID"),8,4) & "/" & right("00" + cstr(data("PDIR_Revisi")),2)  & "/" &  right(data("PDIR_ID"),3) %></h3></span>
  </div>
  <div class='rowpdirepair'>
    <span>Tanggal</span>
    <span>: <%= Cdate(data("PDIR_Date")) %></span>
    <span>Cabang</span>
    <span>: <%= data("agenname") %></span>
  </div>
  <div class="rowpdirepair">
    <span>
      Divisi
    </span>
    <span>
      : <%= data("divNama") %>
    </span>
    <span>
      Departement
    </span>
    <span>
      : <%= data("depNama") %>
    </span>
  </div>
  <div class="rowpdirepair">
    <span>
      No.Produksi
    </span>
    <span>
      : <%= left(data("PDIR_pdrid"),3) %>-<%= mid(data("PDIR_pdrid"),4,2) %>/<%= right(data("PDIR_pdrid"),3)  %>
    </span>
    <span>
      Brand
    </span>
    <span>
      : <%= data("brandname")  %>
    </span>
  </div>
  <div class="rowpdirepair">
    <span>
      Type
    </span>
    <span>
      : <%= data("PDIR_Type")  %>
    </span>
    <span>
      No.Polisi
    </span>
    <span>
      : <%= data("PDIR_nopol")  %>
    </span>
  </div>
  <div class="rowpdirepair">
    <span>
      Refisi Ke -
    </span>
    <span>
      : <%= data("PDIR_Revisi")  %>
    </span>
    <span>
      Keterangan
    </span>
    <span>
      : <%= data("PDIR_Keterangan")  %>
    </span>
  </div>
  <table class="tablepdirepair" width="100">
    <thead style="height:5rem;color:#fff;border-color:#fff" class="bg-primary">
      <tr>
        <th scope="col" rowspan="2" class="text-center">Before</th>
        <th scope="col" rowspan="2" class="text-center">After</th>
        <th scope="col" rowspan="2" class="text-center">Description</th>
        <th scope="col" rowspan="2" class="text-center">Remaks</th>
        <th scope="col" colspan="3" class="text-center">Condition</th>
        <tr>
          <td class="text-center">Good</td>
          <td class="text-center">Bad</td>
          <td class="text-center">Not</td>
        </tr>
      </tr>
    </thead>
    <tbody style="vertical-align:middle;">
      <% 
      do while not ddata.EOF
      %>
      <tr>
        <td class="text-center">
          <% 
          ' cek jika tidak ada gambar before
          geturlbefore = right(getpathdoc&dird("IRH_ID")&"/"&ddata("PDIR_IRDIRHID")&".jpg",5)
          if left(geturlbefore,1) = "/" then
          %>
            <img src="<%= getpathdoc %>noPhoto.jpg" width="40" style="padding:5px;">
          <%else%>
            <img src="<%= getpathdoc %><%= dird("IRH_ID") %>/<%= ddata("PDIR_IRDIRHID") %>.jpg" width="40" style="padding:5px;">
          <%end if%>
        </td>
        <td style="width:80px;heigth:100px;">
          <div class="position-relative text-center" style="heigth:5rem">
          <% if ddata("PDIR_Img") = "" then%>
            <img src="<%= getpathdoc %>noPhoto.jpg" width="40" style="padding:5px;">
          <%else%>
            <div class="text-center">
              <img src="<%= getpathdoc %>/<%= data("PDIR_ID") %>/<%= ddata("PDIR_Img") %>.jpg" id="imgDetailpdirepair" width="40" style="padding:5px;" >
            </div>
          <%end if%>
            <div class="position-absolute top-50 start-50 translate-middle">
              <button type="submit" class="btn btn-light btnPostingDetailpdirepair<%=ddata("PDIR_ID")%>" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;display:none">
                Posting
              </button>
            </div>
          </div>
        </td>
        <td  style="white-space: normal !important;padding-left:30px; "><%= ddata("PDIR_description") %></td>
          <td  style="white-space: normal !important;padding-left:30px; "><%= ddata("PDIR_Remaks") %></td>
        <td class="text-center">
          <%if ddata("PDIR_Condition") = "G" then %>
            <i class="bi bi-check-lg text-success"></i>
          <% else %>
            <span><i class="bi bi-x-lg text-danger"></i></span>
          <% end if %>
        </td>
        <td class="text-center">
          <%if ddata("PDIR_Condition") = "B" then %>
            <i class="bi bi-check-lg text-success"></i>
          <% else %>
            <span><i class="bi bi-x-lg text-danger"></i></span>
          <% end if %>
        </td>
        <td class="text-center">
          <%if ddata("PDIR_Condition") = "N" then %>
            <i class="bi bi-check-lg text-success"></i>
          <% else %>
            <span><i class="bi bi-x-lg text-danger"></i></span>
          <% end if %>
        </td>
      </tr>
      <% 
      response.flush
      ddata.movenext
      loop
      %>
    </tbody>
  </table>
<% 
  call footer()
%>