defmodule HrDbWeb.HrDbWeb.Live.ApprovalLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Leavedays


  @impl true
  def mount(_params, _session, socket) do
    leavedays = Leavedays.list_pending_leavedays()
    {:ok, assign(socket, :leavedays, leavedays)}
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
    |> assign(leavedays_count: Leavedays.count_leaveday())
    |> apply_action(socket.assigns.live_action, params)}

  end
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Leavedays Approval")
    |> assign(:audit, nil)
  end

  def handle_event("approve", %{"id" => id}, socket) do
    case Leavedays.approve_leaveday(id) do
      {:ok, _leaveday} ->
        leavedays = Leavedays.list_pending_leavedays()
        {:noreply, assign(socket, :leavedays, leavedays)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end

  def handle_event("decline", %{"id" => id}, socket) do
    case Leavedays.decline_leaveday(id) do
      {:ok, _leaveday} ->
        leavedays = Leavedays.list_pending_leavedays()
        {:noreply, assign(socket, :leavedays, leavedays)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end


  @impl true
  def handle_event("search", %{"search" => search_term}, socket) do
    options = socket.assigns.options
    IO.inspect(options, label: "options")

    query =
      if String.trim(search_term) != "" do
        Leavedays.get_search_results(search_term, options)
      else
        Leavedays.list_leaveday(options)
      end

    {:noreply,
     socket
     |> stream(:leavedays, query, reset: true)
     |> assign(leavedays_count: Leavedays.count_leaveday_query(search_term, options))}
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
     |> assign(:page_title, "Leavedays Approval")
     |> assign(options: options)
     |> stream(:leavedays, Leavedays.list_leaveday(options), reset: true)
     |> assign(leavedays_count: Leavedays.count_leaveday())}
  end
  @impl true
  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: ~p"/approvals?#{params}")

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
    <.link patch={~p"/approvals?#{@params}"}>
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

  defp more_pages?(options, leavedays_count) do
    options.page * options.per_page < leavedays_count
  end

  defp pages(options, leavedays_count) do
    page_count = ceil(leavedays_count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2),
        page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end

end
