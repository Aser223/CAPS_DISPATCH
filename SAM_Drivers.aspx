<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAM_Drivers.aspx.cs" Inherits="Capstone.SAM_Drivers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>PBC - Dashboard</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
  <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
  <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
      <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

  <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">
    <%--#052507--%>
    <style>
    /* Add this style to change the modal header and footer background color */
    .modal-header,
    .modal-footer {
        background-color: #041d06;
        border-top-color: #052507;
        border-bottom-color: #052507;

    }
    .modal-content .modal-header .btn-close {
        color: aquamarine !important;
    }
    /* Add this style to change the modal title text color */
    .modal-title {
        color: mediumaquamarine; /* You can adjust the text color as needed */
/*        text-align: center !important;
*/    }
 
    /* Add this style to change the modal body background color */
    .modal-body {
        background-color: #052507; /* You can adjust the background color as needed */
/*        border-color: aquamarine;
*/    }
    .modal-content .modal-header button.custom-close-button {
        color: aquamarine !important;
        background-color: aquamarine !important; /* Background color */
        border: none; /* Remove the default border */
        padding: 0; /* Remove padding */
    }
    /* Add this style to change the color of the close button */
    .btn-close {
        color: #ffffff; /* You can adjust the text color as needed */
    }
    .modal-content {
        border: 2.5px solid aquamarine; /* You can adjust the border color as needed */
        border-radius: 10px; /* You can adjust the border-radius as needed */
    }
    .modal-header .btn-close {
        color: aquamarine;
        background-color: aquamarine;

    }
    .gridview-container .columns_label {
    white-space: normal;
    word-wrap: break-word;
    }
</style>
    <style type="text/css">
    .customGridView tr {
        border-bottom: 1px solid #0a4d1d;
    }
</style>

    <style>
    .arrow-button {
        background-color: transparent;
/*        color: orangered;
*/        border: none;
        cursor: pointer;
        font-size: 16px; /* Adjust the font size as needed */
    }

    .arrow-button::before {
        content: "\2191"; /* Unicode character for the arrow-up */
    }
</style>
    <style>
    .edit-icon {
        filter: invert(68%) sepia(54%) saturate(2180%) hue-rotate(161deg) brightness(91%) contrast(87%);
    }
</style>
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script type="text/javascript">
    function search() {
        var searchText = document.getElementById('<%= txtSearch.ClientID %>').value.toUpperCase();
        var grid = document.getElementById('<%= gridViewAdmin.ClientID %>');

        for (var i = 1; i < grid.rows.length; i++) {
            var row = grid.rows[i];
            var id = row.cells[0].innerHTML.toUpperCase();
            var firstname = row.cells[1].innerHTML.toUpperCase();
            var mi = row.cells[2].innerHTML.toUpperCase();
            var lastname = row.cells[3].innerHTML.toUpperCase();
            var username = row.cells[4].innerHTML.toUpperCase();
            var contact = row.cells[5].innerHTML.toUpperCase();
            var email = row.cells[6].innerHTML.toUpperCase();
            var created_at = row.cells[7].innerHTML.toUpperCase();
            var updated_at = row.cells[8].innerHTML.toUpperCase();
            var status = row.cells[9].innerHTML.toUpperCase();
            //var date = row.cells[9].innerHTML.toUpperCase();
            //var stock_level = row.cells[10].innerHTML.toUpperCase();
            if (id.indexOf(searchText) > -1 || firstname.indexOf(searchText) > -1 || mi.indexOf(searchText) > -1 ||
                lastname.indexOf(searchText) > -1 || username.indexOf(searchText) > -1 ||
                contact.indexOf(searchText) > -1 || email.indexOf(searchText) > -1 ||
                created_at.indexOf(searchText) > -1 || updated_at.indexOf(searchText) > -1 ||
                status.indexOf(searchText) > -1) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        }
    }


</script>

</head>
    <form id="form2" runat="server">
    <div>
<body style="background-color: #041d06 " >

  <!-- ======= Header ======= -->    <%--#9ee2a0, #9ee2a0, #9ee2a0--%>
<header style="background-color: black; height: 80px" id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="WAREHOUSE_ADD_ITEM.aspx" class="logo d-flex align-items-center">
        <img style="border-radius: 1px" src="Pictures/logo2.png" alt=""/>
        <span style="color: aqua; font-weight: 900; font-family: 'Agency FB'"  class="d-none d-lg-block">PBC</span>
      </a>
      <i style="color:aqua" class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->
    <nav class="header-nav ms-auto">
      <ul class="d-flex align-items-center">
        <li class="nav-item dropdown">
          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow notifications">
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

          </ul><!-- End Notification Dropdown Items -->

        </li><!-- End Notification Nav -->

        <li class="nav-item dropdown pe-3">

          <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown" style="color:aqua">
              <asp:ImageMap ID="profile_image" runat="server" alt="Profile" class="rounded-circle"></asp:ImageMap>
                <span style="color:aqua" class="d-none d-md-block dropdown-toggle ps-2">
                    <asp:Label ID="Label2" runat="server" Text=""></asp:Label></span>
          </a><!-- End Profile Image Icon -->

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6>
                  <asp:Label ID="Label1" runat="server" Text=""></asp:Label></h6>
              <span>
                  <asp:Label ID="Label3" runat="server" Text="Administrator"></asp:Label></span>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="Admin_Change_Pass.aspx">
                <i class="bi bi-gear"></i>
                <span>Account Settings</span>
              </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

              <li>
                  <a class="dropdown-item d-flex align-items-center" href="#" onclick="confirmLogout()">
                      <i class="bi bi-box-arrow-right"></i>
                      <span>Sign Out</span>
                  </a>
              </li>
              <script>
                  function confirmLogout() {
                      var isConfirmed = confirm("Are you sure you want to log out?");
                      if (isConfirmed) {
                          // If confirmed, redirect to the logout page
                          window.location.href = "LOGIN.aspx";
                      } else {
                          // If not confirmed, do nothing or handle as needed
                      }
                  }
              </script>
          </ul><!-- End Profile Dropdown Items -->
        </li><!-- End Profile Nav -->

      </ul>
    </nav><!-- End Icons Navigation -->

  </header><!-- End Header -->

  <!-- ======= Sidebar ======= --> <%--#052507--%>
  <aside style="padding-top: 50px" id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

      <li class="nav-item">
        <a class="nav-link collapsed" href="SAM_Dashboard.aspx">
          <i class="bi bi-grid"></i>
          <span>Dashboard</span>
        </a>

      </li><!-- End Employee Nav -->


        <li class="nav-item">
        <a class="nav-link" data-bs-target="#forms-nav" data-bs-toggle="collapse" href="#">
<%--          <i class="bi bi-people" style="color:#52996F"></i><span style="color:#52996F">Manage Account</span><i class="bi bi-chevron-down ms-auto" style="color:aquamarine"></i>--%>
                  <i class="bi bi-people"></i><span>Manage Account</span><i class="bi bi-chevron-down ms-auto"></i>

        </a>
        <ul id="forms-nav" class="nav-content collapse show" data-bs-parent="#sidebar-nav">
            <li>
                <a href="SAM_AccountMan.aspx">
                    <i class="bi bi-circle"></i><span>Account Manager</span>
                </a>
            </li>
            <li>
                <a href="SAM_Dispatcher.aspx">
                    <i class="bi bi-circle"></i><span>Dispatcher</span>
                </a>
            </li>

            <li>
                <a href="SAM_Drivers.aspx" class="active">
                    <i class="bi bi-circle"></i><span>Drivers</span>
                </a>
            </li>

            <li>
                <a href="WAREHOUSE_ADD_CATEGORY.aspx">
                    <i class="bi bi-circle"></i><span>Billing Officer</span>
                </a>
            </li>

            <li>
                <a href="Admin_Manage_Customer.aspx">
                    <i class="bi bi-circle"></i><span>Non-Contractual</span>
                </a>
            </li>

            <li>
                <a href="Admin_Manage_Customer.aspx">
                    <i class="bi bi-circle"></i><span>Contractual</span>
                </a>
            </li>
        </ul>
        </li>

        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#tables-nav" data-bs-toggle="collapse" href="#">
                <i class="ri-bill-line"></i><span>Reports</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="tables-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="Admin_Billing_GenerateBill.aspx">
                        <i class="bi bi-circle"></i><span>Generate Bill</span>
                    </a>
                </li>

                <li>
                    <a href="Admin_Billing_Controls.aspx">
                        <i class="bi bi-circle"></i><span>Controls</span>
                    </a>
                </li>
            </ul>
        </li>

       <%-- <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#receipt-nav" data-bs-toggle="collapse" href="#">
                <i class="ri-secure-payment-line"></i><span>Payment</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="receipt-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="Admin_Payment_ViewPays.aspx">
                        <i class="bi bi-circle"></i><span>View Payments</span>
                    </a>
                </li>
            </ul>
        </li>--%>


      <%--  <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#components-nav" data-bs-toggle="collapse" href="#">
          <i class="ri-bar-chart-2-line"></i><span>Reports</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="components-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
          <li>
            <a href="WAREHOUSE_VIEW_REQUESTS.aspx">
              <i class="bi bi-circle"></i><span>Requests</span>
            </a>
          </li>
      </li>--%><!-- End Transaction Nav -->
    </ul>
  </aside><!-- End Sidebar-->

  <main id="main" class="main">

    <div class="pagetitle">
      <h1 style="padding-top: 20px; color:chartreuse">Manage Accounts</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="SAM_Dashboard.aspx">Dashboard</a></li>
          <li class="breadcrumb-item"><a href="admin_manage_account.aspx">Manage Accounts   </a></li>
          <li class="breadcrumb-item">Dispatcher</li>

        </ol>
      </nav>
    </div><!-- End Page Title -->

    <section class="section dashboard">
      <div class="row">

        <!-- Left side columns -->
        <div class="col-lg-8">
          <div class="row">


          </div>
        </div><!-- End Left side columns -->

          <!-- Right side columns -->
          <div class="col-lg-4">
          </div>
          <!-- End Right side columns -->

      </div>
    </section>
      <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                      <h1 class="modal-title fs-5" id="exampleModalLabel">Add Account Manager</h1>
                      <button type="button" class="btn-close custom-close-button" data-bs-dismiss="modal" aria-label="Close" style="color: aquamarine !important"></button>
                  </div>
                  <div class="modal-body">
                      <div class="mb-3">
                          <asp:Label ID="Label13" runat="server" Text="Firstname" for="inputText" style="color: chartreuse; margin-top: 10px"></asp:Label>
                          <asp:TextBox ID="emp_firstname" runat="server" class="form-control" style="margin-top: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label4" runat="server" Text="M.I" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_mi" runat="server" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label5" runat="server" Text="Lastname" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_lastname" runat="server" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label6" runat="server" Text="Username" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_username" runat="server" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label7" runat="server" Text="Password" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_pass" runat="server" type="password" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label8" runat="server" Text="Contact No." for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_contact" runat="server" min="1" type="Number" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label9" runat="server" Text="Address" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_address" runat="server" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label10" runat="server" Text="Email" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_email" runat="server" class="form-control" style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label12" runat="server" Text="Picture" for="inputText" style="color: chartreuse"></asp:Label>
                          <asp:FileUpload ID="formFile" class="form-control" runat="server" />
                      </div>
                  </div>
                  <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
<%--                      <asp:Button class="btn btn-primary" ID="submitBtn" runat="server" Text="Submit Form" OnClick="submitBtn_Click" />--%>
                          <asp:Button class="btn btn-primary" ID="submitBtn" runat="server" Text="Submit Form" />

                  </div>
              </div>
          </div>
      </div>
      <section style="background-color: #052507; padding: 25px; border-radius: 8px; box-shadow: 0 0 5px rgba(0, 0, 0, .2)">

          <div>
              <asp:ImageMap ID="ImageMap1" runat="server" ImageUrl="Pictures//box_format.png" Style="float: right; margin-right: 0px; margin-top: 0px; width: 50px"></asp:ImageMap>
          </div>
          <div style="margin-top: 50px; margin-bottom: 30px">
              <asp:TextBox Style="border-radius: 10px; padding-left: 10px; padding: 2px; margin-top: 7px; border-color: aquamarine; border-width: 3px" placeholder="Search" ID="txtSearch" runat="server" oninput="search();" AutoPostBack="false"></asp:TextBox>
              <button type="button" class="btn btn-primary" style="margin: 10px; float: right; background-color: #052507; border-color: aquamarine; border-radius: 8px; border-width: 3px" data-bs-toggle="modal" data-bs-target="#exampleModal">
                  Add Dispatcher +
              </button>
          </div>

<div class="gridview-container">
    <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed" ID="gridViewAdmin" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True"
        DataKeyNames="_id" AllowPaging="False" CellPadding="20" Font-Size="10px" ForeColor="White" GridLines="None">
    <AlternatingRowStyle BackColor="#041d06" />

    <Columns>
        <asp:BoundField DataField="_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="_id" ItemStyle-Width="100px">
            <ItemStyle Width="100px"></ItemStyle>
        </asp:BoundField>
        <asp:BoundField DataField="firstname" HeaderText="Firstname" SortExpression="firstname" ItemStyle-Width="100px" ItemStyle-CssClass="columns_label">
            <ItemStyle Width="100px"></ItemStyle>
        </asp:BoundField>
        <asp:BoundField DataField="mi" HeaderText="M.I" SortExpression="mi" ItemStyle-Width="100px"  ItemStyle-CssClass="columns_label">
            <ItemStyle Width="100px"></ItemStyle>
        </asp:BoundField>

        <asp:BoundField DataField="lastname" HeaderText="Lastname" SortExpression="lastname" ItemStyle-Width="100px"  ItemStyle-CssClass="columns_label">
            <ItemStyle Width="100px"></ItemStyle>
        </asp:BoundField>
          <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />

          <asp:TemplateField HeaderText="Contact" SortExpression="contact"  ItemStyle-CssClass="columns_label">
              <EditItemTemplate>
                  <asp:TextBox ID="contact" runat="server" Text='<%# Bind("contact") %>' type="number" Width="80px"></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                  <asp:Label ID="contact" runat="server" Text='<%# Eval("contact") %>'></asp:Label>
              </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="Email" SortExpression="email"   ItemStyle-CssClass="columns_label">
              <EditItemTemplate>
                  <asp:TextBox ID="empRole" runat="server" Text='<%# Bind("email") %>' type="number" Width="80px"></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                  <asp:Label ID="lblQNTY" runat="server" Text='<%# Eval("email") %>'></asp:Label>
              </ItemTemplate>
              <ItemStyle Width="100px"></ItemStyle>

          </asp:TemplateField>

          <asp:TemplateField HeaderText="Created at" SortExpression="date_reg"  ItemStyle-CssClass="columns_label">
              <EditItemTemplate>
                  <asp:TextBox ID="txtDateReg" runat="server" Text='<%# Bind("date_reg") %>' Enabled="false" Width="100px"></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                  <asp:Label ID="lblDateReg" runat="server" Text='<%# Eval("date_reg") %>'></asp:Label>
              </ItemTemplate>
          </asp:TemplateField>

        <asp:TemplateField HeaderText="Updated at" SortExpression="date_upd" ItemStyle-CssClass="columns_label">
            <EditItemTemplate>
                <asp:TextBox ID="txtDateUpd" runat="server" Text='<%# Bind("date_upd") %>' Enabled="false" Width="100px"></asp:TextBox>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="lblDateUpd" runat="server" Text='<%# Eval("date_upd") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Status" SortExpression="status" ItemStyle-CssClass="columns_label">
            <ItemTemplate>
                <%--<asp:Button ID="lbstat" runat="server" Text='<%# Eval("status") + " ▲"%>'></asp:Button>--%>

                <%--<asp:Button Style="font-size: 10px; color: orangered; font-weight: bold; font-size: 10px" ID="btnUnsuspend" runat="server" Text='<%# Eval("status") + " ▼"%>'
                    CssClass="arrow-button" OnClick="Unsuspend_Click"
                    OnClientClick="return confirm('Are you sure you want to Unsuspend this admin?');"
                    Visible='<%# Eval("status").ToString() == "suspended" %>' CommandArgument='<%# Eval("_id") %>' />

                <asp:Button Style="font-size: 10px; color: lawngreen; font-weight: bold; font-size: 10px" ID="btnSuspend" runat="server" Text='<%# Eval("status") + " ▲"%>'
                    CssClass="arrow-button ri-arrow-up-fill" OnClick="Suspend_Click"
                    OnClientClick="return confirm('Are you sure you want to Suspend this admin?');"
                    Visible='<%# Eval("status").ToString() == "active" %>' CommandArgument='<%# Eval("_id") %>' />--%>


                <asp:Button Style="font-size: 10px; color: orangered; font-weight: bold; font-size: 10px" ID="btnUnsuspend" runat="server"/>

                <asp:Button Style="font-size: 10px; color: lawngreen; font-weight: bold; font-size: 10px" ID="btnSuspend" runat="server"/>




            </ItemTemplate>
          </asp:TemplateField>



        <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="columns_label">
            <ItemTemplate>

                <%--<asp:LinkButton ID="update" runat="server" OnClick="Update_Click" CommandArgument='<%# Eval("_id") %>'>
                    <asp:Image ID="imgEdit" runat="server" ImageUrl="~/Pictures/editlogo.png" Width="35%" Height="35%" Style="margin-right: 10px" AlternateText="Edit" CssClass="edit-icon" Font-Size="10px" /></asp:LinkButton>
                <asp:LinkButton ID="Remove" runat="server" OnClick="Remove_Click" CommandArgument='<%# Eval("_id") %>' OnClientClick="return confirm('Are you sure you want to remove this admin?');">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/Pictures/removeBtn.png" Width="35%" Height="35%" AlternateText="Edit" Font-Size="10px" /></asp:LinkButton>--%>

                <asp:LinkButton ID="update" runat="server">
                    <asp:Image ID="imgEdit" runat="server" ImageUrl="~/Pictures/editlogo.png" Width="35%" Height="35%" Style="margin-right: 10px" AlternateText="Edit" CssClass="edit-icon" Font-Size="10px" />
                </asp:LinkButton>
                <asp:LinkButton ID="Remove" runat="server">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/Pictures/removeBtn.png" Width="35%" Height="35%" AlternateText="Edit" Font-Size="10px" />
                </asp:LinkButton>


            </ItemTemplate>
        </asp:TemplateField>

    </Columns>

      <RowStyle BackColor="#052507" BorderStyle="Solid" BorderColor="#0a4d1d"/>
      <EditRowStyle Width="10%" BackColor="#7C6F57"></EditRowStyle>
      <FooterStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
      <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="mediumaquamarine" BorderStyle="None" />
      <PagerStyle BorderColor="#CC9900" Font-Size="20px" BackColor="White" ForeColor="White" HorizontalAlign="Center" />
      <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="White" />
      <SortedAscendingCellStyle BackColor="Black" />
      <SortedAscendingHeaderStyle BackColor="#246B61" />
      <SortedDescendingCellStyle BackColor="Black" />
      <SortedDescendingHeaderStyle BackColor="#15524A" />
  </asp:GridView>
        </div>
      </section>


 <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
<asp:Panel ID="updatePanel" CssClass="card" runat="server" style="background-color: #052507; border: 1px solid aquamarine;">
    <ContentTemplate>
        <div class="card bg-light" style="background-color: #052507">
            <div class="card-header" style="background-color: #052507; color: aquamarine;">
                <h4>Update Admin Information</h4>
            </div>
            <div class="card-body" style="background-color: #052507">
                <div class="row">
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">ID</span>
                            </div>
                            <asp:TextBox ID="txtbxID" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm" Enabled="false"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">Firstname</span>
                            </div>
                            <asp:TextBox ID="txtbfirstname" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">M.I</span>
                            </div>
                            <asp:TextBox ID="txtmi" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">Lastname</span>
                            </div>
                            <asp:TextBox ID="txtLastname" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">Username</span>
                            </div>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">Contact</span>
                            </div>
                            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group input-group-sm mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="inputGroup-sizing-sm">Email</span>
                            </div>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ClientIDMode="Static" aria-label="Small" aria-describedby="inputGroup-sizing-sm"></asp:TextBox>
                        </div>
                    </div>

                </div>
            </div>
            <div class="card-footer" style="background-color: #052507; color: aquamarine;">
                <asp:Button ID="btncancel" CssClass="btn btn-secondary" runat="server" Text="Cancel" />
<%--                <asp:Button ID="btnUpdate" CssClass="btn btn-primary" runat="server" Text="Update" OnClick="UpdateAdminInfo" OnClientClick="return confirm('Are you sure you want to update category?');" />--%>
                                <asp:Button ID="btnUpdate" CssClass="btn btn-primary" runat="server" Text="Update" />

            </div>
        </div>
    </ContentTemplate>
</asp:Panel>



 <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btncancel" PopupControlID="updatePanel" TargetControlID="LinkButton1" BackgroundCssClass="Background" DropShadow="True"></ajaxToolkit:ModalPopupExtender>

      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(function () {
        $("input[name='EmpId']").on('input', function (e) {
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
        });
    });
</script>


<style>
    /* Container Styles */
    .gridview-container {
        max-height: 530px;
        overflow-y: auto;
        position: relative;
    }

    /* WebKit Scrollbar Styles */
    .gridview-container::-webkit-scrollbar {
        width: 12px;
    }

    .gridview-container::-webkit-scrollbar-thumb {
        background-color: #1C5E55;
        border-radius: 10px;
        border: 3px solid aquamarine;
    }

    .gridview-container::-webkit-scrollbar-track {
        background-color: #f5f5f5;
        border-radius: 10px;
    }

    /* Firefox Scrollbar Styles */
    .gridview-container {
        scrollbar-color: #1C5E55 #f5f5f5;
    }

    /* Table Styles */
    .gridview-container table {
        table-layout: fixed;
        width: 100%;
    }

    .gridview-container th,
    .gridview-container td {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .gridview-container .description-column {
        white-space: normal;
        word-wrap: break-word;
    }

    .gridview-container thead {
        position: sticky;
        top: 0;
        background-color: #1C5E55;
        color: white;
        z-index: 2; /* Keep the header on top */
    }

    .gridview-container thead th {
        position: sticky;
        top: 0;
        background-color: #1C5E55;
        color: white;
        z-index: 3; /* Increase z-index to keep the header text on top */
    }

    /* Animation for Hover Effect */
    .gridview-container::-webkit-scrollbar-thumb:hover {
        background-color: #167c6d;
    }

    .gridview-container::-webkit-scrollbar-track:hover {
        background-color: #d8d8d8;
    }

    .gridview-container::-webkit-scrollbar-thumb:active {
        background-color: #134f45;
    }

    .gridview-container::-webkit-scrollbar-track:active {
        background-color: #c2c2c2;
    }
</style>

      <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script>
    $(document).ready(function () {
        $('#<%= gridViewAdmin.ClientID %> .edit-button').on('click', function () {
            var rowIndex = $(this).closest('tr').index();
            $('#<%= gridViewAdmin.ClientID %> tr').height('auto'); // Reset all rows to auto height
            $('#<%= gridViewAdmin.ClientID %> tr:eq(' + rowIndex + ')').height($('#<%= gridViewAdmin.ClientID %> tr:eq(' + rowIndex + ')').height());
        });
    });
</script>
      <!-- End General Form Elements -->
  </main><!-- End #main -->

  <!-- ======= Footer ======= -->
  <footer id="footer" class="footer" style="border-top-color: chartreuse">
    <div class="copyright" style="color: #d4f3cf">
      &copy; Copyright <strong><span style="color: #d4f3cf">Pinoy Basurero Corporation</span></strong>. All Rights Reserved
    </div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>fgen
  <script src="assets/vendor/chart.js/chart.umd.js"></script>
  <script src="assets/vendor/echarts/echarts.min.js"></script>
  <script src="assets/vendor/quill/quill.min.js"></script>
  <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
  <script src="assets/vendor/tinymce/tinymce.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>

  <!-- Template Main JS File -->
  <script src="assets/js/main.js"></script>
    </div>
        
    </form>
</html>

