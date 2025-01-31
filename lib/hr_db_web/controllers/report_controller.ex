defmodule HrDbWeb.ReportController do
  use HrDbWeb, :controller
  alias HrDb.Leavedays
  alias HrDb.Employees
  alias HrDb.Supervisors
  alias HrDb.Jobs


  def download_leavedays_report(conn, %{"format" => format}) do
    leavedays = Leavedays.list_leaveday()

    case format do
      "csv" ->
        csv_data = generate_leavedays_report_csv(leavedays)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"leavedays_report.csv\"")
        |> send_resp(200, csv_data)

      "pdf" ->
        pdf_data = generate_leavedays_report_pdf(leavedays)

        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"leavedays_report.pdf\"")
        |> send_resp(200, pdf_data)

      "png" ->
        png_data = generate_leavedays_report_png(leavedays)

        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("content-disposition", "attachment; filename=\"leavedays_report.png\"")
        |> send_resp(200, png_data)

      _ ->
        csv_data = generate_leavedays_report_csv(leavedays)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"leavedays_report.csv\"")
        |> send_resp(200, csv_data)
    end
  end



  def download_employees_report(conn, %{"format" => format}) do
    employees = Employees.list_employee()

    case format do
      "csv" ->
        csv_data = generate_employees_report_csv(employees)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"employees_report.csv\"")
        |> send_resp(200, csv_data)

      "pdf" ->
        pdf_data = generate_employees_report_pdf(employees)

        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"employees_report.pdf\"")
        |> send_resp(200, pdf_data)

      "png" ->
        png_data = generate_employees_report_png(employees)

        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("content-disposition", "attachment; filename=\"employees_report.png\"")
        |> send_resp(200, png_data)

      _ ->
        csv_data = generate_employees_report_csv(employees)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"employees_report.csv\"")
        |> send_resp(200, csv_data)
    end
  end


  def download_supervisors_report(conn, %{"format" => format}) do
    supervisors = Supervisors.list_supervisor()

    case format do
      "csv" ->
        csv_data = generate_supervisors_report_csv(supervisors)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"supervisors_report.csv\"")
        |> send_resp(200, csv_data)

      "pdf" ->
        pdf_data = generate_supervisors_report_pdf(supervisors)

        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"supervisors_report.pdf\"")
        |> send_resp(200, pdf_data)

      "png" ->
        png_data = generate_supervisors_report_png(supervisors)

        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("content-disposition", "attachment; filename=\"supervisors_report.png\"")
        |> send_resp(200, png_data)

      _ ->
        csv_data = generate_supervisors_report_csv(supervisors)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"supervisors_report.csv\"")
        |> send_resp(200, csv_data)
    end
  end


  def download_jobs_report(conn, %{"format" => format}) do
    jobs = Jobs.list_job()

    case format do
      "csv" ->
        csv_data = generate_jobs_report_csv(jobs)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"jobs_report.csv\"")
        |> send_resp(200, csv_data)

      "pdf" ->
        pdf_data = generate_jobs_report_pdf(jobs)

        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"jobs_report.pdf\"")
        |> send_resp(200, pdf_data)

      "png" ->
        png_data = generate_jobs_report_png(jobs)

        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("content-disposition", "attachment; filename=\"jobs_report.png\"")
        |> send_resp(200, png_data)

      _ ->
        csv_data = generate_jobs_report_csv(jobs)

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"jobs_report.csv\"")
        |> send_resp(200, csv_data)
    end
  end




  defp generate_leavedays_report_csv(leavedays) do
    headers = ["Name", "Phone", "Employee ID", "Leave Days", "Start Date", "End Date", "Reason", "Type of Leave", "Status", "Approved By"]

    rows =
      Enum.map(leavedays, fn leaveday ->
        [
          leaveday.name,
          leaveday.phone_number,
          leaveday.employee_id,
          leaveday.leave_days,
          leaveday.start_date,
          leaveday.end_date,
          leaveday.reason,
          leaveday.leave_type,
          leaveday.status,
          leaveday.approved_by

        ]
      end)

   leavedays_data = [headers | rows]

    # Encode as CSV and return
    leavedays_data
    |> CSV.encode()
    |> Enum.to_list()
    |> IO.iodata_to_binary()
  end

  defp generate_leavedays_report_pdf(leavedays) do
    html_content = """
    <html>
    <head>
      <title>Leavedays Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Leavedays Report</h1>
      <table>
    <thead>

          <tr>
            <th>Name</th>
            <th>Phone</th>
            <th>Employee ID</th>
            <th>Leave Days</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Reason</th>
            <th>Leave Type</th>
            <th>Status</th>
            <th>Approved by</th>
          </tr>
        </thead>
        <tbody>
           #{Enum.map(leavedays, fn leaveday->


        """
            <tr>

               <td>#{leaveday.name}</td>
                <td>#{leaveday.phone_number}</td>
                 <td>#{leaveday.employee_id}</td>
                  <td>#{leaveday.leave_days}</td>
                   <td>#{leaveday.start_date}</td>
                    <td>#{leaveday.end_date}</td>
                      <td>#{leaveday.reason}</td>
                   <td>#{leaveday.leave_type}</td>
                    <td>#{leaveday.status}</td>
                    <td>#{leaveday.approved_by}</td>

            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    {:ok, pdf_content} = PdfGenerator.generate_binary(html_content)
    pdf_content
  end

  defp generate_leavedays_report_png(leavedays) do
    html_content = """
    <html>
    <head>
      <title>Leavedays Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Leavedays Report</h1>
      <table>
        <thead>
         <tr>
            <th>Name</th>
            <th>Phone</th>
            <th>Employee ID</th>
            <th>Leave Days</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Reason</th>
            <th>Leave Type</th>
            <th>Status</th>
            <th>Approved by</th>
          </tr>
        </thead>
       <tbody>
           #{Enum.map(leavedays, fn leaveday->


        """
            <tr>

               <td>#{leaveday.name}</td>
                <td>#{leaveday.phone_number}</td>
                 <td>#{leaveday.employee_id}</td>
                  <td>#{leaveday.leave_days}</td>
                   <td>#{leaveday.start_date}</td>
                    <td>#{leaveday.end_date}</td>
                      <td>#{leaveday.reason}</td>
                   <td>#{leaveday.leave_type}</td>
                    <td>#{leaveday.status}</td>
                    <td>#{leaveday.approved_by}</td>

            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    File.write!("/tmp/leavedays_report.html", html_content)
    System.cmd("wkhtmltoimage", ["/tmp/leavedays_report.html", "/tmp/leavedays_report.png"])

    File.read!("/tmp/leavedays_report.png")
  end





  defp generate_employees_report_csv(employees) do
    headers = ["First Name","Last Name", "Email", "Phone", "Employee ID", "Job Title", "Department", "Address", "Supervisor", "Birth Date", "Gender", "ID No", "Salary", "KRA","SHIF","NSSF","Bank Account", "Active"]

    rows =
      Enum.map(employees, fn employee ->
        [
          employee.first_name,
          employee.last_name,
          employee.email,
          employee.phone_number,
          employee.employee_id,
          employee.job_title,
          employee.department,
          employee.address,
          employee.supervisor,
          employee.dob,
          employee.gender,
          employee.id_number,
          employee.salary,
          employee.kra,
          employee.shif,
          employee.nssf,
       employee.bank_account,
          employee.active


        ]
      end)

   employeess_data = [headers | rows]

    # Encode as CSV and return
    employeess_data
    |> CSV.encode()
    |> Enum.to_list()
    |> IO.iodata_to_binary()
  end

  defp generate_employees_report_pdf(employees) do
    html_content = """
    <html>
    <head>
      <title>Employees Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Employees Report</h1>
      <table>
    <thead>

          <tr>
            <th>First Name</th>
            <th>Last Name</th>

            <th>Email</th>
            <th>Phone</th>
            <th>Employee ID</th>
            <th>Job Title</th>
            <th>Department</th>
            <th>Address</th>
            <th>Supervisor</th>
            <th>Birth Date</th>
            <th>Gender</th>
            <th>ID no</th>
            <th>Salary</th>
            <th>KRA</th>


            <th>Active</th>
          </tr>
        </thead>
        <tbody>
           #{Enum.map(employees, fn employee->


        """
            <tr>

               <td>#{employee.first_name}</td>
                <td>#{employee.last_name}</td>

                <td>#{employee.email}</td>
                <td>#{employee.phone_number}</td>
                  <td>#{employee.employee_id}</td>
                <td>#{employee.job_title}</td>
                  <td>#{employee.department}</td>
                <td>#{employee.address}</td>
                  <td>#{employee.supervisor}</td>
                <td>#{employee.dob}</td>
                  <td>#{employee.gender}</td>
                <td>#{employee.id_number}</td>
                  <td>#{employee.salary}</td>
                <td>#{employee.kra}</td>

                <td>#{employee.active}</td>



            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    {:ok, pdf_content} = PdfGenerator.generate_binary(html_content)
    pdf_content
  end

  defp generate_employees_report_png(employees) do
    html_content = """
    <html>
    <head>
      <title>Employees Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Employees Report</h1>
      <table>
        <thead>
         <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Other Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Employee ID</th>
            <th>Job Title</th>
            <th>Department</th>
            <th>Address</th>
            <th>Supervisor</th>
            <th>Birth Date</th>
            <th>Gender</th>
            <th>ID no</th>
            <th>Salary</th>
            <th>KRA</th>
            <th>SHIF</th>
            <th>NSSF</th>
            <th>Bank Account</th>
            <th>Active</th>
          </tr>
        </thead>
       <tbody>
           #{Enum.map(employees, fn employee->


        """
            <tr>

               <td>#{employee.first_name}</td>
                <td>#{employee.last_name}</td>
                  <td>#{employee.other_names}</td>
                <td>#{employee.email}</td>
                <td>#{employee.phone_number}</td>
                  <td>#{employee.employee_id}</td>
                <td>#{employee.job_title}</td>
                  <td>#{employee.department}</td>
                <td>#{employee.address}</td>
                  <td>#{employee.supervisor}</td>
                <td>#{employee.dob}</td>
                  <td>#{employee.gender}</td>
                <td>#{employee.id_number}</td>
                  <td>#{employee.salary}</td>
                <td>#{employee.kra}</td>
                  <td>#{employee.shif}</td>
                <td>#{employee.nssf}</td>
                  <td>#{employee.bank_account}</td>
                <td>#{employee.active}</td>



            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    File.write!("/tmp/employees_report.html", html_content)
    System.cmd("wkhtmltoimage", ["/tmp/employees_report.html", "/tmp/employees_report.png"])

    File.read!("/tmp/employees_report.png")
  end




  defp generate_supervisors_report_csv(supervisors) do
    headers = ["Name","Supervisor ID", "Job Title", "Department", "Active"]

    rows =
      Enum.map(supervisors, fn supervisor ->
        [
          supervisor.supervisor_name,
          supervisor.supervisor_id,
          supervisor.job_title,
          supervisor.department,
          supervisor.active


        ]
      end)

   supervisors_data = [headers | rows]

    # Encode as CSV and return
    supervisors_data
    |> CSV.encode()
    |> Enum.to_list()
    |> IO.iodata_to_binary()
  end

  defp generate_supervisors_report_pdf(supervisors) do
    html_content = """
    <html>
    <head>
      <title>Supervisors Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Supervisors Report</h1>
      <table>
    <thead>

          <tr>
            <th>Name</th>
            <th>Supervisor ID</th>
            <th>Job Title</th>
            <th>Department</th>
            <th>Active</th>

          </tr>
        </thead>
        <tbody>
           #{Enum.map(supervisors, fn supervisor->


        """
            <tr>

               <td>#{supervisor.supervisor_name}</td>
                 <td>#{supervisor.supervisor_id}</td>
                  <td>#{supervisor.job_title}</td>
                   <td>#{supervisor.department}</td>
                    <td>#{supervisor.active}</td>


            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    {:ok, pdf_content} = PdfGenerator.generate_binary(html_content)
    pdf_content
  end

  defp generate_supervisors_report_png(supervisors) do
    html_content = """
    <html>
    <head>
      <title>Supervisors Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Supervisors Report</h1>
      <table>
        <thead>
        <tr>
            <th>Name</th>
            <th>Supervisor ID</th>
            <th>Job Title</th>
            <th>Department</th>
            <th>Active</th>

          </tr>
        </thead>
        <tbody>
           #{Enum.map(supervisors, fn supervisor->


        """
            <tr>

               <td>#{supervisor.supervisor_name}</td>
                 <td>#{supervisor.supervisor_id}</td>
                  <td>#{supervisor.job_title}</td>
                   <td>#{supervisor.department}</td>
                    <td>#{supervisor.active}</td>


            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    File.write!("/tmp/supervisors_report.html", html_content)
    System.cmd("wkhtmltoimage", ["/tmp/supervisors_report.html", "/tmp/supervisors_report.png"])

    File.read!("/tmp/supervisors_report.png")
  end





  defp generate_jobs_report_csv(jobs) do
    headers = ["Job ID", "Title", "Department", "Active"]

    rows =
      Enum.map(jobs, fn job ->
        [
          job.job_id,
          job.title,
          job.department,
          job.active,


        ]
      end)

   jobs_data = [headers | rows]

    # Encode as CSV and return
    jobs_data
    |> CSV.encode()
    |> Enum.to_list()
    |> IO.iodata_to_binary()
  end

  defp generate_jobs_report_pdf(jobs) do
    html_content = """
    <html>
    <head>
      <title>Jobs Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Jobs Report</h1>
      <table>
    <thead>

          <tr>
            <th>Job ID</th>
            <th>Title</th>
            <th>Department</th>
            <th>Active</th>

          </tr>
        </thead>
        <tbody>
           #{Enum.map(jobs, fn job->


        """
            <tr>

               <td>#{job.job_id}</td>
                <td>#{job.title}</td>
                 <td>#{job.department}</td>
                  <td>#{job.active}</td>


            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    {:ok, pdf_content} = PdfGenerator.generate_binary(html_content)
    pdf_content
  end

  defp generate_jobs_report_png(jobs) do
    html_content = """
    <html>
    <head>
      <title>Jobs Report</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 20px;
        }
        h1 {
          color: #333;
          text-align: center;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
    <body>
      <h1>Jobs Report</h1>
      <table>
        <thead>
          <th>Job ID</th>
            <th>Title</th>
            <th>Department</th>
            <th>Active</th>

          </tr>
        </thead>
       <tbody>
           #{Enum.map(jobs, fn job->


        """
            <tr>

               <td>#{job.job_id}</td>
                <td>#{job.title}</td>
                 <td>#{job.department}</td>
                  <td>#{job.active}</td>


            </tr>
            """
          end) |> Enum.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
    """
    File.write!("/tmp/jobs_report.html", html_content)
    System.cmd("wkhtmltoimage", ["/tmp/jobs_report.html", "/tmp/jobs_report.png"])

    File.read!("/tmp/jobs_report.png")
  end

end
