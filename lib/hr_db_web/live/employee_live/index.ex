defmodule HrDbWeb.EmployeeLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Employees
  alias HrDb.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :employees, Employees.list_employee())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)

    page = param_to_integer(params["page"], 1)
    per_page = param_to_integer(params["per_page"], 25)

    options = %{
      sort_by: sort_by,
      sort_order: sort_order,
      page: page,
      per_page: per_page
    }
    {:noreply,
    socket
    |> assign(options: options)
    |> assign(employees_count: Employees.count_employee())
    |> apply_action(socket.assigns.live_action, params)}

  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Employee")
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Employee")
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Employee")
    |> assign(:employee, nil)
  end

  @impl true
  def handle_info({HrDbWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employees, employee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)

    {:noreply, stream_delete(socket, :employees, employee)}
  end
  @impl true
  def handle_event("search", %{"search" => search_term}, socket) do
    options = socket.assigns.options
    IO.inspect(options, label: "options")

    query =
      if String.trim(search_term) != "" do
        Employees.get_search_results(search_term, options)
      else
        Employees.list_employee(options)
      end

    {:noreply,
     socket
     |> stream(:employees, query, reset: true)
     |> assign(employees_count: Employees.count_employee_query(search_term, options))}
  end


  def handle_event("view_all", _params, socket) do
    params = %{}

    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)

    page = param_to_integer(params["page"], 1)
    per_page = param_to_integer(params["per_page"], 25)

    options = %{
      sort_by: sort_by,
      sort_order: sort_order,
      page: page,
      per_page: per_page
    }

    {:noreply,
     socket
     |> put_flash(:info, "Records resetted")
     |> assign(:page_title, "Employees")
     |> assign(options: options)
     |> stream(:employees, Employees.list_employee(options), reset: true)
     |> assign(employees_count: Employees.count_employee())}
  end
  @impl true
  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: ~p"/employee?#{params}")

    {:noreply, socket}
  end
  defp valid_sort_by(%{"sort_by" => sort_by})
       when sort_by in ~w(name description document date ) do
    String.to_atom(sort_by)
  end

  defp valid_sort_by(_params), do: :id

  defp valid_sort_order(%{"sort_order" => sort_order})
       when sort_order in ~w(asc desc) do
    String.to_atom(sort_order)
  end

  defp valid_sort_order(_params), do: :desc

  attr(:sort_by, :atom, required: true)
  attr(:options, :map, required: true)
  slot(:inner_block, required: true)

  def sort_link(assigns) do
    params = %{
      assigns.options
      | sort_by: assigns.sort_by,
        sort_order: next_sort_order(assigns.options.sort_order)
    }

    assigns = assign(assigns, :params, params)

    ~H"""
    <.link patch={~p"/employee?#{@params}"}>
      <%= render_slot(@inner_block) %>
      <%= sort_indicator(@sort_by, @options) %>
    </.link>
    """
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp sort_indicator(column, %{sort_by: sort_by, sort_order: sort_order})
       when column == sort_by do
    case sort_order do
      :asc -> "👆"
      :desc -> "👇"
    end
  end

  defp sort_indicator(_, _), do: ""



  defp param_to_integer(nil, default), do: default

  defp param_to_integer(param, default) do
    case Integer.parse(param) do
      {number, _} ->
        number

      :error ->
        default
    end
  end

  defp more_pages?(options, employees_count) do
    options.page * options.per_page < employees_count
  end

  defp pages(options, employees_count) do
    page_count = ceil(employees_count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2),
        page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end

end
