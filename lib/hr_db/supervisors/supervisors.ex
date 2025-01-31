defmodule HrDb.Supervisors do
  @moduledoc """
  The Supervisors context.
  """

  import Ecto.Query, warn: false
  alias HrDb.Repo

  alias HrDb.Supervisors.Supervisor

  @doc """
  Returns the list of supervisor.

  ## Examples

      iex> list_supervisor()
      [%Supervisor{}, ...]

  """
  def list_supervisor do
    Repo.all(Supervisor)
  end



  def list_supervisor(options) when is_map(options) do
    from(a in Supervisor)
    |> sort(options)
    |> paginate(options)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    order_by(query, {^sort_order, ^sort_by})
  end

  defp sort(query, _options), do: query

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  def count_supervisor do
    Repo.aggregate(Supervisor, :count, :id)
  end

  def get_search_results(search_term, options) do
    from(u in Supervisor,
    where:
    fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.supervisor_id, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.supervisor_name, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.active, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.job_title, ^"%#{search_term}%"),
      order_by: [{^options.sort_order, ^options.sort_by}]


      )

    |> paginate(options)
    |> Repo.all()
  end

  def count_supervisor_query(search_term, options) do
    from(u in Supervisor,
    where:
    fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.supervisor_id, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.supervisor_name, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.active, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.job_title, ^"%#{search_term}%"),
      order_by: [{^options.sort_order, ^options.sort_by}]


      )
    |> paginate(options)
    |> Repo.aggregate(:count, :id)
  end


  @doc """
  Gets a single supervisor.

  Raises `Ecto.NoResultsError` if the Supervisor does not exist.

  ## Examples

      iex> get_supervisor!(123)
      %Supervisor{}

      iex> get_supervisor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_supervisor!(id), do: Repo.get!(Supervisor, id)

  @doc """
  Creates a supervisor.

  ## Examples

      iex> create_supervisor(%{field: value})
      {:ok, %Supervisor{}}

      iex> create_supervisor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_supervisor(attrs \\ %{}) do
    %Supervisor{}
    |> Supervisor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a supervisor.

  ## Examples

      iex> update_supervisor(supervisor, %{field: new_value})
      {:ok, %Supervisor{}}

      iex> update_supervisor(supervisor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_supervisor(%Supervisor{} = supervisor, attrs) do
    supervisor
    |> Supervisor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a supervisor.

  ## Examples

      iex> delete_supervisor(supervisor)
      {:ok, %Supervisor{}}

      iex> delete_supervisor(supervisor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_supervisor(%Supervisor{} = supervisor) do
    Repo.delete(supervisor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking supervisor changes.

  ## Examples

      iex> change_supervisor(supervisor)
      %Ecto.Changeset{data: %Supervisor{}}

  """
  def change_supervisor(%Supervisor{} = supervisor, attrs \\ %{}) do
    Supervisor.changeset(supervisor, attrs)
  end
end
