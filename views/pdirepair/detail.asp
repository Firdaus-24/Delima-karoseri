<!--#include file="../../init.asp"-->
<% 
  ' if session("MQ3A") = false then
  '   Response.Redirect("index.asp")
  ' end if

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

  call header("Detail PDI")
%>
<style>
  .pdirIrdIrhid{
    display:none;
  }
  .getImgIrdIrhid{
    height:8rem;
    margin-botton:10px;
    
    overflow:hidden;
  }
  .getImgIrdIrhid .imgpdir{
    height:8rem;
    width:80px;
    padding:2px;
    border:1px solid black;
  }
  .skeleton{
    opacity:.7;
    animation: skeleton-loading 1s linear infinite alternate;
  }
  @keyframes skeleton-loading{
    0%{    
      background-color:hsl(200, 20%, 70%)
    }
    100%{
      background-color:hsl(200, 20%, 95%)
    }
  }
</style>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL PRE DELIVERY INSPECTION  REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= LEFT(data("PDIR_ID"),4) &"-"& MID(data("PDIR_ID"),5,3) &"/"& "DKI-" & LEFT(UCase(data("DivNama")),3) & "/" & data("PDIR_DepID") & "/" & MID(data("PDIR_ID"),8,4) & "/" & right("00" + cstr(data("PDIR_Revisi")),2)  & "/" &  right(data("PDIR_ID"),3) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangPdi" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("PDIR_Date")) %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">Divisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("divNama") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">Departement</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("depNama") %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="pdiprod" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= left(data("PDIR_pdrid"),3) %>-<%= mid(data("PDIR_pdrid"),4,2) %>/<%= right(data("PDIR_pdrid"),3)  %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label  class="col-form-label">Brand</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="branddpdirepair" name="brand" class="form-control" value="<%= data("brandname")  %>" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label  class="col-form-label">Type</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="typedpdirepair" name="type" class="form-control" value="<%= data("PDIR_Type")  %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label  class="col-form-label">No.Polisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nopoldpdirepair" name="nopol" class="form-control" value="<%= data("PDIR_nopol")  %>" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="pdirepairref" class="col-form-label">Refisi Ke -</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group">
        <input type="text" id="pdirepairref" name="pdirepairref" class="form-control" value="<%= data("PDIR_Revisi") %>" autocomplete="off" readonly>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("PDIR_Keterangan") %>"  autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center d-flex justify-content-between mb-3">
      <%if session("MQ5D") = true then%>
      <button type="button" class="btn btn-secondary" onclick="window.open('export-pdirepair.asp?id=<%=id%>')">Export</button>
      <%end if%>
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-12">
      <table class="table table-bordered border-dark table-hover tblpdirepaird" width="100">
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
                <img src="<%= getpathdoc %>noPhoto.jpg" width="80" height="100" >
              <%else%>
                <img src="<%= getpathdoc %><%= dird("IRH_ID") %>/<%= ddata("PDIR_IRDIRHID") %>.jpg" width="80" height="100" >
              <%end if%>
            </td>
            <td style="width:80px;heigth:100px;">
              <div class="position-relative text-center" style="heigth:5rem">
              <% if ddata("PDIR_Img") = "" then%>
                <img src="<%= getpathdoc %>noPhoto.jpg" width="80" height="100" >
              <%else%>
                <div class="text-center">
                  <img src="<%= getpathdoc %>/<%= data("PDIR_ID") %>/<%= ddata("PDIR_Img") %>.jpg" id="imgDetailpdirepair" width="80" height="100" >
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
    </div>
  </div>
</div>  
<% 
  call footer()
%>