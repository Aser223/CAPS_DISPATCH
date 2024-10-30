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
    }
}

