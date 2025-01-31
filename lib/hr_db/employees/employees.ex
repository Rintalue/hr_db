defmodule HrDb.Employees do
  @moduledoc """
  The Employees context.
  """

  import Ecto.Query, warn: false
  alias HrDb.Repo

  alias HrDb.Employees.Employee

  @doc """
  Returns the list of employee.

  ## Examples

      iex> list_employee()
      [%Employee{}, ...]

  """
  def list_employee do
    Repo.all(Employee)
  end



  def list_employee(options) when is_map(options) do
    from(a in Employee)
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

  def count_employee do
    Repo.aggregate(Employee, :count, :id)
  end

  def get_search_results(search_term, options) do
    from(u in Employee,
      where:
        fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.employee_id, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.first_name, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.last_name, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.other_names, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.email, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.supervisor, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.gender, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.active, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.phone_number, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.address, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.id_number, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.job_title, ^"%#{search_term}%"),
          order_by: [{^options.sort_order, ^options.sort_by}]


          )

    |> paginate(options)
    |> Repo.all()
  end

  def count_employee_query(search_term, options) do
    from(u in Employee,
      where:
        fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.employee_id, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.first_name, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.last_name, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.other_names, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.email, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.supervisor, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.gender, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.active, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.phone_number, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.address, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.id_number, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.job_title, ^"%#{search_term}%"),
          order_by: [{^options.sort_order, ^options.sort_by}]
    )
    |> paginate(options)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  def get_employee_by_id(employee_id) do
    Repo.one(from e in Employee, where: e.employee_id == ^employee_id)
  end
  def update_leave_balance(%Employee{} = employee, new_leave_balance) do

    employee

    |> Employee.changeset(%{leave_balance: new_leave_balance})

    |> Repo.update()

  end

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{data: %Employee{}}

  """
  def change_employee(%Employee{} = employee, attrs \\ %{}) do
    Employee.changeset(employee, attrs)
  end
end
