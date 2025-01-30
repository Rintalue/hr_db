defmodule HrDbWeb.EmployeeLive.FormComponent do
  use HrDbWeb, :live_component

  alias HrDb.Employees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage employee records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="employee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:employee_id]} type="text" label="Employee" />
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <.input field={@form[:other_names]} type="text" label="Other names" />
        <.input field={@form[:email]} type="text" label="Email" />

        <.input field={@form[:job_title]} type="select"  label="Choose Job Title" options={@jobs} prompt="choose job title" phx-change="job_title_changed" />
        <.input field={@form[:department]} type="text" label="Department" />

        <.input field={@form[:phone_number]} type="text" label="Phone number" />
        <.input field={@form[:address]} type="text" label="Address" />

        <.input field={@form[:supervisor]} type="select"  label="Choose Supervisor" options={@supervisors} prompt="choose your supervisor" />
        <.input field={@form[:dob]} type="date" label="Dob" />

        <.input
          field={@form[:gender]}
          type="select"
          label="Gender"
          options={["Male", "Female", "Prefer not to say", "Other"]}
          prompt="choose gender"
        />
        <.input field={@form[:id_number]} type="text" label="Id number" />
        <.input field={@form[:salary]} type="text" label="Salary" />
        <.input field={@form[:kra]} type="text" label="Kra" />
        <.input field={@form[:shif]} type="text" label="Shif" />
        <.input field={@form[:nssf]} type="text" label="Nssf" />
        <.input field={@form[:bank_account]} type="text" label="Bank account" />
        <.input field={@form[:active]}
        type="checkbox"
        label="Active"
        value="true"
        prompt="Choose status" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Employee</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{employee: employee} = assigns, socket) do\

  jobs = HrDb.Jobs.list_job()
  job_options = Enum.map(jobs, fn job-> {job.title, job.title} end)

  supervisors = HrDb.Supervisors.list_supervisor()
  supervisor_options = Enum.map(supervisors, fn supervisor-> {supervisor.supervisor_name, supervisor.supervisor_name}end)

  department = employee.department

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:jobs, job_options)
     |> assign(:supervisors, supervisor_options)
     |> assign(:department, department)
     |> assign_new(:form, fn ->
       to_form(Employees.change_employee(employee))
     end)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset = Employees.change_employee(socket.assigns.employee, employee_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    save_employee(socket, socket.assigns.action, employee_params)
  end
  @impl true
  def handle_event("job_title_changed", %{"employee" => %{"job_title" => job_title}}, socket) do
    case HrDb.Jobs.get_job_by_title(job_title) do
      nil -> {:noreply, socket} # Handle missing job
      job ->
        department = job.department
        changeset = socket.assigns.form.source
                    |> Ecto.Changeset.change(%{department: department})

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end


  defp save_employee(socket, :edit, employee_params) do
    case Employees.update_employee(socket.assigns.employee, employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Employees.create_employee(employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
