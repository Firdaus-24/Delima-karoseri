<!--#include file="../init.asp"-->
<% 
  ' cek hakakses 
    if Ucase(session("username")) <> "DAUSIT" AND Ucase(session("username")) <> Ucase("ADMINISTRATOR") then
      Response.Redirect(url&"login.asp")
    end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_M_WebLogin WHERE UserID = '"& id &"' AND userAktifYN = 'Y'"

  set data = data_cmd.execute
call header("Hak Akses") %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
<style>
  .accordion__container::-webkit-scrollbar{
    display: none;
  }
  /*=============== GOOGLE FONTS ===============*/
  @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap");
  /*=============== VARIABLES CSS ===============*/
  :root {
    /*========== Colors ==========*/
    --hue-color: 225;
    --first-color: hsl(var(--hue-color), 48%, 35%);
    --title-color: hsl(var(--hue-color), 48%, 22%);
    --text-color: hsl(var(--hue-color), 12%, 35%);
    --body-color: hsl(var(--hue-color), 49%, 98%);
    --container-color: #FFF;
    /*========== Font and typography ==========*/
    --body-font: 'Poppins', sans-serif;
    --normal-font-size: .938rem;
    --small-font-size: .813rem;
    --smaller-font-size: .75rem;
  }

  @media screen and (min-width: 968px) {
    :root {
      --normal-font-size: 1rem;
      --small-font-size: .875rem;
      --smaller-font-size: .813rem;
    }
  }

  /*=============== BASE ===============*/
  * {
    box-sizing: border-box;
    padding: 0;
    margin: 0;
  }

  body {
    font-family: var(--body-font);
    font-size: var(--normal-font-size);
    background-color: var(--body-color);
    color: var(--text-color);
  }

  /*=============== LAYOUT ===============*/
  .container {
    max-width: 968px;
    margin-left: 1rem;
    margin-right: 1rem;
  }

  /*=============== ACCORDION ===============*/
  .accordion {
    display: grid;
    /* align-content: center; */
    height: 100vh;
  }

  .accordion__container {
    overflow-x:auto;
    /* margin-top:8em; */
    display: grid;
    row-gap: .75rem;
    padding: 2rem 1rem;
    background-color: var(--container-color);
    border-radius: .5rem;
    box-shadow: 0 12px 32px rgba(51, 51, 51, 0.1);
  }

  .accordion__title {
    font-size: var(--small-font-size);
    color: var(--title-color);
    font-weight: 400;
    margin-top: .15rem;
    transition: .2s;
  }

  .accordion__header {
    display: flex;
    column-gap: .5rem;
    padding: 1.25rem 1.25rem 1.25rem 1rem;
    cursor: pointer;
  }

  .accordion__description {
    padding: 0 1.25rem 1.25rem 1rem;
    font-size: var(--smaller-font-size);
    list-style:none;
  }
  
  .accordion__description ul {
    margin-bottom:0;
  }
  .accordion__description ul li {
    list-style:none;
  }

  .accordion__icon {
    font-size: 1.5rem;
    height: max-content;
    color: var(--title-color);
    transition: .3s;
  }

  .accordion__item {
    box-shadow: 0 2px 6px rgba(38, 38, 38, 0.1);
    background-color: var(--container-color);
    border-radius: .25rem;
    position: relative;
    transition: all .25s ease;
  }

  .accordion__item::after {
    content: '';
    background-color: var(--first-color);
    width: 5px;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
    border-radius: .25rem 0 0 .25rem;
  }

  #accordion__itempertama{
    background-color: #fff7f0;
  }
  #accordion__itempertama::after{
    background-color: #ffc08a;
  }

  #accordion__itemkedua{
    background-color: #f0f0ff;
  }
  #accordion__itemkedua::after{
    background-color: #8a8aff;
  }

  #accordion__itemtiga{
    background-color: #fff0f3;
  }
  #accordion__itemtiga::after{
    background-color: #ff8aa1;
  }
  #accordion__itemempat{
    background-color: #f0faff;
  }
  #accordion__itemempat::after{
    background-color: #8ad8ff;
  }

  .accordion__content {
    overflow-y: auto;
    height: 0;
    transition: all .25s ease;
  }

  /*Rotate icon and add font weight to titles*/
  .accordion-open .accordion__icon {
    transform: rotate(45deg);
  }

  .accordion-open .accordion__title {
    font-weight: 600;
  }

  /*=============== MEDIA QUERIES ===============*/
  /* For medium devices */
  @media screen and (min-width: 576px) {
    .accordion__container {
      width: 550px;
      padding: 2.5rem;
      justify-self: center;
      border-radius: .75rem;
    }
    .accordion__header {
      padding: 1.5rem;
    }
    .accordion__title {
      padding-right: 3.5rem;
    }
    .accordion__description {
      padding: 0 4rem 1.25rem 3.5rem;
    }
  }

  /* For large devices */
  @media screen and (min-width: 968px) {
    .container {
      margin-left: auto;
      margin-right: auto;
    }
  }
</style>
<section class="accordion container">
  <div class="accordion__container">
    <!-- header -->
    <div class="row" style="position: static;">
      <div class="col-sm-4 text-start">
        <a href="index.asp" style="text-decoration:none;font-size:12px;"><i class="bi bi-chevron-double-left"></i>Kembali</a>
      </div>
      <div class="col-sm text-end">
        <h5>HAKAKSES ID <%= id %></h5>
      </div>
    </div>
    <!-- master -->
    <div class="accordion__item" id="accordion__itempertama">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Master</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- start barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M1" id="M1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1');" >
            <label for="M1">Barang</label>
          </li>
            <ul>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1A'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M1A" id="M1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1A');" >
              <label for="M1A">Tambah</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1B'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M1B" id="M1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1B');" >
              <label for="M1B">Update</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1C'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M1C" id="M1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1C');" >
              <label for="M1C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M1D" id="M1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1D');" >
              <label for="M1D">Export</label>
              </li>
          </ul>
          <!-- end barang -->
          <!-- jenis -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M3" id="M3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3');" >
            <label for="M3">Jenis</label>
          </li>
            <ul>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3A'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M3A" id="M3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3A');" >
              <label for="M3A">Tambah</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3B'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M3B" id="M3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3B');" >
              <label for="M3B">Update</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3C'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M3C" id="M3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3C');" >
              <label for="M3C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M3D" id="M3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3D');" >
              <label for="M3D">Export</label>
              </li>
            </ul>
          <!-- kategori -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M4" id="M4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4');" >
            <label for="M4">Kategori</label>
          </li>
            <ul>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4A'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M4A" id="M4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4A');" >
              <label for="M4A">Tambah</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4B'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M4B" id="M4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4B');" >
              <label for="M4B">Update</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4C'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M4C" id="M4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4C');" >
              <label for="M4C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M4D" id="M4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4D');" >
              <label for="M4D">Export</label>
              </li>
            </ul>
          <!-- satuan barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M6" id="M6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6');" >
            <label for="M6">Satuan Barang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M6A" id="M6A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6A');" >
                <label for="M6A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M6B" id="M6B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6B');" >
                <label for="M6B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M6C" id="M6C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6C');" >
                <label for="M6C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M6D" id="M6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6D');" >
                <label for="M6D">Export</label>
              </li>
            </ul>
          <!-- satuan panjang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M11'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M11" id="M11" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M11');" >
            <label for="M11">Satuan Panjang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M11A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M11A" id="M11A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M11A');" >
                <label for="M11A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M11B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M11B" id="M11B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M11B');" >
                <label for="M11B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M11C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M11C" id="M11C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M11C');" >
                <label for="M11C">Delete</label>
              </li>
            </ul>
          <!-- type barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M7" id="M7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7');" >
            <label for="M7">Type Barang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M7A" id="M7A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7A');" >
                <label for="M7A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M7B" id="M7B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7B');" >
                <label for="M7B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M7C" id="M7C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7C');" >
                <label for="M7C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M7D" id="M7D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7D');" >
                <label for="M7D">Export</label>
              </li>
            </ul>
          <!-- Rak -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M5" id="M5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5');" >
            <label for="M5">Rak</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M5A" id="M5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5A');" >
                <label for="M5A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M5B" id="M5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5B');" >
                <label for="M5B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M5C" id="M5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5C');" >
                <label for="M5C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M5D" id="M5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5D');" >
                <label for="M5D">Export</label>
              </li>
            </ul>
          <!-- Kebutuhan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M10'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M10" id="M10" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M10');" >
            <label for="M10">Kebutuhan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M10A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M10A" id="M10A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M10A');" >
                <label for="M10A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M10B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M10B" id="M10B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M10B');" >
                <label for="M10B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M10C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M10C" id="M10C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M10C');" >
                <label for="M10C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M10D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M10D" id="M10D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M10D');" >
                <label for="M10D">Export</label>
              </li>
            </ul>
          <!-- master beban biaya -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M12'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M12" id="M12" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M12');" >
            <label for="M12">Beban Biaya</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M12A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M12A" id="M12A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M12A');" >
                <label for="M12A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M12B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M12B" id="M12B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M12B');" >
                <label for="M12B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M12C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M12C" id="M12C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M12C');" >
                <label for="M12C">Delete</label>
              </li>
            </ul>
        </ul>

      </div>
    </div>
    <!-- customer & vendor -->
    <div class="accordion__item" id="accordion__itemkedua">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Customers & Vendors</h3>
      </header>

      <div class="accordion__content">
        <!-- start customer -->
        <ul class="accordion__description">
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M2" id="M2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2');" >
            <label for="M2">Customers</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M2A" id="M2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2A');" >
                <label for="M2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M2B" id="M2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2B');" >
                <label for="M2B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M2C" id="M2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2C');" >
                <label for="M2C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="M2D" id="M2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2D');" >
              <label for="M2D">Export</label>
              </li>
            </ul>
          <!-- vendor -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="M8" id="M8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8');" >
            <label for="M8">Vendors</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M8A" id="M8A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8A');" >
                <label for="M8A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M8B" id="M8B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8B');" >
                <label for="M8B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M8C" id="M8C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8C');" >
                <label for="M8C">Delete</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="M8D" id="M8D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8D');" >
                <label for="M8D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>
    <!-- inventory -->
    <div class="accordion__item" id="accordion__itemtiga">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Inventory</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- start req anggaran -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV1" id="INV1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV1');" >
            <label for="INV1">Request Anggaran</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV1A" id="INV1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV1A');" >
                <label for="INV1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV1B" id="INV1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV1B');" >
                <label for="INV1B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV1C" id="INV1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV1C');" >
                <label for="INV1C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV1D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="INV1D" id="INV1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV1D');" >
              <label for="INV1D">Export</label>
              </li>
            </ul>
          <!-- incomming -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV2" id="INV2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV2');" >
            <label for="INV2">Incomming</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV2A" id="INV2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV2A');" >
                <label for="INV2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV2B" id="INV2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV2B');" >
                <label for="INV2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV2C" id="INV2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV2C');" >
                <label for="INV2C">Delete</label>
              </li>
              <li>
              <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV2D" id="INV2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV2D');" >
                <label for="INV2D">Export</label>
              </li>
            </ul>
          <!-- klaim barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV3" id="INV3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3');" >
            <label for="INV3">Klaim Barang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV3A" id="INV3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3A');" >
                <label for="INV3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV3C" id="INV3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3C');" >
                <label for="INV3C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV3D" id="INV3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3D');" >
                <label for="INV3D">Export / Print</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV3E" id="INV3E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3E');" >
                <label for="INV3E">Aprrove</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV3F'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV3F" id="INV3F" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV3F');" >
                <label for="INV3F">Upload</label>
              </li>
            </ul>
          <!-- outgoing -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV4" id="INV4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV4');" >
            <label for="INV4">Outgoing</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV4A" id="INV4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV4A');" >
                <label for="INV4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV4B" id="INV4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV4B');" >
                <label for="INV4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV4C" id="INV4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV4C');" >
                <label for="INV4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV4D" id="INV4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV4D');" >
                <label for="INV4D">Export</label>
              </li>
            </ul>
          <!-- Permintaan kurang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV6" id="INV6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV6');" >
            <label for="INV6">PO Min</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV6D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV6D" id="INV6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV6D');" >
                <label for="INV6D">PO Min</label>
              </li>
            </ul>
          <!-- mutasi stok -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV7'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV7" id="INV7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV7');" >
            <label for="INV7">Mutasi Stok</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV7A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV7A" id="INV7A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV7A');" >
                <label for="INV7A">Proses</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV7D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV7D" id="INV7D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV7D');" >
                <label for="INV7D">Export</label>
              </li>
            </ul>
          <!-- stok barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV8'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV8" id="INV8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV8');" >
            <label for="INV8">Stok Barang</label>
          </li>

          <!-- revisi bom repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV9'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV9" id="INV9" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV9');" >
            <label for="INV9">Revisi B.O.M repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV9B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV9B" id="INV9B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV9B');" >
                <label for="INV9B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV9C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV9C" id="INV9C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV9C');" >
                <label for="INV9C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV9D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV9D" id="INV9D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV9D');" >
                <label for="INV9D">Export</label>
              </li>
            </ul>
          <!-- revisi bom project -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV10'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="INV10" id="INV10" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV10');" >
            <label for="INV10">Revisi B.O.M project</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV10B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV10B" id="INV10B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV10B');" >
                <label for="INV10B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV10C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV10C" id="INV10C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV10C');" >
                <label for="INV10C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'INV10D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="INV10D" id="INV10D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','INV10D');" >
                <label for="INV10D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>
    
    <!-- engeneering -->
    <div class="accordion__item" id="accordion__itemempat">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Engeneering</h3>
      </header>

      <div class="accordion__content"> 
        <ul class="accordion__description">
          <!-- Produksi -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG1" id="ENG1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1');" >
            <label for="ENG1">Produksi</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1A" id="ENG1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1A');" >
                <label for="ENG1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1B" id="ENG1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1B');" >
                <label for="ENG1B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1C" id="ENG1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1C');" >
                <label for="ENG1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1D" id="ENG1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1D');" >
                <label for="ENG1D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1E" id="ENG1E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1E');" >
                <label for="ENG1E">Approve</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG1F'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG1F" id="ENG1F" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG1F');" >
                <label for="ENG1F">Voucher</label>
              </li>
            </ul>
          <!-- hpp berjalan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG6" id="ENG6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG6');" >
            <label for="ENG6">HPP berjalan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG6D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG6D" id="ENG6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG6D');" >
                <label for="ENG6D">Export</label>
              </li>
              <li>
            </ul>
          <!-- Prediksi BOM -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG7'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG7" id="ENG7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG7');" >
            <label for="ENG7">Prediksi BOM</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG7D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG7D" id="ENG7D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG7D');" >
                <label for="ENG7D">Export</label>
              </li>
              <li>
            </ul>
          
          <!-- surat jalan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG8'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG8" id="ENG8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG8');" >
            <label for="ENG8">Surat jalan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG8A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG8A" id="ENG8A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG8A');" >
                <label for="ENG8A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG8B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG8B" id="ENG8B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG8B');" >
                <label for="ENG8B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG8C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG8C" id="ENG8C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG8C');" >
                <label for="ENG8C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG8D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG8D" id="ENG8D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG8D');" >
                <label for="ENG8D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>
    <!-- purchasing -->
    <div class="accordion__item" id="accordion__itempertama">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Purchasing</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- index purchase -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR1" id="PR1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR1');" >
            <label for="PR1">Dashboard</label>
          </li>
          <!-- Detail purchase -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR2" id="PR2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2');" >
            <label for="PR2">Pruchase Detail</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR2A" id="PR2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2A');" >
                <label for="PR2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR2B" id="PR2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2B');" >
                <label for="PR2B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR2C" id="PR2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2C');" >
                <label for="PR2C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR2D" id="PR2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2D');" >
                <label for="PR2D">Export</label>
              </li>
            </ul>
          <!-- update harga memo -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR3" id="PR3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR3');" >
            <label for="PR3">Update harga memo</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR3A" id="PR3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR3A');" >
                <label for="PR3A">Update</label>
              </li>
            </ul>
          <!-- Faktur terhutang/pembelian -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR4" id="PR4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4');" >
            <label for="PR4">Faktur Terhutang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR4A" id="PR4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4A');" >
                <label for="PR4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR4B" id="PR4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4B');" >
                <label for="PR4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR4C" id="PR4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4C');" >
                <label for="PR4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR4D" id="PR4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4D');" >
                <label for="PR4D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR4E" id="PR4E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4E');" >
                <label for="PR4E">Upload Document</label>
              </li>
            </ul>
          <!-- Return Barang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR5" id="PR5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5');" >
            <label for="PR5">Return Barang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR5A" id="PR5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5A');" >
                <label for="PR5A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR5B" id="PR5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5B');" >
                <label for="PR5B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR5C" id="PR5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5C');" >
                <label for="PR5C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR5D" id="PR5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5D');" >
                <label for="PR5D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR5E" id="PR5E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5E');" >
                <label for="PR5E">Upload Document</label>
              </li>
            </ul>
          <!-- Barang kurang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PR6" id="PR6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR6');" >
            <label for="PR6">Barang kurang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR6D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PR6D" id="PR6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR6D');" >
                <label for="PR6D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>

    <!-- General Ledger -->
    <div class="accordion__item" id="accordion__itemkedua">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">General Ledger</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- start kas masuk / keluar -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="GL1" id="GL1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL1');" >
            <label for="GL1">Kas Masuk / keluar</label>
          </li>
            <ul>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL1A'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL1A" id="GL1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL1A');" >
              <label for="GL1A">Tambah</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL1B'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL1B" id="GL1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL1B');" >
              <label for="GL1B">Update</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL1C'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL1C" id="GL1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL1C');" >
              <label for="GL1C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL1D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL1D" id="GL1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL1D');" >
              <label for="GL1D">Export</label>
              </li>
          </ul>
          <!-- end kas masuk / keluar -->
          <!-- kategori item -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="GL2" id="GL2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL2');" >
            <label for="GL2">Kategori Item</label>
          </li>
            <ul>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL2A'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL2A" id="GL2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL2A');" >
              <label for="GL2A">Tambah</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL2B'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL2B" id="GL2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL2B');" >
              <label for="GL2B">Update</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL2C'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL2C" id="GL2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL2C');" >
              <label for="GL2C">Delete</label>
              </li>
              <li>
              <%
              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL2D'"

              set app = data_cmd.execute
              %>
              <input class="form-check-input" type="checkbox" name="GL2D" id="GL2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL2D');" >
              <label for="GL2D">Export</label>
              </li>
            </ul>
          <!-- Kelompok -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="GL3" id="GL3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL3');" >
            <label for="GL3">Kelompok Perkiraan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL3A" id="GL3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL3A');" >
                <label for="GL3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL3B" id="GL3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL3B');" >
                <label for="GL3B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL3C" id="GL3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL3C');" >
                <label for="GL3C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL3D" id="GL3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL3D');" >
                <label for="GL3D">Export</label>
              </li>
            </ul>
          <!-- Kode perkiraan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="GL4" id="GL4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL4');" >
            <label for="GL4">Kode Perkiraan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL4A" id="GL4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL4A');" >
                <label for="GL4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL4B" id="GL4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL4B');" >
                <label for="GL4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL4C" id="GL4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL4C');" >
                <label for="GL4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'GL4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="GL4D" id="GL4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','GL4D');" >
                <label for="GL4D">Export</label>
              </li>
            </ul>
        </ul>

      </div>
    </div>

    <!-- Finance -->
    <div class="accordion__item" id="accordion__itemtiga">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Finance</h3>
      </header>

      <div class="accordion__content">
        <!-- start Approve memo -->
        <ul class="accordion__description">
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="FN1" id="FN1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN1');" >
            <label for="FN1">Approve Memo</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN1D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN1D" id="FN1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN1D');" >
                <label for="FN1D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN1E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN1E" id="FN1E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN1E');" >
                <label for="FN1E">Send Email</label>
              </li>
            </ul>
          <!-- Master Bank -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="FN2" id="FN2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN2');" >
            <label for="FN2">Master Bank</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN2A" id="FN2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN2A');" >
                <label for="FN2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN2B" id="FN2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN2B');" >
                <label for="FN2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN2C" id="FN2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN2C');" >
                <label for="FN2C">Delete</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'FN2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="FN2D" id="FN2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','FN2D');" >
                <label for="FN2D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>

    <!-- HR / GA -->
    <div class="accordion__item" id="accordion__itemempat">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">HR / GA</h3>
      </header>

      <div class="accordion__content">
        <!-- start Aset -->
        <ul class="accordion__description">
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR1" id="HR1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR1');" >
            <label for="HR1">Aset</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR1A" id="HR1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR1A');" >
                <label for="HR1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR1B" id="HR1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR1B');" >
                <label for="HR1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR1C" id="HR1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR1C');" >
                <label for="HR1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR1D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR1D" id="HR1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR1D');" >
                <label for="HR1D">Export</label>
              </li>
            </ul>
          <!-- Master Divisi -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR2" id="HR2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR2');" >
            <label for="HR2">Master Divisi</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR2A" id="HR2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR2A');" >
                <label for="HR2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR2B" id="HR2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR2B');" >
                <label for="HR2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR2C" id="HR2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR2C');" >
                <label for="HR2C">Delete</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR2D" id="HR2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR2D');" >
                <label for="HR2D">Export</label>
              </li>
            </ul>
          <!-- Master Departement -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR3" id="HR3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR3');" >
            <label for="HR3">Master Departement</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR3A" id="HR3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR3A');" >
                <label for="HR3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR3B" id="HR3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR3B');" >
                <label for="HR3B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR3C" id="HR3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR3C');" >
                <label for="HR3C">Delete</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR3D" id="HR3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR3D');" >
                <label for="HR3D">Export</label>
              </li>
            </ul>
          <!-- master cabang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR4" id="HR4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR4');" >
            <label for="HR4">Master Cabang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR4A" id="HR4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR4A');" >
                <label for="HR4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR4B" id="HR4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR4B');" >
                <label for="HR4B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR4C" id="HR4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR4C');" >
                <label for="HR4C">Delete</label>
              </li>
            </ul>
          <!-- master karyawan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR5'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR5" id="HR5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR5');" >
            <label for="HR5">Master Karyawan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR5A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR5A" id="HR5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR5A');" >
                <label for="HR5A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR5B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR5B" id="HR5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR5B');" >
                <label for="HR5B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR5C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR5C" id="HR5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR5C');" >
                <label for="HR5C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR5E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR5E" id="HR5E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR5E');" >
                <label for="HR5E">Detail</label>
              </li>
            </ul>
          <!-- master Jabatan -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR6" id="HR6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR6');" >
            <label for="HR6">Master Jabatan</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR6A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR6A" id="HR6A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR6A');" >
                <label for="HR6A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR6B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR6B" id="HR6B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR6B');" >
                <label for="HR6B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR6C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR6C" id="HR6C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR6C');" >
                <label for="HR6C">Delete</label>
              </li>
            </ul>
          <!-- master Jenjang -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR7'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR7" id="HR7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR7');" >
            <label for="HR7">Master Jenjang</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR7A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR7A" id="HR7A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR7A');" >
                <label for="HR7A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR7B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR7B" id="HR7B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR7B');" >
                <label for="HR7B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR7C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR7C" id="HR7C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR7C');" >
                <label for="HR7C">Delete</label>
              </li>
            </ul>
          <!-- master jenis usaha -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR8'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="HR8" id="HR8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR8');" >
            <label for="HR8">Master Jenis Usaha</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR8A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR8A" id="HR8A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR8A');" >
                <label for="HR8A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR8B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR8B" id="HR8B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR8B');" >
                <label for="HR8B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'HR8C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="HR8C" id="HR8C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','HR8C');" >
                <label for="HR8C">Delete</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>

    <!-- ppic / produksi-->
    <div class="accordion__item" id="accordion__itempertama">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">PPIC/ Prod dev</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
        <!-- penerimaan barang produksi -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP1" id="PP1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP1');" >
            <label for="PP1">Produksi Received</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP1A" id="PP1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP1A');" >
                <label for="PP1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP1B" id="PP1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP1B');" >
                <label for="PP1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP1C" id="PP1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP1C');" >
                <label for="PP1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP1D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP1D" id="PP1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP1D');" >
                <label for="PP1D">Export</label>
              </li>
            </ul>
            
          <!-- manpower -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP2" id="PP2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2');" >
            <label for="PP2">Man Power</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP2A" id="PP2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2A');" >
                <label for="PP2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP2B" id="PP2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2B');" >
                <label for="PP2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP2C" id="PP2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2C');" >
                <label for="PP2C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP2D" id="PP2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2D');" >
                <label for="PP2D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP2E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP2E" id="PP2E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP2E');" >
                <label for="PP2E">Work Time</label>
              </li>
            </ul>
          <!-- return material -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP3" id="PP3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP3');" >
            <label for="PP3">Return Material</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP3A" id="PP3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP3A');" >
                <label for="PP3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP3B" id="PP3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP3B');" >
                <label for="PP3B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP3C" id="PP3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP3C');" >
                <label for="PP3C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP3D" id="PP3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP3D');" >
                <label for="PP3D">Export</label>
              </li>
              
            </ul>

           <!-- Beban Produksi -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP4" id="PP4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP4');" >
            <label for="PP4">Beban Biaya proses</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP4A" id="PP4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP4A');" >
                <label for="PP4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP4B" id="PP4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP4B');" >
                <label for="PP4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP4C" id="PP4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP4C');" >
                <label for="PP4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP4D" id="PP4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP4D');" >
                <label for="PP4D">Export</label>
              </li>
              
            </ul>
          <!-- Produksi Repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP5'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP5" id="PP5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP5');" >
            <label for="PP5">Produksi Repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP5A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP5A" id="PP5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP5A');" >
                <label for="PP5A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP5B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP5B" id="PP5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP5B');" >
                <label for="PP5B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP5C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP5C" id="PP5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP5C');" >
                <label for="PP5C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP5D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP5D" id="PP5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP5D');" >
                <label for="PP5D">Export</label>
              </li>
              
            </ul>
          <!-- BOM Repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP6" id="PP6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6');" >
            <label for="PP6">B.O.M Repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP6A" id="PP6A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6A');" >
                <label for="PP6A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP6B" id="PP6B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6B');" >
                <label for="PP6B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP6C" id="PP6C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6C');" >
                <label for="PP6C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP6D" id="PP6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6D');" >
                <label for="PP6D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP6F'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP6F" id="PP6F" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP6F');" >
                <label for="PP6F">Approve</label>
              </li>
              
            </ul>
          <!-- anggaran bom Repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP7'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP7" id="PP7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP7');" >
            <label for="PP7">Anggaran B.O.M Repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP7A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP7A" id="PP7A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP7A');" >
                <label for="PP7A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP7B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP7B" id="PP7B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP7B');" >
                <label for="PP7B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP7C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP7C" id="PP7C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP7C');" >
                <label for="PP7C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP7D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP7D" id="PP7D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP7D');" >
                <label for="PP7D">Export</label>
              </li>
            </ul>
        
          <!-- anggaran bom project -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP8'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="PP8" id="PP8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP8');" >
            <label for="PP8">Anggaran B.O.M project</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP8A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP8A" id="PP8A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP8A');" >
                <label for="PP8A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP8B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP8B" id="PP8B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP8B');" >
                <label for="PP8B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PP8C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="PP8C" id="PP8C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PP8C');" >
                <label for="PP8C">Delete</label>
              </li>
        </ul>
      </div>
    </div>
    <!-- marketing -->
    <div class="accordion__item" id="accordion__itemkedua">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Marketing</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- sales order project -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MK1" id="MK1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK1');" >
            <label for="MK1">Sales Order New</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK1A" id="MK1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK1A');" >
                <label for="MK1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK1B" id="MK1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK1B');" >
                <label for="MK1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK1C" id="MK1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK1C');" >
                <label for="MK1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK1D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK1D" id="MK1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK1D');" >
                <label for="MK1D">Export</label>
              </li>
            </ul>
          
          <!-- sales order repairt -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MK2" id="MK2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK2');" >
            <label for="MK2">Sales Order repairt</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK2A" id="MK2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK2A');" >
                <label for="MK2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK2B" id="MK2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK2B');" >
                <label for="MK2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK2C" id="MK2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK2C');" >
                <label for="MK2C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK2D" id="MK2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK2D');" >
                <label for="MK2D">Export</label>
              </li>
            </ul>

          <!-- invoice customer brand baru -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MK3" id="MK3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK3');" >
            <label for="MK3">Invoice  New</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK3A" id="MK3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK3A');" >
                <label for="MK3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK3B" id="MK3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK3B');" >
                <label for="MK3B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK3C" id="MK3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK3C');" >
                <label for="MK3C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK3D" id="MK3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK3D');" >
                <label for="MK3D">Export</label>
              </li>
            </ul>


          <!-- invoice customer repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MK4" id="MK4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK4');" >
            <label for="MK4">Invoice  Repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK4A" id="MK4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK4A');" >
                <label for="MK4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK4B" id="MK4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK4B');" >
                <label for="MK4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK4C" id="MK4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK4C');" >
                <label for="MK4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MK4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MK4D" id="MK4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MK4D');" >
                <label for="MK4D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>

     <!-- QC/QA -->
    <div class="accordion__item" id="accordion__itemtiga">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">QC/QA</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- master item penunjang unit customer -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MQ1" id="MQ1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ1');" >
            <label for="MQ1">Item Penunjang Unit Customer</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ1A" id="MQ1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ1A');" >
                <label for="MQ1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ1B" id="MQ1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ1B');" >
                <label for="MQ1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ1C" id="MQ1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ1C');" >
                <label for="MQ1C">Delete</label>
              </li>
            </ul>
          <!-- serah terima unit -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MQ2" id="MQ2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ2');" >
            <label for="MQ2">Serah Terima Unit Customer</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ2A" id="MQ2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ2A');" >
                <label for="MQ2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ2B" id="MQ2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ2B');" >
                <label for="MQ2B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ2C" id="MQ2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ2C');" >
                <label for="MQ2C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ2D" id="MQ2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ2D');" >
                <label for="MQ2D">Export</label>
              </li>
            </ul>
          
          <!-- data PDI -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MQ3" id="MQ3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ3');" >
            <label for="MQ3">Pre delivery inspection</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ3A" id="MQ3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ3A');" >
                <label for="MQ3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ3B" id="MQ3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ3B');" >
                <label for="MQ3B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ3C" id="MQ3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ3C');" >
                <label for="MQ3C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ3D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ3D" id="MQ3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ3D');" >
                <label for="MQ3D">Export</label>
              </li>
            </ul>
          <!-- incomming unit repair -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MQ4" id="MQ4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4');" >
            <label for="MQ4">Incomming unit repair</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4A" id="MQ4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4A');" >
                <label for="MQ4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4B" id="MQ4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4B');" >
                <label for="MQ4B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4C" id="MQ4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4C');" >
                <label for="MQ4C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4D" id="MQ4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4D');" >
                <label for="MQ4D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4E" id="MQ4E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4E');" >
                <label for="MQ4E">Upload Document</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MQ4F'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MQ4F" id="MQ4F" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MQ4F');" >
                <label for="MQ4F">Send Email</label>
              </li>
            </ul>
        </ul>
        
      </div>
    </div>

    <!--Model-->
    <div class="accordion__item" id="accordion__itemempat">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">Model</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- Master Model -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MDL1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="MDL1" id="MDL1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MDL1');" >
            <label for="MDL1">Master Model</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MDL1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MDL1A" id="MDL1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MDL1A');" >
                <label for="MDL1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MDL1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MDL1B" id="MDL1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MDL1B');" >
                <label for="MDL1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MDL1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MDL1C" id="MDL1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MDL1C');" >
                <label for="MDL1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'MDL1D'"   

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="MDL1D" id="MDL1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','MDL1D');" >
                <label for="MDL1D">Export</label>
              </li>
            </ul>
            <!-- master bom -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG2'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG2" id="ENG2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG2');" >
            <label for="ENG2">Master BOM</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG2A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG2A" id="ENG2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG2A');" >
                <label for="ENG2A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG2B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG2B" id="ENG2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG2B');" >
                <label for="ENG2B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG2C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG2C" id="ENG2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG2C');" >
                <label for="ENG2C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG2D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG2D" id="ENG2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG2D');" >
                <label for="ENG2D">Export</label>
              </li>
            </ul>
          <!-- master class -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG3'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG3" id="ENG3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG3');" >
            <label for="ENG3">Master Class</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG3A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG3A" id="ENG3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG3A');" >
                <label for="ENG3A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG3B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG3B" id="ENG3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG3B');" >
                <label for="ENG3B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG3C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG3C" id="ENG3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG3C');" >
                <label for="ENG3C">Delete</label>
              </li>
            </ul>
          <!-- master brand -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG4'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG4" id="ENG4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG4');" >
            <label for="ENG4">Master Brand</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG4A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG4A" id="ENG4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG4A');" >
                <label for="ENG4A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG4B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG4B" id="ENG4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG4B');" >
                <label for="ENG4B">Update</label>
                </li>
                <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG4C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG4C" id="ENG4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG4C');" >
                <label for="ENG4C">Delete</label>
              </li>
            </ul>
          <!-- master sasis -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="ENG5" id="ENG5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5');" >
            <label for="ENG5">Master Sasis</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG5A" id="ENG5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5A');" >
                <label for="ENG5A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG5B" id="ENG5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5B');" >
                <label for="ENG5B">Update</label>
                </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG5C" id="ENG5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5C');" >
                <label for="ENG5C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5D'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG5D" id="ENG5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5D');" >
                <label for="ENG5D">Export</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'ENG5E'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="ENG5E" id="ENG5E" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','ENG5E');" >
                <label for="ENG5E">Upload Drawing & SKRB</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>
    <!--DJTF-->
    <div class="accordion__item" id="accordion__itempertama">
      <header class="accordion__header">
        <i class='bx bx-plus accordion__icon'></i>
        <h3 class="accordion__title">DJTF</h3>
      </header>

      <div class="accordion__content">
        <ul class="accordion__description">
          <!-- Master alat & facility -->
          <li>
            <%
            data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'DJTF1'"

            set app = data_cmd.execute
            %>
            <input class="form-check-input" type="checkbox" name="DJTF1" id="DJTF1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','DJTF1');" >
            <label for="DJTF1">Master Alat & Facility</label>
          </li>
            <ul>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'DJTF1A'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="DJTF1A" id="DJTF1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','DJTF1A');" >
                <label for="DJTF1A">Tambah</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'DJTF1B'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="DJTF1B" id="DJTF1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','DJTF1B');" >
                <label for="DJTF1B">Update</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'DJTF1C'"

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="DJTF1C" id="DJTF1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','DJTF1C');" >
                <label for="DJTF1C">Delete</label>
              </li>
              <li>
                <%
                data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'DJTF1D'"   

                set app = data_cmd.execute
                %>
                <input class="form-check-input" type="checkbox" name="DJTF1D" id="DJTF1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','DJTF1D');" >
                <label for="DJTF1D">Export</label>
              </li>
            </ul>
        </ul>
      </div>
    </div>
  </div>
</section>
<script>
  /*=============== ACCORDION ===============*/
  const accordionItems = document.querySelectorAll('.accordion__item')

  // 1. Selecionar cada item
  accordionItems.forEach((item) =>{
    const accordionHeader = item.querySelector('.accordion__header')

    // 2. Seleccionar cada click del header
    accordionHeader.addEventListener('click', () =>{
    // 7. Crear la variable
    const openItem = document.querySelector('.accordion-open')

    // 5. Llamar a la funcion toggle item
    toggleItem(item)

    // 8. Validar si existe la clase
      if(openItem && openItem!== item){
        toggleItem(openItem)
      }
    })
  })

  // 3. Crear una funcion tipo constante
  const toggleItem = (item) =>{
  // 3.1 Crear la variable
  const accordionContent = item.querySelector('.accordion__content')

    // 6. Si existe otro elemento que contenga la clase accorion-open que remueva su clase
    if(item.classList.contains('accordion-open')){
      accordionContent.removeAttribute('style')
      item.classList.remove('accordion-open')
    }else{
      // 4. Agregar el height maximo del content
      accordionContent.style.height = '180px'
      item.classList.add('accordion-open')
    }
  }

  function updateRights(u,s,p){   
    let user = u
    let serverID = s
    let app = p

    $.ajax({
      method: "post",
      url: "getApps.asp",
      data: { user, serverID, app }}).done(function(ms){console.log(ms);
    })
  }
</script>
<% call footer() %>
