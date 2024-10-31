<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dispatcher_Dashboard.aspx.cs" Inherits="Capstone.Dispatcher_Dashboard" %>

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
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">
    <%--<style>
  .nav-item:hover i, .nav-item:hover span {
    color: aquamarine !important;
  }
</style>--%

    <%--<style>
  .nav-item:hover i,
  .nav-item:hover span,
  .nav-item.active i,
  .nav-item.active span {
    color: aquamarine !important;
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    var navItems = document.querySelectorAll('.nav-item');

    navItems.forEach(function (item) {
      item.addEventListener('click', function () {
        // Remove 'active' class from all items
        navItems.forEach(function (otherItem) {
          otherItem.classList.remove('active');
        });

        // Add 'active' class to the clicked item
        item.classList.add('active');
      });
    });
  });
</script>--%>


    <style>
   .dashboard {
    display: flex;
    flex-direction: column;
    gap: 30px;
}
.header {
    display: flex;
    justify-content: space-around;
    padding: 20px;
    background-color: #f9f9f9;
}
.stat {
    text-align: center;
}
.icon {
    width: 50px;
    height: 50px;
    margin-bottom: 10px;
}
.truck-types {
    display: flex;
    justify-content: space-around;
    gap: 20px;
}
.truck-type {
    text-align: center;
}
.pie-chart {
    width: 50%;
    margin: 0 auto;
    text-align: center;
}
.hauler-list {
    text-align: center;
}
.hauler-list ul {
    list-style: none;
    padding: 0;
}
.hauler-list li {
    padding: 5px;
    border-bottom: 1px solid #ddd;
}
#vehicleSummary .count {
    color:  #7F00FF; 
    font-size: 26px; /* Larger font size for numbers */
    font-weight: bold;
}
.scrollable-grid {
        max-height: 600px; /* Set the max height */
        overflow-y: auto;  /* Enable vertical scrolling */
        overflow-x: hidden; /* Disable horizontal scrolling */
    }


</style>


</head>
<form id="form2" runat="server">
    <div>
        <body style="background-color: #041d06">

            <!-- ======= Header ======= -->
            <%--#9ee2a0, #9ee2a0, #9ee2a0--%>
            <%--  <header style="background-image: linear-gradient(to right, #000000, #061f0d, #000000); height: 80px" id="header" class="header fixed-top d-flex align-items-center">--%>
            <header style="background-color: black; height: 80px" id="header" class="header fixed-top d-flex align-items-center">

                <div class="d-flex align-items-center justify-content-between">
                    <a href="WAREHOUSE_ADD_ITEM.aspx" class="logo d-flex align-items-center">
                        <img style="border-radius: 1px" src="Pictures/logo2.png" alt="" />
                        <span style="color: aqua; font-weight: 900; font-family: 'Agency FB'" class="d-none d-lg-block">PBC</span>
                    </a>
                    <i style="color: aqua" class="bi bi-list toggle-sidebar-btn"></i>
                </div>
                <!-- End Logo -->

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
>
                            </ul>
                            <!-- End Notification Dropdown Items -->

                        </li>
                        <!-- End Notification Nav -->

                        <li class="nav-item dropdown pe-3">

                            <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown" style="color: aqua">
                                <asp:ImageMap ID="profile_image" runat="server" alt="Profile" class="rounded-circle" Style="background-color: #053203"></asp:ImageMap>
                                <span style="color: aqua" class="d-none d-md-block dropdown-toggle ps-2">
                                    <asp:Label ID="Label2" runat="server" Text=""></asp:Label></span>
                            </a>
                            <!-- End Profile Image Icon -->

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
                            </ul>
                            <!-- End Profile Dropdown Items -->
                        </li>
                        <!-- End Profile Nav -->

                    </ul>
                </nav>
                <!-- End Icons Navigation -->

            </header>
            <!-- End Header -->

            <!-- ======= Sidebar ======= -->
            <aside style="padding-top: 50px" id="sidebar" class="sidebar">
            <ul class="sidebar-nav" id="sidebar-nav">

                <li class="nav-item">
                    <a class="nav-link <% if (Request.Url.AbsolutePath.EndsWith("Dispatcher_Dashboard.aspx")) { %> active <% } %>" href="Dispatcher_Dashboard.aspx">
                        <i class="bi bi-grid" style="color: aquamarine"></i>
                        <span style="color: aquamarine">Dashboard</span>
                    </a>
                </li>
                <!-- End Employee Nav -->
                    <li class="nav-item">
                        <a class="nav-link <% if (Request.Url.AbsolutePath.EndsWith("OD_manage.aspx") || Request.Url.AbsolutePath.EndsWith("Re_AssignVehicle.aspx")) { %> active <% } %>" data-bs-target="#forms-nav" data-bs-toggle="collapse" href="#">
                            <i class="bi bi-people"></i><span>Manage Actions</span><i class="bi bi-chevron-down ms-auto"></i>
                        </a>
                        <ul id="forms-nav" class="nav-content collapse <% if (Request.Url.AbsolutePath.EndsWith("OD_manage.aspx") || Request.Url.AbsolutePath.EndsWith("Re_AssignVehicle.aspx")) { %> show <% } %>" data-bs-parent="#sidebar-nav">
                            <li>
                                <a class="<% if (Request.Url.AbsolutePath.EndsWith("OD_manage.aspx")) { %> active <% } %>" href="OD_manage.aspx">
                                    <i class="bi bi-circle"></i><span>Manage Vehicle and Haulers</span>
                                </a>
                            </li>
                            <li>
                                <a class="<% if (Request.Url.AbsolutePath.EndsWith("Re_AssignVehicle.aspx")) { %> active <% } %>" href="Re_AssignVehicle.aspx">
                                    <i class="bi bi-circle"></i><span>Assigns and Controls</span>
                                </a>
                            </li>
                            <li>
                                <a class="<% if (Request.Url.AbsolutePath.EndsWith("Dispatcher_AddSlip.aspx")) { %> active <% } %>" href="Dispatcher_AddSlip.aspx">
                                    <i class="bi bi-circle"></i><span>Manage Truck Scale Slip</span>
                                </a>
                            </li>
                        </ul>
                    </li>


            </ul>
        </aside>

            <!-- End Sidebar-->

            <main id="main" class="main">

                <div class="pagetitle">
                    <h1 style="padding-top: 20px; color: chartreuse; font-size: 24px;" >Operational Dispatcher</h1>
                    <nav>
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="WAREHOUSE_DASHBOARD.aspx" style="font-size: 18px;">Management</a></li>
                            <%--<li class="breadcrumb-item">Add Item</li>--%>
                        </ol>
                    </nav>
                </div>
                <!-- End Page Title -->

                <section class="section dashboard">
                    <div class="row">

                        <!-- Left side columns -->
                        <div class="col-lg-8">
                            <div class="row">
                            </div>
                        </div>
                        <!-- End Left side columns -->

                        <!-- Right side columns -->
                        <div class="col-lg-4">
                        </div>
                        <!-- End Right side columns -->

                    </div>
                </section>
                   <!-- Start General Form Elements -->
                    <%--#043002--%>
                    <section style="background-color: #052507; padding: 50px; border-radius: 8px; box-shadow: 0 0 5px rgba(0, 0, 0, .2)">
                        <section class="section dashboard">
                            <div class="row" style="padding: 20px;">
                                <!-- Left side columns -->
                                <div class="col-lg-12">
                                    <div class="row">

                                        <!-- Haulers Card -->
                                        <div class="col-lg-6" style="background-color: #052507">
                                            <div class="card info-card sales-card" style="background-color: #052507">
                                                <div class="card-body" style="background-color: #053203; border-radius: 15px">
                                                    <h5 class="card-title" style="color: chartreuse">Total Haulers</h5>
                                                    <div class="d-flex align-items-center">
                                                        <div class="card-icon rounded-circle d-flex align-items-center justify-content-center" style="background-color: #053203">
                                                            <i class="bi bi-people" style="color: #cb3ee4;"></i>
                                                        </div>
                                                        <div class="ps-3" style="background-color: #053203">
                                                            <h6>
                                                                <asp:Label ID="totalhauler" runat="server" CssClass="form-control" ReadOnly="true" Style="background-color: transparent; color: aquamarine; font-size: 40px; font-weight: 800"></asp:Label>
                                                            </h6>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- End Haulers Card -->

                                        <!-- Vehicles Card -->
                                        <div class="col-lg-6" style="background-color: #052507">
                                            <div class="card info-card sales-card" style="background-color: #052507">
                                                <div class="card-body" style="background-color: #053203; border-radius: 15px">
                                                    <h5 class="card-title" style="color: chartreuse">Total Vehicles</h5>
                                                    <div class="d-flex align-items-center">
                                                        <div class="card-icon rounded-circle d-flex align-items-center justify-content-center" style="background-color: #053203">
                                                            <i class="bi bi-truck" style="color: #cb3ee4;"></i>
                                                        </div>
                                                        <div class="ps-3" style="background-color: #053203">
                                                            <h6>
                                                                <asp:Label ID="totalvehicle" runat="server" CssClass="form-control" ReadOnly="true" Style="background-color: transparent; color: aquamarine; font-size: 40px; font-weight: 800"></asp:Label>
                                                            </h6>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                             <!-- End Vehicles Card -->

                         <!-- Start Vehicles Pie Chart -->
                            <div class="col-lg-12" style="padding: 20px; border-radius: 15px;">
                                <div class="card-body" style="background-color: #053203; border-radius: 15px; padding: 20px;">
                                    <h5 class="card-title" style="color: chartreuse; text-align: left; font-size: 24px;">Vehicle Availability</h5>

                                    <!-- Container for Chart and Legends -->
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; position: relative;">
                                        <!-- Centered Pie Chart -->
                                        <div style="flex: 1; display: flex; justify-content: center;">
                                            <canvas id="vehicleAvailabilityChart" style="max-width: 400px; max-height: 400px;"></canvas>
                                        </div>
                                        <!-- Legends in Upper Right Corner -->
                                        <div style="position: absolute; top: 10px; right: 10px; color: chartreuse; font-size: 14px; text-align: right;">
                                            <ul id="chartLegend" class="list-unstyled" style="list-style: none;">
                                                <li><span style="color: #ff6384; font-size: 24px;">●</span> Siphoning</li>
                                                <li><span style="color: #36a2eb; font-size: 24px;">●</span> Rear Loader</li>
                                                <li><span style="color: #ffce56; font-size: 24px;">●</span> Mini Dump Truck</li>
                                                <li><span style="color: #90EE90; font-size: 24px;">●</span> Compactor Truck</li>
                                            </ul>
                                        </div>
                                    </div>

                                    <!-- Vehicle Availability Summary positioned in the bottom left corner below the pie chart -->
                                    <div id="vehicleSummary" style="margin-top: 20px; text-align: left; font-size: 18px; color: aquamarine;">
                                    <p>Available Siphoning: <span id="availableSiphoning" class="count" style= "font-size: 20px;">0</span></p>
                                    <p>Available Rear Loader Garbage Truck: <span id="availableRearLoader" class="count" style=" font-size: 20px;">0</span></p>
                                    <p>Available Mini Dump Truck: <span id="availableMiniDump" class="count" style=" font-size: 20px;">0</span></p>
                                    <p>Available Compactor Truck: <span id="availableCompactor" class="count" style=" font-size: 20px;">0</span></p>
                                </div>
                                </div>
                            </div>
                            <!-- End Vehicles Pie Chart -->
                       <!-- Start Image Buttons for Lists -->
                        <div class="image-buttons-container" style="display: flex; gap: 25px; justify-content: center; margin-top: 30px;">

                            <!-- Container for List of Haulers -->
                            <div style="width: 420px; height: 130px; background-color: #053203; border-radius: 15px; display: flex; flex-direction: column; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);" onclick="imgBtnHauler_Click();">
                                <asp:ImageButton ID="imgBtnHauler" runat="server" ImageUrl="~/Pictures/driver.png"
                                                 OnClick="imgBtnHauler_Click" 
                                                 style="width: 70px; height: 70px; background: none; border: none;" />
                                <div style="color: white;">View Hauler List</div>
                            </div>

                            <!-- Container for List of Dispatchers -->
                            <div style="width: 420px; height: 130px; background-color: #053203; border-radius: 15px; display: flex; flex-direction: column; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);" onclick="imgBtnDispatcher_Click();">
                                <asp:ImageButton ID="imgBtnDispatcher" runat="server" ImageUrl="~/Pictures/working_man.png"
                                                 OnClick="imgBtnDispatcher_Click" 
                                                 style="width: 70px; height: 70px; background: none; border: none;" />
                                <div style="color: white;">View Dispatcher List</div>
                            </div>

                            <!-- Container for List of Customers -->
                            <div style="width: 420px; height: 130px; background-color: #053203; border-radius: 15px; display: flex; flex-direction: column; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);" onclick="imgBtnCustomer_Click();">
                                <asp:ImageButton ID="imgBtnCustomer" runat="server" ImageUrl="~/Pictures/customer.png"
                                                 OnClick="imgBtnCustomer_Click" 
                                                 style="width: 70px; height: 70px; background: none; border: none;" />
                                <div style="color: white;">View Customer List</div>
                            </div>

                        </div>
                        <!-- End Image Buttons for Lists -->

                <!-- Modal for List of Dispatchers -->
                <asp:LinkButton ID="LinkButton1" runat="server"  OnClick="LinkButton1_Click"></asp:LinkButton>
                 <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <asp:Panel ID="updatePanel" CssClass="card shadow-lg scrollable-panel" runat="server"
                    Style="background-color: #052507; border: 1px solid aquamarine; border-radius: 8px; width: 100%; max-width: 1500px; margin: auto;">
                    <ContentTemplate>
                        <div class="gridview-container scrollable-grid" style="height: 600px; overflow-y: auto;">
                            <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed"
                                ID="gridViewDispatcher" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True"
                                DataKeyNames="emp_id" AllowPaging="False" CellPadding="20" GridLines="None">
                                <HeaderStyle BackColor="#f8f9fa" ForeColor="#343a40" Font-Bold="True" />
                                <Columns>
                                    <asp:BoundField DataField="emp_id" HeaderText="Employee ID" ReadOnly="True">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_name" HeaderText="Names">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_contact" HeaderText="Contact">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_address" HeaderText="Address">
                                        <ItemStyle Width="200px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_profile" HeaderText="Profile">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_status" HeaderText="Status">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="card-footer" style="background-color: #052507; color: aquamarine; text-align: right;">
                            <asp:Button ID="btnclose" CssClass="btn btn-secondary" runat="server" Text="Close" OnClick="btnClose_Click" />
                        </div>
                    </ContentTemplate>
                </asp:Panel>

                <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server"
                    CancelControlID="btnclose" PopupControlID="updatePanel" TargetControlID="LinkButton1"
                    BackgroundCssClass="Background" DropShadow="True">
                </ajaxToolkit:ModalPopupExtender>

                <!-- Modal for List of Haulers -->
                <asp:LinkButton ID="LinkButton2" runat="server" Toolkit="View Hauler List" OnClick="LinkButton2_Click"></asp:LinkButton>

                <asp:Panel ID="Panel1" CssClass="card shadow-lg scrollable-panel" runat="server"
                    Style="background-color: #052507; border: 1px solid aquamarine; border-radius: 8px; width: 100%; max-width: 1500px; margin: auto;">
                    <ContentTemplate>
                        <div class="gridview-container scrollable-grid" style="height: 600px; overflow-y: auto;">
                            <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed"
                                ID="gridViewHauler" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True"
                                DataKeyNames="emp_id" AllowPaging="False" CellPadding="20" GridLines="None">
                                <HeaderStyle BackColor="#f8f9fa" ForeColor="#343a40" Font-Bold="True" />
                                <Columns>
                                    <asp:BoundField DataField="emp_id" HeaderText="Employee ID" ReadOnly="True">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_name" HeaderText="Names">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_contact" HeaderText="Contact">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_address" HeaderText="Address">
                                        <ItemStyle Width="200px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_profile" HeaderText="Profile">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_status" HeaderText="Status">
                                        <ItemStyle Width="100px" ForeColor="cyan" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="card-footer" style="background-color: #052507; color: aquamarine; text-align: right;">
                            <asp:Button ID="btnclose1" CssClass="btn btn-secondary" runat="server" Text="Close" OnClick="btnClose1_Click" />
                        </div>
                    </ContentTemplate>
                </asp:Panel>

                <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server"
                    CancelControlID="btnclose1" PopupControlID="Panel1" TargetControlID="LinkButton2"
                    BackgroundCssClass="Background" DropShadow="True">
                </ajaxToolkit:ModalPopupExtender>
                        <!-- Modal for List of Customers -->
<asp:LinkButton ID="LinkButton3" runat="server" Toolkit="View Hauler List" OnClick="LinkButton3_Click"></asp:LinkButton>

<asp:Panel ID="Panel2" CssClass="card shadow-lg scrollable-panel" runat="server"
    Style="background-color: #052507; border: 1px solid aquamarine; border-radius: 8px; width: 100%; max-width: 1500px; margin: auto;">
    <ContentTemplate>
        <div class="gridview-container scrollable-grid" style="height: 600px; overflow-y: auto;">
            <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed"
                ID="gridViewCustomer" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True"
                DataKeyNames="cus_id" AllowPaging="False" CellPadding="20" GridLines="None">
                <HeaderStyle BackColor="#f8f9fa" ForeColor="#343a40" Font-Bold="True" />
                <Columns>
                    <asp:BoundField DataField="cus_id" HeaderText="Employee ID" ReadOnly="True">
                        <ItemStyle Width="100px" ForeColor="cyan" />
                    </asp:BoundField>
                    <asp:BoundField DataField="cus_name" HeaderText="Names">
                        <ItemStyle Width="100px" ForeColor="cyan" />
                    </asp:BoundField>
                    <asp:BoundField DataField="cus_contact" HeaderText="Contact">
                        <ItemStyle Width="100px" ForeColor="cyan" />
                    </asp:BoundField>
                    <asp:BoundField DataField="cus_address" HeaderText="Address">
                        <ItemStyle Width="200px" ForeColor="cyan" />
                    </asp:BoundField>
                    <asp:BoundField DataField="cus_profile" HeaderText="Profile">
                        <ItemStyle Width="100px" ForeColor="cyan" />
                    </asp:BoundField>
                    <asp:BoundField DataField="cus_status" HeaderText="Status">
                        <ItemStyle Width="100px" ForeColor="cyan" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </div>
        <div class="card-footer" style="background-color: #052507; color: aquamarine; text-align: right;">
            <asp:Button ID="btnclose2" CssClass="btn btn-secondary" runat="server" Text="Close" OnClick="btnClose2_Click" />
        </div>
    </ContentTemplate>
</asp:Panel>

<ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender3" runat="server"
    CancelControlID="btnclose2" PopupControlID="Panel2" TargetControlID="LinkButton3"
    BackgroundCssClass="Background" DropShadow="True">
</ajaxToolkit:ModalPopupExtender>
              
            </section>
            <!-- End General Form Elements -->

            </main>
            <!-- End #main -->
           <script>
               let vehicleAvailabilityChart;

               function updatePieChart(siphoning, rearLoader, miniDump, compactor) {
                   const ctx = document.getElementById('vehicleAvailabilityChart').getContext('2d');

                   // Validate input data to prevent issues with the chart
                   const dataValues = [siphoning, rearLoader, miniDump, compactor];
                   if (dataValues.some(value => value < 0)) {
                       console.error("Invalid data: vehicle counts cannot be negative.");
                       return;
                   }

                   // Create a new chart
                   vehicleAvailabilityChart = new Chart(ctx, {
                       type: 'pie',
                       data: {
                           labels: ['Siphoning', 'Rear Loader', 'Mini Dump Truck', 'Compactor'],
                           datasets: [{
                               data: dataValues,
                               backgroundColor: [
                                   '#ff6384',  // Siphoning
                                   '#36a2eb',  // Rear Loader
                                   '#ffce56',  // Mini Dump Truck
                                   '#90EE90'   // Compactor
                               ],
                           }]
                       },
                       options: {
                           responsive: true,
                           maintainAspectRatio: false,
                           plugins: {
                               legend: {
                                   display: false,
                               }
                           }
                       }
                   });
                   // Update the availability text below the chart
                   document.getElementById('availableSiphoning').textContent = siphoning;
                   document.getElementById('availableRearLoader').textContent = rearLoader;
                   document.getElementById('availableMiniDump').textContent = miniDump;
                   document.getElementById('availableCompactor').textContent = compactor;
               }
           </script>

            <!-- ======= Footer ======= -->
            <footer id="footer" class="footer" style="border-top-color: chartreuse">
                <div class="copyright" style="color: #d4f3cf">
                    &copy; Copyright <strong><span style="color: #d4f3cf">Pinoy Basurero Corporation</span></strong>. All Rights Reserved
                </div>
            </footer>
            <!-- End Footer -->

            <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

            <!-- Vendor JS Files -->
            <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
            <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
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
