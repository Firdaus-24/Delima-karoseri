<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_pdirepair.asp"-->
<% 
  if session("MQ5A") = false And session("MQ5B") = false then
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

  set fs = Server.CreateObject("Scripting.FileSystemObject")
  if not fs.FolderExists(pathDoc & data("PDIR_ID")& "\") then
    fs.CreateFolder (pathDoc & data("PDIR_ID")& "\")   
  end if

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
        <input type="hidden" id="idpdirepairrevisi" name="idpdirepairrevisi" class="form-control" value="<%= data("PDIR_id") %>" autocomplete="off">
        <input type="text" id="pdirepairref" name="pdirepairref" class="form-control" value="<%= data("PDIR_Revisi") %>" autocomplete="off">
        <%if session("MQ5B") = true then%>
        <span class="input-group-text p-0 m-0" id="basic-addon2"><button type="button" style="border:none;width:75px;" onclick="updateRevisiPdi()">Update</button></span>
        <%end if%>
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
      <%if session("MQ5A") = true then%>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDetailPdi" onclick="PdiRepairAdd()">Rincian</button>
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
            <th scope="col" rowspan="2" class="text-center">Aksi</th>
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
            <td class="text-center beforePdiRepairImg">
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
            <%if session("MQ5E") = true then%>
              <form action="setdetailimg.asp?id=<%= ddata("PDIR_ID") %>&pathidh=<%=data("PDIR_ID")%>" method="post" enctype="multipart/form-data">
                <div class="position-relative text-center" style="heigth:5rem">
                <% if ddata("PDIR_Img") = "" then%>
                  <input type="file" name="dimgpdirepaird" accept="image/*;capture=camera" id="dimgpdirepaird<%=ddata("PDIR_ID")%>" style="position:absolute;opacity:0;" onchange="uploadDetailpdirepair(this.value, 'dimgpdirepaird<%=ddata("PDIR_ID")%>', 'btnUploadDetailpdirepair<%=ddata("PDIR_ID")%>', 'btnPostingDetailpdirepair<%=ddata("PDIR_ID")%>')">
                  <!-- button upload -->
                  <button type="button" class="btn btn-outline-warning btnUploadDetailpdirepair<%=ddata("PDIR_ID")%>" style="--bs-btn-font-size: .75rem;cursor:pointer;">
                    Upload
                  </button>
                <%else%>
                  <div class="text-center">
                    <img src="<%= getpathdoc %>/<%= data("PDIR_ID") %>/<%= ddata("PDIR_Img") %>.jpg" id="imgDetailpdirepair" width="80" height="100" >
                    <div class="position-absolute top-50 start-50 translate-middle">
                      <input type="file" name="dimgpdirepaird" accept="image/*;capture=camera" id="dimgpdirepaird<%=ddata("PDIR_ID")%>" style="position:absolute;opacity:0;" onchange="uploadDetailpdirepair(this.value, 'dimgpdirepaird<%=ddata("PDIR_ID")%>', 'btnUploadDetailpdirepair<%=ddata("PDIR_ID")%>', 'btnPostingDetailpdirepair<%=ddata("PDIR_ID")%>')">
                      <!-- button upload -->
                      <button type="button" class="btn btn-outline-light btnUploadDetailpdirepair<%=ddata("PDIR_ID")%>" style="--bs-btn-font-size: .75rem;">
                        Upload
                      </button>
                    </div>
                  </div>
                <%end if%>
                
                  <div class="position-absolute top-50 start-50 translate-middle">
                    <button type="submit" class="btn btn-light btnPostingDetailpdirepair<%=ddata("PDIR_ID")%>" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;display:none">
                      Posting
                    </button>
                  </div>
                </div>
              </form>
            <%else%>
              <% if ddata("PDIR_Img") <> "" then%>
              <img src="<%= getpathdoc %>/<%= data("PDIR_ID") %>/<%= ddata("PDIR_Img") %>.jpg" id="imgDetailpdirepair" width="80" height="100" >
              <% end if%>
            <% end if%>


            </td>
            <td  style="white-space: normal !important;padding-left:30px; "><%= ddata("PDIR_description") %></td>
            <td  style="white-space: normal !important;padding-left:30px; "><%= ddata("PDIR_Remaks") %></td>
            <td class="text-center">
              <%if ddata("PDIR_Condition") = "G" then %>
                <i class="bi bi-check-lg text-success" style="cursor:pointer"></i>
              <% else %>
                <span onclick="ckPdiRepairDesc('<%=ddata("PDIR_id")%>', 'G')"><i class="bi bi-x-lg text-danger" style="cursor:pointer"></i></span>
              <% end if %>
            </td>
            <td class="text-center">
              <%if ddata("PDIR_Condition") = "B" then %>
                <i class="bi bi-check-lg text-success" style="cursor:pointer"></i>
              <% else %>
                <span onclick="ckPdiRepairDesc('<%=ddata("PDIR_id")%>', 'B')" style="cursor:pointer"><i class="bi bi-x-lg text-danger"></i></span>
              <% end if %>
            </td>
            <td class="text-center">
              <%if ddata("PDIR_Condition") = "N" then %>
                <i class="bi bi-check-lg text-success" style="cursor:pointer"></i>
              <% else %>
                <span onclick="ckPdiRepairDesc('<%=ddata("PDIR_id")%>', 'N')"><i class="bi bi-x-lg text-danger" style="cursor:pointer"></i></span>
              <% end if %>
            </td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <%if session("MQ5C") = true then%>
                <a href="aktifd.asp?id=<%= ddata("PDIR_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'hapus detail PDI Repair')">Delete</a>
                <%end if%>
                <%if session("MQ5B") = true then%>
                <a href="#" class="btn badge text-bg-warning" data-bs-toggle="modal" data-bs-target="#modalDetailPdi" onclick="PdiRepairUpdate('<%=ddata("PDIR_ID")%>','<%=ddata("PDIR_IRDIRHID")%>','<%=ddata("PDIR_Description")%>', '<%=ddata("PDIR_condition")%>', '<%=getpathdoc& dird("IRH_ID") &"/"&ddata("PDIR_IRDIRHID")%>','<%=getpathdoc&noPhoto%>','<%=ddata("PDIR_Remaks")%>')">Update</a>
                <%end if%>
              </div>
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

<!-- Modal -->
<div class="modal fade" id="modalDetailPdi" tabindex="-1" aria-labelledby="modalDetailPdiLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalDetailPdiLabel">Detail PDI</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="pdird_add.asp?id=<%= data("PDIR_ID") %>" method="post" id="formPdiRepair">
      <input type="hidden" name="id" value="<%= data("PDIR_ID") %>">
      <input type="hidden" name="idpdirdrepair" id="idpdirdrepair">
      <div class="modal-body">
        <div class='row mb-3'>
          <label for="irdirhid" class="col-sm-3 col-form-label">No.Kerusakan</label>
          <div class="col-sm-9">
            <select class="form-select" name="irdirhid" id="irdirhid" onchange="getImgIrdIrhID(`<%=getpathdoc & data("PDIR_IRHID")%>/`,`${this.value}`)">
              <option value="">Pilih</option>
              <%do while not dird.eof%>
              <option value="<%=dird("IRD_IRHID")%>"><%= right(dird("IRD_IRHID"),2)%></option>
              <%
              Response.flush
              dird.movenext
              loop
              %>
            </select>
          </div>
        </div>
        <div class='pdirIrdIrhid'>
          <div class='row mb-3 '>
            <label for="irdid" class="col-sm-3 col-form-label">No.Kerusakan</label>
            <div class='col-sm-9 getImgIrdIrhid'>
              <div class='imgpdir skeleton'></div>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label for="desc" class="col-sm-3 col-form-label">Description</label>
          <div class="col-sm-9 ">
            <textarea class="form-control" placeholder="Leave a comment here" id="pdiRepairdesc" name="desc" maxlength="255" style="height: 80px" required></textarea>
          </div>
        </div>
        <div class="mb-3 row">
          <label for="remaks" class="col-sm-3 col-form-label">Remaks</label>
          <div class="col-sm-9 ">
            <textarea class="form-control" placeholder="Leave a comment here" id="pdiRepairremaks" name="remaks" maxlength="255" style="height: 80px"></textarea>
          </div>
        </div>
        <div class="mb-3 row">
          <label for="desc" class="col-sm-3 col-form-label">Condition</label>
          <div class="col-sm-9">
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="conditionPdiRepair" id="good" value="G" required>
              <label class="form-check-label" for="good">Good</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="conditionPdiRepair" id="bad" value="B">
              <label class="form-check-label" for="bad">Bad</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="conditionPdiRepair" id="not" value="N">
              <label class="form-check-label" for="not">Not Avallable</label>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
    </form>
  </div>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    if trim(Request.Form("idpdirdrepair")) = "" then
      call detail()
    else
      call updatedetail()
    end if
  end if
  call footer()
%>
<script>
  const updateRevisiPdi = () => {
    let revisi = $("#pdirepairref").val()
    let id = $("#idpdirepairrevisi").val()
    $.ajax({
    type: "post",
    url: "revisi_u.asp",
    data: {id, revisi},
    success: (data) => {
      if (data) {
        swal({
          title: data,
          text: '',
          icon: "success",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
        }).then((isConfirm) => {
          window.location.reload();
        });
        }
      },
    });
  }
</script>