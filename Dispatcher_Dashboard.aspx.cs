using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using Npgsql;
using System.Security.Cryptography;
using System.Text;
using System.Data;
using System.Text.Json;
using System.IO;
using System.Diagnostics;
using System.Net.Mail;
using System.Net;
using System.Xml.Linq;
using System.Web.UI.HtmlControls;
using AjaxControlToolkit;

namespace Capstone
{
    public partial class Dispatcher_Dashboard : System.Web.UI.Page
    {
        private readonly string con = "Server=localhost;Port=5433;User Id=postgres;Password=123456;Database=trashtrack1";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDashboardData();
                RetrieveVehicleAvailability();
                LoadDispatcherData();
                LoadHaulerData();
                LoadCustomerData();
            }
            else
            {
                // Update pie chart data every time the modal opens
                RetrieveVehicleAvailability();
            }
        }
        private void LoadDispatcherData()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();

                // Query to retrieve dispatcher data
                string dispatcherQuery = @"
                SELECT e.emp_id,
                       CONCAT(e.emp_fname, ' ', COALESCE(e.emp_mname, ''), ' ', e.emp_lname) AS emp_name,
                       e.emp_contact,
                       e.emp_address,
                       e.emp_profile,
                       e.emp_status
                FROM employee e
                WHERE e.role_id = 5;"; // Assuming role_id 5 corresponds to Dispatchers

                using (var cmd = new NpgsqlCommand(dispatcherQuery, db))
                using (var reader = cmd.ExecuteReader())
                {
                    var dispatcherTable = new DataTable();
                    dispatcherTable.Load(reader);
                    gridViewDispatcher.DataSource = dispatcherTable;
                    gridViewDispatcher.DataBind();
                }
            }
        }
       
        private void LoadHaulerData()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();

                // Query to retrieve dispatcher data
                string dispatcherQuery = @"
                SELECT e.emp_id,
                       CONCAT(e.emp_fname, ' ', COALESCE(e.emp_mname, ''), ' ', e.emp_lname) AS emp_name,
                       e.emp_contact,
                       e.emp_address,
                       e.emp_profile,
                       e.emp_status
                FROM employee e
                WHERE e.role_id = 4;"; // Assuming role_id 5 corresponds to Dispatchers

                using (var cmd = new NpgsqlCommand(dispatcherQuery, db))
                using (var reader = cmd.ExecuteReader())
                {
                    var dispatcherTable = new DataTable();
                    dispatcherTable.Load(reader);
                    gridViewHauler.DataSource = dispatcherTable;
                    gridViewHauler.DataBind();
                }
            }
        }
        private void LoadCustomerData()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();

                // Query to retrieve dispatcher data
                string dispatcherQuery = @"
                SELECT c.cus_id,
                       CONCAT(c.cus_fname, ' ', COALESCE(c.cus_mname, ''), ' ', c.cus_lname) AS cus_name,
                       c.cus_contact,
                       c.cus_address,
                       c.cus_profile,
                       c.cus_status
                FROM customer c;";

                using (var cmd = new NpgsqlCommand(dispatcherQuery, db))
                using (var reader = cmd.ExecuteReader())
                {
                    var dispatcherTable = new DataTable();
                    dispatcherTable.Load(reader);
                    gridViewCustomer.DataSource = dispatcherTable;
                    gridViewCustomer.DataBind();
                }
            }
        }

        private void BindDashboardData()
        {
            try
            {
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // Retrieve total haulers based on distinct driver_id in the vehicle table
                    using (var cmd = new NpgsqlCommand("SELECT COUNT(*) FROM employee WHERE role_id = 4", db))
                    {
                        int totalHaulers = Convert.ToInt32(cmd.ExecuteScalar());
                        totalhauler.Text = totalHaulers.ToString();
                    }

                    // Retrieve total vehicles based on v_id
                    using (var cmd = new NpgsqlCommand("SELECT COUNT(*) FROM vehicle", db)) // Count all v_id
                    {
                        int totalVehicles = Convert.ToInt32(cmd.ExecuteScalar());
                        totalvehicle.Text = totalVehicles.ToString();
                    }

                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
            }
        }

        private void RetrieveVehicleAvailability()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();

                // Prepare variables to hold counts
                int compactorCount = 0;
                int miniDumpCount = 0;
                int siphoningCount = 0;
                int rearLoaderCount = 0;

                // SQL query to count vehicles based on their v_typeid
                string query = @"
            SELECT 
                COUNT(CASE WHEN vehicle.v_typeid = 100 THEN 1 END) AS compactor,
                COUNT(CASE WHEN vehicle.v_typeid = 101 THEN 1 END) AS mini_dump,
                COUNT(CASE WHEN vehicle.v_typeid = 102 THEN 1 END) AS siphoning,
                COUNT(CASE WHEN vehicle.v_typeid = 103 THEN 1 END) AS rear_loader
            FROM vehicle;";

                using (var cmd = new NpgsqlCommand(query, db))
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Read counts from the query result
                        compactorCount = reader.GetInt32(0);
                        miniDumpCount = reader.GetInt32(1);
                        siphoningCount = reader.GetInt32(2);
                        rearLoaderCount = reader.GetInt32(3);
                    }
                }

                // Call the JavaScript function to update the pie chart
                string script = $"updatePieChart({siphoningCount}, {rearLoaderCount}, {miniDumpCount}, {compactorCount});";
                ClientScript.RegisterStartupScript(this.GetType(), "updateChart", script, true);
            }
        }
        protected void imgBtnDispatcher_Click(object sender, ImageClickEventArgs e)
        {
            LoadDispatcherData();
            ModalPopupExtender1.Show();
        }
        protected void imgBtnHauler_Click(object sender, ImageClickEventArgs e)
        {
            LoadHaulerData();
            ModalPopupExtender2.Show();
        }

        protected void imgBtnCustomer_Click(object sender, ImageClickEventArgs e)
        {
            LoadCustomerData();
            ModalPopupExtender3.Show();

        }
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            ModalPopupExtender3.Hide();
            ModalPopupExtender2.Hide();
            ModalPopupExtender1.Show();
            //RetrieveVehicleAvailability();
        }

        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            
            ModalPopupExtender1.Hide();
            ModalPopupExtender2.Show();
            ModalPopupExtender3.Hide();
            //RetrieveVehicleAvailability();

        }
        protected void LinkButton3_Click(object sender, EventArgs e)
        {

            ModalPopupExtender1.Hide();
            ModalPopupExtender2.Hide();
            ModalPopupExtender3.Show();
            //RetrieveVehicleAvailability();

        }



        protected void btnClose_Click(object sender, EventArgs e)
        {
            
            ModalPopupExtender1.Hide();
        }

        protected void btnClose1_Click(object sender, EventArgs e)
        {
           
            ModalPopupExtender2.Hide();
        }
        protected void btnClose2_Click(object sender, EventArgs e)
        {

            ModalPopupExtender3.Hide();
        }


    }
}

