defmodule HrDb.SupervisorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HrDb.Supervisors` context.
  """

  @doc """
  Generate a supervisor.
  """
  def supervisor_fixture(attrs \\ %{}) do
    {:ok, supervisor} =
      attrs
      |> Enum.into(%{
        active: "some active",
        department: "some department",
        supervisor_id: "some supervisor_id",
        supervisor_name: "some supervisor_name"
      })
      |> HrDb.Supervisors.create_supervisor()

    supervisor
  end
end
