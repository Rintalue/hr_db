defmodule HrDb.Leavedays do
  @moduledoc """
  The Leavedays context.
  """

  import Ecto.Query, warn: false
  alias HrDb.Repo

  alias HrDb.Leavedays.Leaveday

  @doc """
  Returns the list of leaveday.

  ## Examples

      iex> list_leaveday()
      [%Leaveday{}, ...]

  """
  def list_leaveday do
    Repo.all(Leaveday)
  end
  def approve_leaveday(leaveday_id) do
    case Repo.get(Leaveday, leaveday_id) do
      nil -> {:error, "Leaveday not found"}
      leaveday ->
        leaveday
        |> Leaveday.changeset(%{status: "approved"})
        |> Repo.update()
    end
  end

  def decline_leaveday(leaveday_id) do
    case Repo.get(Leaveday, leaveday_id) do
      nil -> {:error, "Leaveday not found"}
      leaveday ->
        leaveday
        |> Leaveday.changeset(%{status: "declined"})
        |> Repo.update()
    end
  end
  def list_pending_leavedays do
    Repo.all(from l in Leaveday, where: l.status == "pending")
  end



  def list_leaveday(options) when is_map(options) do
    from(a in Leaveday
    )
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

  def count_leaveday do
    Repo.aggregate(Leaveday, :count, :id)
  end

  def get_search_results(search_term, options) do
    from(u in Leaveday,
      where:
        fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.employee_id, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.name, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.leave_type, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.approved_by, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.leave_days, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.status, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.phone_number, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.reason, ^"%#{search_term}%"),
          order_by: [{^options.sort_order, ^options.sort_by}]


          )

    |> paginate(options)
    |> Repo.all()
  end

  def count_leaveday_query(search_term, options) do
    from(u in Leaveday,
    where:
    fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.employee_id, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.name, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.leave_type, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.approved_by, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.leave_days, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.status, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.phone_number, ^"%#{search_term}%") or
      fragment("? LIKE ?", u.reason, ^"%#{search_term}%"),
      order_by: [{^options.sort_order, ^options.sort_by}]


      )
    |> paginate(options)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single leaveday.

  Raises `Ecto.NoResultsError` if the Leaveday does not exist.

  ## Examples

      iex> get_leaveday!(123)
      %Leaveday{}

      iex> get_leaveday!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leaveday!(id), do: Repo.get!(Leaveday, id)

  @doc """
  Creates a leaveday.

  ## Examples

      iex> create_leaveday(%{field: value})
      {:ok, %Leaveday{}}

      iex> create_leaveday(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leaveday(attrs \\ %{}) do
    %Leaveday{}
    |> Leaveday.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leaveday.

  ## Examples

      iex> update_leaveday(leaveday, %{field: new_value})
      {:ok, %Leaveday{}}

      iex> update_leaveday(leaveday, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leaveday(%Leaveday{} = leaveday, attrs) do
    leaveday
    |> Leaveday.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leaveday.

  ## Examples

      iex> delete_leaveday(leaveday)
      {:ok, %Leaveday{}}

      iex> delete_leaveday(leaveday)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leaveday(%Leaveday{} = leaveday) do
    Repo.delete(leaveday)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leaveday changes.

  ## Examples

      iex> change_leaveday(leaveday)
      %Ecto.Changeset{data: %Leaveday{}}

  """
  def change_leaveday(%Leaveday{} = leaveday, attrs \\ %{}) do
    Leaveday.changeset(leaveday, attrs)
  end
end
