defmodule HrDb.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias HrDb.Repo

  alias HrDb.Jobs.Job

  @doc """
  Returns the list of job.

  ## Examples

      iex> list_job()
      [%Job{}, ...]

  """
  def list_job do
    Repo.all(Job)
  end



  def list_job(options) when is_map(options) do
    from(a in Job)
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

  def count_job do
    Repo.aggregate(Job, :count, :id)
  end

  def get_search_results(search_term, options) do
    from(u in Job,
      where:
        fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.job_id, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.title, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.active, ^"%#{search_term}%"),
          order_by: [{^options.sort_order, ^options.sort_by}]


          )

    |> paginate(options)
    |> Repo.all()
  end

  def count_job_query(search_term, options) do
    from(u in Job,
      where:
        fragment("? LIKE ?", u.inserted_at, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.job_id, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.title, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.department, ^"%#{search_term}%") or
          fragment("? LIKE ?", u.active, ^"%#{search_term}%"),
          order_by: [{^options.sort_order, ^options.sort_by}]


          )
    |> paginate(options)
    |> Repo.aggregate(:count, :id)
  end


  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id)

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end
  def get_job_id!(job_id) do
    HrDb.Repo.get_by!(HrDb.Jobs.Job, job_id: job_id)
  end
  def get_job_by_title(title) do
    Repo.get_by(Job, title: title)
  end


  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
