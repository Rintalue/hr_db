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
