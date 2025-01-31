defmodule HrDbWeb.JobLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Jobs
  alias HrDb.Jobs.Job

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :jobs, Jobs.list_job())}
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
    |> assign(jobs_count: Jobs.count_job())
    |> apply_action(socket.assigns.live_action, params)}

  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Job")
    |> assign(:job, Jobs.get_job!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Job")
    |> assign(:job, %Job{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Job")
    |> assign(:job, nil)
  end

  @impl true
  def handle_info({HrDbWeb.JobLive.FormComponent, {:saved, job}}, socket) do
    {:noreply, stream_insert(socket, :jobs, job)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    job = Jobs.get_job!(id)
    {:ok, _} = Jobs.delete_job(job)

    {:noreply, stream_delete(socket, :jobs, job)}
  end
  @impl true
  def handle_event("search", %{"search" => search_term}, socket) do
    options = socket.assigns.options
    IO.inspect(options, label: "options")

    query =
      if String.trim(search_term) != "" do
        Jobs.get_search_results(search_term, options)
      else
        Jobs.list_job(options)
      end

    {:noreply,
     socket
     |> stream(:jobs, query, reset: true)
     |> assign(jobs_count: Jobs.count_job_query(search_term, options))}
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
     |> assign(:page_title, "Jobs")
     |> assign(options: options)
     |> stream(:jobs, Jobs.list_job(options), reset: true)
     |> assign(jobs_count: Jobs.count_job())}
  end
  @impl true
  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: ~p"/job?#{params}")

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
    <.link patch={~p"/job?#{@params}"}>
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

  defp more_pages?(options, jobs_count) do
    options.page * options.per_page < jobs_count
  end

  defp pages(options, jobs_count) do
    page_count = ceil(jobs_count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2),
        page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end

end
