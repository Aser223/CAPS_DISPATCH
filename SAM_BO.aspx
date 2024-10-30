<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAM_BO.aspx.cs" Inherits="Capstone.SAM_BO" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>PBC - Dashboard</title>
  <meta content="" name="description">
  <meta content="" name="keywords">


    <%--hide unhide pass--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />


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
        .table {
    width: 100%;
    border-collapse: collapse;
}

.thead-dark {
    background-color: #343a40; /* Dark header background */
    color: #ffffff; /* White text for header */
}

.table-row {
    background-color: white; /* White background for normal rows */
    color: black; /* Black text */
}

.table-row-striped {
    background-color: #f9cfb4; /* Light color for alternating rows */
    color: black; /* Black text */
}

.column {
    padding: 10px; /* Padding for columns */
    word-wrap: break-word; /* Allows long text to wrap within the cell */
}

/* Optional: Add hover effect */
.table-row:hover {
    background-color: #e0e0e0; /* Light grey on hover */
}



    /*Panel scrollable height*/
    /*.scrollable-panel {
        max-height: 95vh;*/ /* Adjust this value as needed */
        /*overflow-y: auto;*/ /* Enables vertical scrolling */
    /*}*/

      .scrollable-panel {
        max-height: 680px; /* Adjust the height as needed */
        overflow-y: auto; /* Enables vertical scrolling */
        overflow-x: hidden; /* Hides horizontal scrolling */
        border-radius: 8px; /* Rounded corners */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        padding: 20px; /* Padding inside the panel */
        background-color: #f9f9f9; /* Light background color */
        border: 1px solid #ddd; /* Light border */
        box-sizing: border-box; /* Includes padding and border in element's total width and height */
    }

    .scrollable-panel::-webkit-scrollbar {
        width: 12px; /* Increase width to make scrollbar less intrusive */
    }

    .scrollable-panel::-webkit-scrollbar-thumb {
        background-color: #025539; /* Color of the scrollbar thumb */
        border-radius: 6px; /* Rounded scrollbar thumb */
    }

    .scrollable-panel::-webkit-scrollbar-thumb:hover {
        background-color: #555; /* Darker color on hover */
    }

    .scrollable-panel::-webkit-scrollbar-track {
        background-color: #f1f1f1; /* Color of the scrollbar track */
        border-radius: 6px; /* Rounded scrollbar track */
    }


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
        var grid = document.getElementById('<%= gridViewAccountMan.ClientID %>');

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
                  <asp:Label ID="Label3" runat="server" Text="Super Account Manager"></asp:Label></span>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="SAM_AccountSettings.aspx">
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
                <a href="WAREHOUSE_ADD_CATEGORY.aspx">
                    <i class="bi bi-circle"></i><span>Drivers</span>
                </a>
            </li>

            <li>
                <a href="SAM_BO.aspx" class="active">
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
          <li class="breadcrumb-item">Account Manager </li>

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
                          <asp:Label ID="Label13" runat="server" Text="Firstname" for="inputText" Style="color: chartreuse; margin-top: 10px"></asp:Label>
                          <asp:TextBox ID="emp_firstname" runat="server" class="form-control" Style="margin-top: 10px" onkeyup="validateFirstname()"></asp:TextBox>
                          <span id="emp_firstnameError" class="text-danger"></span>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label4" runat="server" Text="M.I" for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_mi" runat="server" class="form-control" Style="margin-top: 10px; margin-bottom: 10px"></asp:TextBox>

                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label5" runat="server" Text="Lastname" for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_lastname" runat="server" class="form-control" Style="margin-top: 10px" onkeyup="validateLastname()"></asp:TextBox>
                          <span id="emp_lastnameError" class="text-danger"></span>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label10" runat="server" Text="Email" for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_email" runat="server" class="form-control" Style="margin-top: 10px" onkeyup="validateEmail()"></asp:TextBox>
                          <span id="emp_emailError" class="text-danger"></span>
                          <asp:HiddenField ID="emailStatus" runat="server" />
                      </div>
                      <div class="col-12 mb-3">
                          <!-- Password Label -->
                          <asp:Label ID="Label7" runat="server" Text="Password" for="inputText" Style="color: chartreuse"></asp:Label>

                          <!-- Password TextBox with Toggle Visibility Icon -->
                          <div class="input-group" style="margin-top: 10px;">
                              <asp:TextBox ID="emp_pass" runat="server" class="form-control" type="password"></asp:TextBox>

                              <!-- Toggle Password Visibility Icon, positioned inline with the textbox -->
                              <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswords()">
                                  <i id="passIcon" class="fas fa-eye-slash"></i>
                              </span>
                          </div>

                          <!-- Error Message for Password Validation -->
                          <span id="emp_passError" class="text-danger"></span>
                      </div>

                      <div class="mb-3">
                          <asp:Label ID="Label8" runat="server" Text="Contact No." for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:TextBox ID="emp_contact" runat="server" TextMode="Number" class="form-control"  Style="margin-top: 10px" onkeyup="validateContact()"></asp:TextBox>
                          <span id="emp_contactError" class="text-danger"></span>
                      </div>
                      <div class="mb-3">
                          <asp:Label ID="Label6" runat="server" Text="Role" for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:DropDownList ID="emp_role" class="form-select" aria-label="Default select example" runat="server">
                              <asp:ListItem Selected="True" disabled>&lt;--Select Role--&gt;</asp:ListItem>
                              <asp:ListItem>Super Account Manager</asp:ListItem>
                              <asp:ListItem>Account Manager</asp:ListItem>
                          </asp:DropDownList>
                          <span id="emp_roleError" class="text-danger"></span>
                      </div>

                      <div class="mb-3">
                          <asp:Label ID="Label12" runat="server" Text="Picture" for="inputText" Style="color: chartreuse"></asp:Label>
                          <asp:FileUpload ID="formFile" class="form-control" runat="server" OnChange="previewImage1()" />
<%--                          <img id="imagePreview" src="Pictures/blank_prof.png" alt="Image Preview" style="max-width: 200px; margin-top: 10px;" />--%>
                          <asp:ImageMap ID="imagePreview" src="Pictures/blank_prof.png" runat="server" alt="Image Preview" CssClass="img-thumbnail mt-2" Style="max-width: 150px; margin-top: 10px;"></asp:ImageMap>
                          <span id="fileError" style="color: red; display: none;">File uploaded is not an image.</span>
                      </div>

                  </div>
                  <div class="modal-footer">
                      <asp:Button ID="ClearForm" Text="Close" runat="server" class="btn btn-secondary" data-bs-dismiss="modal" OnClick="ClearForm_Click" />
                      <asp:Button class="btn btn-primary" ID="submitBtn" runat="server" Text="Submit Form" OnClick="submitBtn_Click" />
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
            Add Account Manager +
        </button>
    </div>

          <%--ADD BUTTON--%>
          <div class="gridview-container">
                            <table class="table datatable">
 
              <thead>
<tr style="background-color: #2c2c2c; color: Chartreuse;">
            <th style="padding: 10px; text-align: left;">ID</th>
            <th style="padding: 10px; text-align: left;">First Name</th>
            <th style="padding: 10px; text-align: left;">M.I</th>
            <th style="padding: 10px; text-align: left;">Last Name</th>
            <th style="padding: 10px; text-align: left;">Contact</th>
            <th style="padding: 10px; text-align: left;">Email</th>
            <th style="padding: 10px; text-align: left;">Created At</th>
            <th style="padding: 10px; text-align: left;">Updated At</th>
            <th style="padding: 10px; text-align: left;">Status</th>
            <th style="padding: 10px; text-align: left;">Action</th>
        </tr>
                  </thead>
                                </table>
    <asp:GridView ID="gridViewAccountMan" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True" CssClass="table datatable"
        DataKeyNames="acc_id" AllowPaging="False" CellPadding="20" GridLines="None" Style="width: 100%; word-break: break-all; table-layout: fixed">
        
        <HeaderStyle BackColor="#2c2c2c" Font-Bold="True" ForeColor="Chartreuse" Font-Size="14px" />
        <RowStyle BackColor="White" ForeColor="Black" />
        <AlternatingRowStyle BackColor="#f9cfb4" ForeColor="Black" />
        
        <Columns>
            <asp:BoundField DataField="acc_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="acc_id" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_fname" HeaderText="First Name" SortExpression="acc_fname" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_mname" HeaderText="M.I" SortExpression="acc_mname" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_lname" HeaderText="Last Name" SortExpression="acc_lname" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_contact" HeaderText="Contact" SortExpression="acc_contact" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_email" HeaderText="Email" SortExpression="acc_email" ItemStyle-Width="200px">
                <ItemStyle Width="200px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_created_at" HeaderText="Created At" SortExpression="acc_created_at" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_updated_at" HeaderText="Updated At" SortExpression="acc_updated_at" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Button Style="font-size: 10px; color: orangered; font-weight: bold;" ID="btnUnsuspend" runat="server" Text='<%# Eval("acc_status") + " ▼"%>'
                        OnClick="Unsuspend_Click"
                        OnClientClick="return confirm('Are you sure you want to Unsuspend this account manager?');"
                        Visible='<%# Eval("acc_status").ToString() == "Suspend" %>' CommandArgument='<%# Eval("acc_id") %>' />
                    <asp:Label ID="Label9" runat="server" Text='<%# Eval("acc_status")%>' Visible='<%# Eval("acc_status").ToString() == "Inactive" %>' />
                    <asp:Button Style="font-size: 10px; color: lawngreen; font-weight: bold;" ID="btnSuspend" runat="server" Text='<%# Eval("acc_status") + " ▲"%>'
                        OnClick="Suspend_Click"
                        OnClientClick="return confirm('Are you sure you want to Suspend this account manager?');"
                        Visible='<%# Eval("acc_status").ToString() == "Active" %>' CommandArgument='<%# Eval("acc_id") %>' />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Action">
                <ItemTemplate>
                    <asp:LinkButton ID="update" runat="server" OnClick="Update_Click" CommandArgument='<%# Eval("acc_id") %>'>
                        <asp:Image ID="imgEdit" runat="server" ImageUrl="~/Pictures/editlogo.png" Width="35%" Height="35%" Style="margin-right: 10px" AlternateText="Edit" />
                    </asp:LinkButton>
                    <asp:LinkButton ID="Remove" runat="server" OnClick="Remove_Click" CommandArgument='<%# Eval("acc_id") %>' OnClientClick="return confirm('Are you sure you want to remove this account manager?');">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Pictures/removeBtn.png" Width="35%" Height="35%" AlternateText="Remove" />
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

        <FooterStyle BackColor="Black" Font-Bold="True" ForeColor="#f9cfb4" />
        <PagerStyle BorderColor="#CC9900" Font-Size="20px" BackColor="White" ForeColor="#f9cfb4" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="White" />
    </asp:GridView>
</div>



    <%--EDIT BUTTON--%>
    <%--<div class="gridview-container">
    <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed" ID="gridViewAccountMan" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True" 
        DataKeyNames="acc_id" AllowPaging="False" CellPadding="20" GridLines="None">
        <AlternatingRowStyle BackColor="#f9cfb4" ForeColor="Black" />

        <Columns>
            <asp:BoundField DataField="acc_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="acc_id" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_fname" HeaderText="First Name" SortExpression="acc_fname" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_mname" HeaderText="M.I" SortExpression="acc_mname" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_lname" HeaderText="Last Name" SortExpression="acc_lname" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_contact" HeaderText="Contact" SortExpression="acc_contact" ItemStyle-Width="100px">
                <ItemStyle Width="100px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_email" HeaderText="Email" SortExpression="acc_email" ItemStyle-Width="200px">
                <ItemStyle Width="200px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_created_at" HeaderText="Created At" SortExpression="acc_created_at" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            <asp:BoundField DataField="acc_updated_at" HeaderText="Updated At" SortExpression="acc_updated_at" ItemStyle-Width="150px">
                <ItemStyle Width="150px" Wrap="true" />
            </asp:BoundField>
            
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Button Style="font-size: 10px; color: orangered; font-weight: bold;" ID="btnUnsuspend" runat="server" Text='<%# Eval("acc_status") + " ▼"%>'
                        OnClick="Unsuspend_Click"
                        OnClientClick="return confirm('Are you sure you want to Unsuspend this account manager?');"
                        Visible='<%# Eval("acc_status").ToString() == "Suspend" %>' CommandArgument='<%# Eval("acc_id") %>' />
                    <asp:Label ID="Label9" runat="server" Text='<%# Eval("acc_status")%>' Visible='<%# Eval("acc_status").ToString() == "Inactive" %>' />
                    <asp:Button Style="font-size: 10px; color: lawngreen; font-weight: bold;" ID="btnSuspend" runat="server" Text='<%# Eval("acc_status") + " ▲"%>'
                        OnClick="Suspend_Click"
                        OnClientClick="return confirm('Are you sure you want to Suspend this account manager?');"
                        Visible='<%# Eval("acc_status").ToString() == "Active" %>' CommandArgument='<%# Eval("acc_id") %>' />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Action">
                <ItemTemplate>
                    <asp:LinkButton ID="update" runat="server" OnClick="Update_Click" CommandArgument='<%# Eval("acc_id") %>'>
                        <asp:Image ID="imgEdit" runat="server" ImageUrl="~/Pictures/editlogo.png" Width="35%" Height="35%" Style="margin-right: 10px" AlternateText="Edit" />
                    </asp:LinkButton>
                    <asp:LinkButton ID="Remove" runat="server" OnClick="Remove_Click" CommandArgument='<%# Eval("acc_id") %>' OnClientClick="return confirm('Are you sure you want to remove this account manager?');">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Pictures/removeBtn.png" Width="35%" Height="35%" AlternateText="Remove" />
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

        <RowStyle BackColor="White" ForeColor="Black" />
        <EditRowStyle BackColor="#7C6F57" />
        <FooterStyle BackColor="Black" Font-Bold="True" ForeColor="#f9cfb4" />
        <HeaderStyle BackColor="#2c2c2c" Font-Bold="True" ForeColor="Chartreuse" BorderStyle="None" />
        <PagerStyle BorderColor="#CC9900" Font-Size="20px" BackColor="White" ForeColor="#f9cfb4" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="Black" />
        <SortedAscendingHeaderStyle BackColor="#246B61" />
        <SortedDescendingCellStyle BackColor="Black" />
        <SortedDescendingHeaderStyle BackColor="#15524A" />
    </asp:GridView>
</div>--%>




          <%--<div class="gridview-container">
    <asp:GridView ID="gridViewAccountMan" runat="server" AutoGenerateColumns="False" AllowPaging="False" GridLines="None" CssClass="table datatable">
        <HeaderStyle CssClass="thead-dark" />
        <RowStyle CssClass="table-row" />
        <AlternatingRowStyle CssClass="table-row-striped" />

        <Columns>
            <asp:BoundField DataField="acc_fname" SortExpression="acc_fname" ItemStyle-CssClass="column" />
            <asp:BoundField DataField="acc_contact" HeaderText="Contact" SortExpression="acc_contact" ItemStyle-CssClass="column" />
            <asp:BoundField DataField="acc_email" HeaderText="Email" SortExpression="acc_email" ItemStyle-CssClass="column" />
            <asp:BoundField DataField="acc_created_at" HeaderText="Created At" SortExpression="acc_created_at" ItemStyle-CssClass="column" />
            <asp:BoundField DataField="acc_status" HeaderText="Status" ItemStyle-CssClass="column" />
        </Columns>
    </asp:GridView>
</div>--%>





</section>






      <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
      <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

      <!-- Centering the panel and enhancing its look -->
      <div class="container" style="height: 100vh; display: flex; justify-content: center; align-items: center;">
          <asp:Panel ID="updatePanel" CssClass="card shadow-lg scrollable-panel" runat="server" Style="max-width: 600px; background-color: #052507; border: 1px solid aquamarine; border-radius: 8px;">
              <contenttemplate>
                  <div class="card bg-light" style="background-color: #052507;">
                      <!-- Header Section -->
                      <div class="card-header text-center" style="background-color: #052507; color: aquamarine;">
                          <h4 class="mb-0">Update Information</h4>
                      </div>

                      <!-- Body Section -->
                      <div class="card-body" style="background-color: #052507;">
                          <div class="row">
                              <div class="col-12 mb-3">
                                  <div class="input-group input-group-sm">
                                  </div>
                              </div>
                              <!-- ID -->
                              <div class="col-12 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">ID</span>
                                      </div>
                                      <asp:TextBox ID="txtbxID" runat="server" CssClass="form-control" ClientIDMode="Static" Enabled="false"></asp:TextBox>
                                  </div>
                              </div>

                              <!-- Firstname -->
                              <div class="col-6 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">Firstname</span>
                                      </div>
                                      <asp:TextBox ID="txtbfirstname" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                                      <br />
                                      <span id="upd_firstnameError" class="text-danger"></span>
                                  </div>
                              </div>

                              <!-- Lastname -->
                              <div class="col-6 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">Lastname</span>
                                      </div>
                                      <asp:TextBox ID="txtLastname" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                                      <br />
                                      <span id="upd_lastnameError" class="text-danger"></span>
                                  </div>
                              </div>

                              <!-- Middle Initial -->
                              <div class="col-6 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">M.I</span>
                                      </div>
                                      <asp:TextBox ID="txtmi" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                                  </div>
                              </div>

                              <!-- Contact -->
                              <div class="col-6 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">Contact</span>
                                      </div>
                                      <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" ClientIDMode="Static" textmode="Number"></asp:TextBox>
                                      <br />
                                      <span id="upd_contactError" class="text-danger"></span>
                                  </div>
                              </div>

                              <!-- Email -->
                              <div class="col-12 mb-3">
                                  <div class="input-group input-group-sm">
                                      <div class="input-group-prepend">
                                          <span class="input-group-text">Email</span>
                                      </div>
                                      <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                                      <br />
                                      <span id="upd_emailError" class="text-danger"></span>
                                  </div>
                              </div>

                              <!-- Password -->
                              <div class="col-12 mb-3">
                                  <asp:Label ID="Label15" runat="server" Text="Password" Style="color: chartreuse"></asp:Label>
                                  <div class="input-group">
                                      <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control mt-2" type="password"></asp:TextBox>
                                      <span class="input-group-text mt-2" style="cursor: pointer;" onclick="togglePassword()">
                                          <i id="passwordIcon" class="fas fa-eye-slash"></i>
                                      </span>
                                  </div>
                                  <br />
                                  <span id="upd_passError" class="text-danger"></span>
                              </div>



                              <!-- Picture Upload -->
                              <div class="col-12 mb-3">
                                  <asp:Label ID="Label14" runat="server" Text="Picture" Style="color: chartreuse"></asp:Label>
                                  <asp:FileUpload ID="FileUpload1" CssClass="form-control" runat="server" OnChange="previewImage();" />

                                  <!-- Image preview, with a dynamic src attribute -->
<%--                                  <img id="imagePreviewUpdate" src="Pictures/blank_prof.png" alt="Image Preview" class="img-thumbnail mt-2" style="max-width: 150px;" />--%>
<%--                                  <asp:ImageMap ID="imagePreviewUpdate" runat="server" alt="Image Preview" class="img-thumbnail mt-2" style="max-width: 150px;""></asp:ImageMap>--%>
                                  <asp:Image ID="imagePreviewUpdate" runat="server" AlternateText="Image Preview" CssClass="img-thumbnail mt-2" Style="max-width: 150px;" />

                                  <span id="fileErrorUpdate" class="text-danger" style="display: none;">File uploaded is not an image.</span>
                              </div>
                          </div>
                      </div>

                      <!-- Footer Section -->
                      <div class="card-footer text-center" style="background-color: #052507; color: aquamarine;">
                          <asp:Button ID="btncancel" CssClass="btn btn-secondary" runat="server" Text="Cancel" />
                          <asp:Button ID="btnUpdate" CssClass="btn btn-primary" runat="server" Text="Update" OnClick="UpdateAdminInfo" OnClientClick="return confirm('Are you sure you want to update category?');" />
                      </div>
                  </div>
              </contenttemplate>
          </asp:Panel>
      </div>




      <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btncancel" PopupControlID="updatePanel" TargetControlID="LinkButton1" BackgroundCssClass="Background" DropShadow="True"></ajaxToolkit:ModalPopupExtender>

      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <%--<script>
          $(function () {
              $("input[name='EmpId']").on('input', function (e) {
                  $(this).val($(this).val().replace(/[^0-9]/g, ''));
              });
          });

          // Function to validate the Firstname field
          function validateFirstname() {
              const firstname = document.getElementById('<%= emp_firstname.ClientID %>').value;
              const errorSpan = document.getElementById('emp_firstnameError');
              if (firstname === "") {
                  errorSpan.textContent = "Firstname is required.";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }

          // Function to validate the Lastname field
          function validateLastname() {
              const lastname = document.getElementById('<%=emp_lastname.ClientID%>').value;
              const errorSpan = document.getElementById('emp_lastnameError');
              if (lastname === "") {
                  errorSpan.textContent = "Lastname is required.";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }


          // Function to validate the Email field
          function validateEmail() {
              const email = document.getElementById('<%= emp_email.ClientID %>').value;
              const errorSpan = document.getElementById('emp_emailError');
              const emailRegex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;

              if (email === "") {
                  errorSpan.textContent = "Email is required.";
                  return false;
              } else if (!emailRegex.test(email)) {
                  errorSpan.textContent = "Please enter a valid email address.";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }

          // Function to validate the Password field
          function validatePassword() {
              const password = document.getElementById('<%= emp_pass.ClientID %>').value;
              const errorSpan = document.getElementById('emp_passError');
              const passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;

              if (password === "") {
                  errorSpan.textContent = "Password is required.";
                  return false;
              } else if (!passRegex.test(password)) {
                  errorSpan.textContent = "Password must be at least 6 characters long, contain one number, one uppercase, and one lowercase letter.";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }

          // Function to validate the entire form
          function validateForm() {
              const isValidFirstname = validateFirstname();
              const isValidLastname = validateLastname();
              const isValidEmail = validateEmail();
              const isValidPassword = validatePassword();
              const isValidContact = validateContact();
              const isValidRole = validateRole();

              const submitButton = document.getElementById('<%= submitBtn.ClientID %>');

              // Enable or disable the submit button based on validation results
              if (isValidFirstname && isValidLastname && isValidEmail && isValidPassword && isValidContact && isValidRole) {
                  submitButton.disabled = false;
              } else {
                  submitButton.disabled = true;
              }
          }


          // Function to validate the Contact number field
          function validateContact() {
              const contact = document.getElementById('<%= emp_contact.ClientID %>').value;
              const errorSpan = document.getElementById('emp_contactError');
              const contactRegex = /^(\+63|0)\d{10}$/;

              if (contact === "") {
                  errorSpan.textContent = "Contact number is required.";
                  return false;
              } else if (!contactRegex.test(contact)) {
                  errorSpan.textContent = "Please enter a valid contact number (e.g., 09123456789 or +639123456789).";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }


          // Function to validate the Role field
          function validateRole() {
              const role = document.getElementById('<%= emp_role.ClientID %>').value;
              const errorSpan = document.getElementById('emp_roleError');

              if (role === "<--Select Role-->") {
                  errorSpan.textContent = "Role is required.";
                  return false;
              } else {
                  errorSpan.textContent = "";
                  return true;
              }
          }

          function previewImage() {
              const fileInput = document.getElementById('<%=formFile.ClientID %>');
              const file = fileInput.files[0];
              const preview = document.getElementById('imagePreview');
              const error = document.getElementById('fileError');

              // Reset error and image preview
              error.style.display = 'none';
              preview.src = 'Pictures/blank_prof.png'; // default image

              if (file) {
                  const fileType = file.type;
                  const validImageTypes = ["image/jpeg", "image/png", "image/gif"];

                  if (validImageTypes.includes(fileType)) {
                      const reader = new FileReader();
                      reader.onload = function (e) {
                          preview.src = e.target.result;  // Set the preview image to the file chosen
                      }
                      reader.readAsDataURL(file); // Read the file as a data URL
                  } else {
                      // Display error if file is not an image
                      error.style.display = 'block';
                  }
              }
          }

          // Attach event listeners to validate on keyup or change
          document.getElementById('<%= emp_firstname.ClientID %>').addEventListener('keyup', validateForm);
          document.getElementById('<%= emp_lastname.ClientID %>').addEventListener('keyup', validateForm);
          document.getElementById('<%= emp_email.ClientID %>').addEventListener('keyup', validateForm);
          document.getElementById('<%= emp_pass.ClientID %>').addEventListener('keyup', validateForm);
          document.getElementById('<%= emp_contact.ClientID %>').addEventListener('keyup', validateForm);
          document.getElementById('<%= emp_role.ClientID %>').addEventListener('change', validateForm);


      </script>--%>



      <%--WORKING CODES NAJUD NI--%>
<%--2nd WORKING FOR SCRIPTS--%>
<script>
    $(function () {
        $("input[name='EmpId']").on('input', function (e) {
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
        });
    });

    function togglePasswords() {
        const passwordInput = document.getElementById('<%= emp_pass.ClientID %>');
        const passIcon = document.getElementById('passIcon');

        console.log(passwordInput);  // This will help check if passwordInput is correctly selected.

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            passIcon.classList.remove('fa-eye-slash');
            passIcon.classList.add('fa-eye');
        } else {
            passwordInput.type = "password";
            passIcon.classList.remove('fa-eye');
            passIcon.classList.add('fa-eye-slash');
        }
    }




    // Function to validate the Firstname field
    function validateFirstname() {
        const firstname = document.getElementById('<%= emp_firstname.ClientID %>').value;
        const errorSpan = document.getElementById('emp_firstnameError');
        if (firstname === "") {
            errorSpan.textContent = "Firstname is required.";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the Lastname field
    function validateLastname() {
        const lastname = document.getElementById('<%=emp_lastname.ClientID%>').value;
        const errorSpan = document.getElementById('emp_lastnameError');
        if (lastname === "") {
            errorSpan.textContent = "Lastname is required.";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the Email field
    function validateEmail() {
        const email = document.getElementById('<%= emp_email.ClientID %>').value;
        const errorSpan = document.getElementById('emp_emailError');
        const emailRegex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;

        if (email === "") {
            errorSpan.textContent = "Email is required.";
            return false;
        } else if (!emailRegex.test(email)) {
            errorSpan.textContent = "Please enter a valid email address.";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the Password field
    function validatePassword() {
        const password = document.getElementById('<%= emp_pass.ClientID %>').value;
        const errorSpan = document.getElementById('emp_passError');
        const passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;

        if (password === "") {
            errorSpan.textContent = "Password is required.";
            return false;
        } else if (!passRegex.test(password)) {
            errorSpan.textContent = "Password must be at least 6 characters long, contain one number, one uppercase, and one lowercase letter.";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the Contact number field
    function validateContact() {
        const contact = document.getElementById('<%= emp_contact.ClientID %>').value;
        const errorSpan = document.getElementById('emp_contactError');
        const contactRegex = /^(\+63|0)\d{10}$/;

        if (contact === "") {
            errorSpan.textContent = "Contact number is required.";
            return false;
        } else if (!contactRegex.test(contact)) {
            errorSpan.textContent = "Please enter a valid contact number (e.g., 09123456789 or +639123456789).";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the Role field
    function validateRole() {
        const role = document.getElementById('<%= emp_role.ClientID %>').value;
        const errorSpan = document.getElementById('emp_roleError');

        if (role === "<--Select Role-->") {
            errorSpan.textContent = "Role is required.";
            return false;
        } else {
            errorSpan.textContent = "";
            return true;
        }
    }

    // Function to validate the entire form
    function validateForm() {
        const isValidFirstname = validateFirstname();
        const isValidLastname = validateLastname();
        const isValidEmail = validateEmail();
        const isValidPassword = validatePassword();
        const isValidContact = validateContact();
        const isValidRole = validateRole();

        const submitButton = document.getElementById('<%= submitBtn.ClientID %>');

        // Enable or disable the submit button based on validation results
        if (isValidFirstname && isValidLastname && isValidEmail && isValidPassword && isValidContact && isValidRole) {
            submitButton.disabled = false;
        } else {
            submitButton.disabled = true;
        }

        // Display SweetAlert errors for missing fields
        //if (!isValidFirstname) {
        //    Swal.fire('Validation Error', 'Please enter your first name.', 'error');
        //}
        //if (!isValidLastname) {
        //    Swal.fire('Validation Error', 'Please enter your last name.', 'error');
        //}
        //if (!isValidEmail) {
        //    Swal.fire('Validation Error', 'Please enter a valid email address.', 'error');
        //}
        //if (!isValidContact) {
        //    Swal.fire('Validation Error', 'Please enter your contact number.', 'error');
        //}
        //if (!isValidPassword) {
        //    Swal.fire('Validation Error', 'Please enter a valid password.', 'error');
        //}
        //if (!isValidRole) {
        //    Swal.fire('Validation Error', 'Please select a role.', 'error');
        //}

        return isValidFirstname && isValidLastname && isValidEmail && isValidPassword && isValidContact && isValidRole;
    }


    //
    function previewImage() {
        var fileInput = document.getElementById('<%= FileUpload1.ClientID %>');
        var file = fileInput.files[0];
        var reader = new FileReader();

        reader.onload = function (e) {
            var imagePreview = document.getElementById('<%= imagePreviewUpdate.ClientID %>');
            imagePreview.src = e.target.result;
        };

        if (file && file.type.startsWith("image/")) {
            reader.readAsDataURL(file);
            document.getElementById('fileErrorUpdate').style.display = "none";
        } else {
            document.getElementById('fileErrorUpdate').style.display = "block";
            document.getElementById('<%= imagePreviewUpdate.ClientID %>').src = "~/Pictures/blank_prof.png";
        }
    }

    function previewImage1() {
        var fileInput = document.getElementById('<%= formFile.ClientID %>');
        var file = fileInput.files[0];
        var reader = new FileReader();

        reader.onload = function (e) {
            var imagePreview = document.getElementById('<%= imagePreview.ClientID %>');
            imagePreview.src = e.target.result;
        };

        if (file && file.type.startsWith("image/")) {
            reader.readAsDataURL(file);
            document.getElementById('fileErrorUpdate').style.display = "none";
        } else {
            document.getElementById('fileErrorUpdate').style.display = "block";
            document.getElementById('<%= imagePreview.ClientID %>').src = "~/Pictures/blank_prof.png";
        }
    }


    // Attach event listeners to validate on keyup or change
    document.getElementById('<%= emp_firstname.ClientID %>').addEventListener('keyup', validateForm);
    document.getElementById('<%= emp_lastname.ClientID %>').addEventListener('keyup', validateForm);
    document.getElementById('<%= emp_email.ClientID %>').addEventListener('keyup', validateForm);
    document.getElementById('<%= emp_pass.ClientID %>').addEventListener('keyup', validateForm);
    document.getElementById('<%= emp_contact.ClientID %>').addEventListener('keyup', validateForm);
    document.getElementById('<%= emp_role.ClientID %>').addEventListener('change', validateForm);

</script>






<script>
    $(function () {
        // Restrict EmpId to only numbers
        $("input[name='EmpId']").on('input', function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
        });

        // Toggle password visibility
        window.togglePassword = function () {
            var passwordField = document.getElementById('<%= TextBox1.ClientID %>');
            var icon = document.getElementById('passwordIcon');
            if (passwordField.type === "password") {
                passwordField.type = "text";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            } else {
                passwordField.type = "password";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            }
        };

        // Function to validate the Firstname field
        function validateFirstname() {
            const firstname = document.getElementById('<%= txtbfirstname.ClientID %>').value;
            const errorSpan = document.getElementById('upd_firstnameError');
            if (firstname === "") {
                errorSpan.textContent = "Firstname is required.";
                return false;
            } else {
                errorSpan.textContent = "";
                return true;
            }
        }

        // Function to validate the Lastname field
        function validateLastname() {
            const lastname = document.getElementById('<%= txtLastname.ClientID %>').value;
            const errorSpan = document.getElementById('upd_lastnameError');
            if (lastname === "") {
                errorSpan.textContent = "Lastname is required.";
                return false;
            } else {
                errorSpan.textContent = "";
                return true;
            }
        }

        // Function to validate the Email field
        function validateEmail() {
            const email = document.getElementById('<%= txtEmail.ClientID %>').value;
            const errorSpan = document.getElementById('upd_emailError');
            const emailRegex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;

            if (email === "") {
                errorSpan.textContent = "Email is required.";
                return false;
            } else if (!emailRegex.test(email)) {
                errorSpan.textContent = "Please enter a valid email address.";
                return false;
            } else {
                errorSpan.textContent = "";
                return true;
            }
        }

        // Function to validate the Contact number field
        function validateContact() {
            const contact = document.getElementById('<%= txtContact.ClientID %>').value;
            const errorSpan = document.getElementById('upd_contactError');
            const contactRegex = /^[9]\d{9}$/;  // Contact number must start with '9' and have exactly 10 digits

            if (contact === "") {
                errorSpan.textContent = "Contact number is required.";
                return false;
            } else if (!contactRegex.test(contact)) {
                errorSpan.textContent = "Please enter a valid contact number starting with 9 and having 10 digits (e.g., 9123456789).";
                return false;
            } else {
                errorSpan.textContent = "";
                return true;
            }
        }


        // Function to validate the Password field
        function validatePassword() {
            const password = document.getElementById('<%= TextBox1.ClientID %>').value;
            const errorSpan = document.getElementById('upd_passError');
            const passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;

            if (password === "") {
                errorSpan.textContent = ""; // Optional field if empty
                return true;
            } else if (!passRegex.test(password)) {
                errorSpan.textContent = "Password must be at least 6 characters long, contain one number, one uppercase, and one lowercase letter.";
                return false;
            } else {
                errorSpan.textContent = "";
                return true;
            }
        }

        // Function to validate the Picture Upload field
        function validatePictureUpload() {
            const fileInput = document.getElementById('<%= FileUpload1.ClientID %>');
        const file = fileInput.files[0];
        const errorSpan = document.getElementById('fileErrorUpdate');

        // Reset error
        errorSpan.style.display = 'none';

        if (file) {
            const fileType = file.type;
            const validImageTypes = ["image/jpeg", "image/png", "image/gif"];

            if (!validImageTypes.includes(fileType)) {
                errorSpan.style.display = 'block';
                return false;
            }
        }
        return true;
    }

    // Attach event listeners to validate on keyup or change
    document.getElementById('<%= txtbfirstname.ClientID %>').addEventListener('keyup', validateFirstname);
    document.getElementById('<%= txtLastname.ClientID %>').addEventListener('keyup', validateLastname);
    document.getElementById('<%= txtEmail.ClientID %>').addEventListener('keyup', validateEmail);
    document.getElementById('<%= TextBox1.ClientID %>').addEventListener('keyup', validatePassword);
    document.getElementById('<%= txtContact.ClientID %>').addEventListener('keyup', validateContact);

    // Attach change event listeners for image preview and validation
    document.getElementById('<%= FileUpload1.ClientID %>').addEventListener('change', function () {
        previewImage(); // Assuming previewImage() is defined elsewhere
        validatePictureUpload();
    });

        document.getElementById('<%= formFile.ClientID %>').addEventListener('change', function () {
            previewImage(); // Assuming previewImage() is defined elsewhere
            validatePictureUpload();
        });

        // Form validation on submit
        document.querySelector('form').addEventListener('submit', function (e) {
            const isValidFirstname = validateFirstname();
            const isValidLastname = validateLastname();
            const isValidEmail = validateEmail();
            const isValidPassword = validatePassword();
            const isValidContact = validateContact();
            const isValidPicture = validatePictureUpload();

            if (!isValidFirstname || !isValidLastname || !isValidEmail || !isValidPassword || !isValidContact || !isValidPicture) {
                e.preventDefault(); // Prevent form submission if validation fails
            }
        });
    });

    $(document).ready(function () {
        // Ensure contact number starts with a non-zero digit and has a max length of 10 digits
        document.getElementById('<%= txtContact.ClientID %>').addEventListener('input', function () {
            // Remove non-numeric characters
            this.value = this.value.replace(/[^0-9]/g, '');

            // Remove leading zeros
            if (this.value.startsWith('0')) {
                this.value = this.value.replace(/^0+/, '');
            }

            // Limit to 10 digits
            this.value = this.value.substring(0, 10);
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
        $('#<%= gridViewAccountMan.ClientID %> .edit-button').on('click', function () {
            var rowIndex = $(this).closest('tr').index();
            $('#<%= gridViewAccountMan.ClientID %> tr').height('auto'); // Reset all rows to auto height
            $('#<%= gridViewAccountMan.ClientID %> tr:eq(' + rowIndex + ')').height($('#<%= gridViewAccountMan.ClientID %> tr:eq(' + rowIndex + ')').height());
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
    </body>
    </div>
        
    </form>
</html>
