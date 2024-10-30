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
    public partial class OD_manage : System.Web.UI.Page
    {
        private readonly string con = "Server=localhost;Port=5433;User Id=postgres;Password=123456;Database=trashtrack1";

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    Vehicle_TypeDDL(); // Call the method to populate the dropdown
            //}
            if (!IsPostBack)
            {
                LoadHaulers();
                Vehicle_TypeDDL();
                VehicleGridView();
                ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;


            }
        }
        protected void btnSearch_Click(object sender, ImageClickEventArgs e)
        {
            string searchQuery = txtSearch.Value.Trim();

            // Call your method to filter the GridView based on the search query
            FilterGridView(searchQuery);
        }

        private void FilterGridView(string searchQuery)
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    // SQL query to filter based on vehicle ID or plate
                    cmd.CommandText = @"
                SELECT 
                    v.v_id, 
                    v.v_plate, 
                    vt.vtype_name, 
                    v.v_capacity, 
                    v.v_created_at, 
                    v.v_updated_at, 
                    v.driver_id
                FROM vehicle v
                INNER JOIN vehicle_type vt ON v.v_typeid = vt.vtype_id
                WHERE v.driver_id IS NULL
                AND (v.v_id::text ILIKE '%' || @searchQuery || '%' 
                OR v.v_plate ILIKE '%' || @searchQuery || '%')
                ORDER BY v.v_created_at DESC";

                    cmd.Parameters.AddWithValue("@searchQuery", searchQuery);

                    DataTable admin_datatable = new DataTable();
                    NpgsqlDataAdapter admin_sda = new NpgsqlDataAdapter(cmd);
                    admin_sda.Fill(admin_datatable);

                    gridViewDispatcher.DataSource = admin_datatable;
                    gridViewDispatcher.DataBind();
                }
            }
        }


        private void VehicleGridView()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    // Update the query to show vehicles that do not have a driver assigned (driver_id is NULL)
                    cmd.CommandText = @"
                SELECT 
                    v.v_id, 
                    v.v_plate, 
                    vt.vtype_name, 
                    v.v_capacity, 
                    v.v_created_at, 
                    v.v_updated_at, 
                    v.driver_id
                FROM vehicle v
                INNER JOIN vehicle_type vt ON v.v_typeid = vt.vtype_id
                WHERE v.v_status <> 'Unavailable' 
                and v.driver_id IS NULL  -- Only select vehicles without a driver assigned
                ORDER BY v.v_created_at DESC";  // Order by creation date, most recent first

                    DataTable admin_datatable = new DataTable();
                    NpgsqlDataAdapter admin_sda = new NpgsqlDataAdapter(cmd);
                    admin_sda.Fill(admin_datatable);

                    gridViewDispatcher.DataSource = admin_datatable;
                    gridViewDispatcher.DataBind();
                }
            }
        }

        private void Vehicle_TypeDDL()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT VTYPE_ID, VTYPE_NAME FROM VEHICLE_TYPE";
                    NpgsqlDataAdapter VehicleNameAdapter = new NpgsqlDataAdapter(cmd);
                    DataTable VehicleName = new DataTable();
                    VehicleNameAdapter.Fill(VehicleName);

                    vehicle_type_ddl.DataSource = VehicleName;
                    vehicle_type_ddl.DataTextField = "VTYPE_NAME";
                    vehicle_type_ddl.DataValueField = "VTYPE_ID";
                    vehicle_type_ddl.DataBind();

                    // Add a default item
                    vehicle_type_ddl.Items.Insert(0, new ListItem("Select Truck Category", "0"));
                }
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            int emp_id = 1007;  // Replace with dynamic employee ID if necessary
            string v_plate = vehicle_PLATES.Text.Trim(); // Trim whitespace
            string v_cap = vehicle_cap.Text.Trim(); // Trim whitespace
            string vehicleCapacityUnit = "TONS";    // Fixed value for vehicle capacity unit
            string v_type = vehicle_type_ddl.SelectedValue;

            // Validate inputs
            if (string.IsNullOrWhiteSpace(v_plate) || string.IsNullOrWhiteSpace(v_cap))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "swal", "Swal.fire('Error', 'Vehicle plate or vehicle capacity cannot be empty!', 'error');", true);
                return;
            }

            if (v_type == "0")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "swal", "Swal.fire('Error', 'Please select a valid vehicle type!', 'error');", true);
                return;
            }

            // Check if the plate number already exists
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var checkCmd = db.CreateCommand())
                {
                    checkCmd.CommandType = CommandType.Text;
                    checkCmd.CommandText = "SELECT COUNT(*) FROM VEHICLE WHERE V_PLATE = @v_plate";
                    checkCmd.Parameters.AddWithValue("@v_plate", v_plate);

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                    if (count > 0)
                    {
                        // Plate number already exists
                        ClientScript.RegisterStartupScript(this.GetType(), "swal", "Swal.fire('Warning', 'Vehicle plate number already exists!', 'warning');", true);
                        return;
                    }
                }

                // Proceed to insert the vehicle
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = @"
            INSERT INTO VEHICLE(V_PLATE, V_CAPACITY, V_CAPACITY_UNIT, V_TYPEID, EMP_ID)
            VALUES(@v_plate, @v_cap, @v_cap_unit, @v_typeid, @emp_id)";

                    cmd.Parameters.AddWithValue("@v_plate", v_plate);
                    cmd.Parameters.AddWithValue("@v_cap", Convert.ToInt32(v_cap));
                    cmd.Parameters.AddWithValue("@v_cap_unit", vehicleCapacityUnit);  // Always use 'TONS'
                    cmd.Parameters.AddWithValue("@v_typeid", Convert.ToInt32(v_type));
                    cmd.Parameters.AddWithValue("@emp_id", emp_id);

                    var ctr = cmd.ExecuteNonQuery();

                    if (ctr >= 1)
                    {
                        // Clear form fields
                        vehicle_PLATES.Text = "";
                        vehicle_cap.Text = "";
                        vehicle_type_ddl.SelectedIndex = 0;

                        // Show SweetAlert for successful registration
                        ClientScript.RegisterStartupScript(this.GetType(), "swal", "Swal.fire({title: 'Success', text: 'Vehicle Registered Successfully!', icon: 'success', confirmButtonColor: '#3085d6', cancelButtonColor: '#d33'});", true);

                        // Refresh the GridView to reflect changes
                        VehicleGridView();
                    }
                    else
                    {
                        // Handle failure case
                        ClientScript.RegisterStartupScript(this.GetType(), "swal", "Swal.fire('Error', 'Vehicle Registration Failed!', 'error');", true);
                    }
                }
            }
        }


        private void LoadHaulers()
        {
            // Clear existing items in the dropdown list
            ddlHauler.Items.Clear();

            // Example query to get hauler data from your employee table
            //string query = "SELECT emp_id, emp_fname, emp_mname, emp_lname FROM employee WHERE role_id = (SELECT role_id FROM roles WHERE role_name = 'Hauler')";
            string query = @"
            SELECT emp.emp_id, emp.emp_fname, emp.emp_mname, emp.emp_lname 
            FROM employee emp
            WHERE emp.role_id = 4  
            AND emp.emp_id NOT IN (SELECT v.driver_id FROM vehicle v WHERE v.driver_id IS NOT NULL)";
            using (NpgsqlConnection conn = new NpgsqlConnection(con))
            {
                conn.Open();
                using (NpgsqlCommand cmd = new NpgsqlCommand(query, conn))
                {
                    using (NpgsqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Concatenate first, middle, and last names to create the full name
                            string fullName = $"{reader["emp_fname"]} {reader["emp_mname"]} {reader["emp_lname"]}".Trim();

                            // Create a new list item for each hauler and add it to the dropdown list
                            ListItem item = new ListItem(fullName, reader["emp_id"].ToString());
                            ddlHauler.Items.Add(item);
                        }
                    }
                }
            }

            ddlHauler.Items.Insert(0, new ListItem("-- Select Hauler --", ""));
        }
        protected void btnAssignHauler_Click(object sender, EventArgs e)
        {
            int v_id = Convert.ToInt32(txtV_ID.Value);
            string selected_hauler = ddlHauler.SelectedValue;

            if (string.IsNullOrEmpty(selected_hauler))
            {
                // Show SweetAlert warning if no hauler is selected
                ScriptManager.RegisterStartupScript(this, GetType(), "showAlert",
                    "Swal.fire({ icon: 'warning', title: 'No hauler selected', text: 'Please select a hauler before assigning.', confirmButtonColor: '#3085d6' });",
                    true);
                return;
            }

            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = @"UPDATE VEHICLE SET 
                        DRIVER_ID = @driver_id, 
                        V_STATUS = 'Assigned',
                        DRIVER_DATE_ASSIGNED_AT = @driver_date_assigned, 
                        DRIVER_DATE_UPDATED_AT = @driver_date_updated 
                        WHERE V_ID = @v_id";

                    int driverId = Convert.ToInt32(selected_hauler);
                    cmd.Parameters.AddWithValue("@driver_id", driverId);
                    cmd.Parameters.AddWithValue("@v_id", v_id);
                    cmd.Parameters.AddWithValue("@driver_date_assigned", DateTime.Now);
                    cmd.Parameters.AddWithValue("@driver_date_updated", DateTime.Now);

                    var ctr = cmd.ExecuteNonQuery();

                    if (ctr >= 1)
                    {
                        // SweetAlert success message for successful assignment
                        ScriptManager.RegisterStartupScript(this, GetType(), "showAlert",
                            "Swal.fire({ icon: 'success', title: 'Hauler Assigned!', text: 'The hauler was successfully assigned.', background: '#e9f7ef', confirmButtonColor: '#28a745' });",
                            true);
                    }
                    else
                    {
                        // SweetAlert error message if assignment fails
                        ScriptManager.RegisterStartupScript(this, GetType(), "showAlert",
                            "Swal.fire({ icon: 'error', title: 'Assignment Failed', text: 'Unable to assign hauler. Please try again.', confirmButtonColor: '#d33' });",
                            true);
                    }
                }
            }

            VehicleGridView(); // Refresh GridView to reflect changes
        }


        private void DisplayVehicleName(int v_id)
        {
            try
            {
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "SELECT v_plate FROM VEHICLE WHERE v_id = @v_id";
                        cmd.Parameters.AddWithValue("@v_id", v_id); // Ensure this matches the parameter name in the SQL command

                        var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            txtbxVehiclePlate.Text = reader["v_plate"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                    "swal('Error!', '" + ex.Message + "', 'error')", true);
            }
        }

        protected void viewassignhauler_Click(object sender, EventArgs e)
        {
            // Cast the sender to LinkButton to get the button that was clicked
            LinkButton btn = sender as LinkButton;

            if (btn == null)
            {
                // Log or handle the case where the sender is not a LinkButton
                return;
            }

            // Check if CommandArgument is null
            if (btn.CommandArgument == null)
            {
                // Handle the case where CommandArgument is null
                return;
            }

            // Get the CommandArgument (which contains both vehicle ID and plate)
            string[] commandArgs = btn.CommandArgument.Split(';');

            // Ensure commandArgs has the expected number of elements
            if (commandArgs.Length < 2)
            {
                // Handle error: CommandArgument does not contain enough elements
                return;
            }

            // Parse vehicle ID and vehicle plate from commandArgs
            int vehicleId = Convert.ToInt32(commandArgs[0]); // Vehicle ID
            string vehiclePlate = commandArgs[1]; // Vehicle Plate
            txtV_ID.Value = vehicleId.ToString();
            // Set the Vehicle Plate in the textbox (disabled)
            txtbxVehiclePlate.Text = vehiclePlate; // Set the plate number in the textbox

            // Load haulers into the dropdown list
            LoadHaulers();

            // Show the modal popup
            ModalPopupExtender2.Show();
        }
    }
}
