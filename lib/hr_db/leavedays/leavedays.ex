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
