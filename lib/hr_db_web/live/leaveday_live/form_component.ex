defmodule HrDbWeb.LeavedayLive.FormComponent do
  use HrDbWeb, :live_component

  alias HrDb.Leavedays
  alias HrDb.Employees

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 bg-white rounded-lg shadow-md">
      <.header>
        <h2 class="text-2xl font-semibold text-gray-800">{@title}</h2>
        <:subtitle>Use this form to manage leaveday records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="leaveday-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <div class="grid grid-cols-2 gap-6">
          <!-- Employee selection -->
          <div class="flex items-center space-x-2">
            <.input field={@form[:employee_id]} type="select" label="Employee ID"prompt="choose your employee id " options={@employee_options} phx-change="employee_id_changed" class="w-full" />
          </div>
          <div class="flex items-center space-x-2">
            <.input field={@form[:name]} type="text" label="Name" value={@name} class="w-full" readonly />
          </div>
          <div class="flex items-center space-x-2">
            <.input field={@form[:phone_number]} type="text" label="Contact Information" value={@phone_number} class="w-full" readonly />
          </div>
          <div class="flex items-center space-x-2">
            <.input field={@form[:leave_days]} type="number" label="Leave days Remaining" value={@leave_days} class="w-full" readonly />
          </div>

          <!-- Start Date and End Date -->
          <div class="flex items-center space-x-2">
            <.input field={@form[:start_date]} type="date" label="Start date" phx-change="date_changed" class="w-full" />
          </div>
          <div class="flex items-center space-x-2">
            <.input field={@form[:end_date]} type="date" label="End date" phx-change="date_changed" class="w-full" />
          </div>

          <!-- Reason and Status -->

          <div class="flex items-center space-x-2">
          <.input field={@form[:leave_type]}
        type="select"
        label="Leave Type"
         options={["Sick Leave", "Annual Leave", "Compassionate Leave", "Maternity Leave", "Paternity Leave","Leave of absence"]}
          prompt="choose type of leave"
         />

          </div>
          <div class="flex items-center space-x-2">
            <.input field={@form[:reason]} type="text" label="Justification" class="w-full" />
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving..." class="bg-orange-500 text-white hover:bg-orange-600 focus:ring-4 focus:ring-orange-300">Save Leaveday</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{leaveday: leaveday} = assigns, socket) do
    employees = Employees.list_employee()

    employee_options = Enum.map(employees, fn employee -> {employee.employee_id, employee.employee_id} end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:employee_options, employee_options)
     |> assign(:name, "")
     |> assign(:phone_number, "")
     |> assign(:leave_days, "")
     |> assign_new(:form, fn ->
       to_form(Leavedays.change_leaveday(leaveday))
     end)}
  end


  @impl true
  def handle_event("employee_id_changed", %{"leaveday" => %{"employee_id" => employee_id}}, socket) do
    employee = Employees.get_employee_by_id(employee_id)

    full_name = "#{employee.first_name} #{employee.last_name}"
    phone_number = employee.phone_number
    leave_days = employee.leave_balance


    socket =
      socket
      |> assign(:employee, employee)
      |> assign(:name, full_name)
      |> assign(:phone_number, phone_number)
      |> assign(:leave_days, leave_days)

    changeset = socket.assigns.form.source
                |> Ecto.Changeset.change(%{name: full_name, phone_number: phone_number})

    {:noreply, assign(socket, form: to_form(changeset))}
  end



  @impl true
  def handle_event("date_changed", %{"leaveday" => leaveday_params}, socket) do
    start_date = Map.get(leaveday_params, "start_date")
    end_date = Map.get(leaveday_params, "end_date")

    IO.inspect(start_date, label: "Start Date")
    IO.inspect(end_date, label: "End Date")

    cond do
      start_date in [nil, ""] ->
        {:noreply, socket}

      start_date != "" ->
        case Date.from_iso8601(start_date) do
          {:ok, start_date} ->
            case end_date do
              "" ->
                {:noreply, socket}

              nil ->
                {:noreply, socket}

              _ ->
                case Date.from_iso8601(end_date) do
                  {:ok, end_date} ->

                    if Date.compare(start_date, end_date) == :gt do
                      IO.puts("Start date cannot be after end date")
                      {:noreply, socket}
                    else

                      days_taken = Date.diff(end_date, start_date)
                      new_leave_days = socket.assigns.leave_days - days_taken


                      new_leave_days = max(new_leave_days, 0)


                      changeset = socket.assigns.form.source
                                  |> Ecto.Changeset.change(%{leave_days: new_leave_days})

                      {:noreply, assign(socket, form: to_form(changeset), leave_days: new_leave_days)}
                    end

                  {:error, _} ->
                    {:noreply, socket}
                end
            end
          {:error, _} ->
            {:noreply, socket}
        end
    end
  end



  def handle_event("validate", %{"leaveday" => leaveday_params}, socket) do
    changeset = Leavedays.change_leaveday(socket.assigns.leaveday, leaveday_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"leaveday" => leaveday_params}, socket) do
    save_leaveday(socket, socket.assigns.action, leaveday_params)
  end

  defp save_leaveday(socket, :edit, leaveday_params) do
    case Leavedays.update_leaveday(socket.assigns.leaveday, leaveday_params) do
      {:ok, leaveday} ->
        notify_parent({:saved, leaveday})

        {:noreply,
         socket
         |> put_flash(:info, "Leaveday updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_leaveday(socket, :new, leaveday_params) do
    # Extract start date and end date from params
    start_date = Map.get(leaveday_params, "start_date")
    end_date = Map.get(leaveday_params, "end_date")
    employee_id = Map.get(leaveday_params, "employee_id")

    # Calculate the leave days if both start_date and end_date are present
    case {start_date, end_date} do
      {start_date, end_date} when start_date != "" and end_date != "" ->
        case {Date.from_iso8601(start_date), Date.from_iso8601(end_date)} do
          {{:ok, start_date}, {:ok, end_date}} ->

            if Date.compare(start_date, end_date) == :gt do
              IO.puts("Start date cannot be after end date")
              {:noreply, socket}
            else

              days_taken = Date.diff(end_date, start_date)
              new_leave_days = socket.assigns.leave_days - days_taken


              new_leave_days = max(new_leave_days, 0)


              leaveday_params = Map.put(leaveday_params, "leave_days", Integer.to_string(new_leave_days))


              case Leavedays.create_leaveday(leaveday_params) do
                {:ok, leaveday} ->

                  employee = Employees.get_employee_by_id(employee_id)
                  remaining_leave_balance = employee.leave_balance - days_taken


                  _updated_employee = Employees.update_leave_balance(employee, remaining_leave_balance)


                  _changeset = socket.assigns.form.source
                              |> Ecto.Changeset.change(%{leave_days: remaining_leave_balance})


                  notify_parent({:saved, leaveday})

                  {:noreply,
                   socket
                   |> assign(:leave_days, remaining_leave_balance)
                   |> put_flash(:info, "Leaveday created successfully")
                   |> push_patch(to: socket.assigns.patch)}

                {:error, %Ecto.Changeset{} = changeset} ->
                  {:noreply, assign(socket, form: to_form(changeset))}
              end
            end

          {:error, _} ->
            {:noreply, socket}
        end

      _ ->
        # If dates are invalid or not present, just proceed without leave days calculation
        case Leavedays.create_leaveday(leaveday_params) do
          {:ok, leaveday} ->
            # Notify parent with success
            notify_parent({:saved, leaveday})

            {:noreply,
             socket
             |> put_flash(:info, "Leaveday created successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end
    end
  end


  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
