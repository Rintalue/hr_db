defmodule HrDb.LeavedaysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HrDb.Leavedays` context.
  """

  @doc """
  Generate a leaveday.
  """
  def leaveday_fixture(attrs \\ %{}) do
    {:ok, leaveday} =
      attrs
      |> Enum.into(%{
        email: "some email",
        employee_id: "some employee_id",
        end_date: ~D[2025-01-27],
        first_name: "some first_name",
        last_name: "some last_name",
        leave_days: "some leave_days",
        phone_number: "some phone_number",
        reason: "some reason",
        start_date: ~D[2025-01-27],
        status: "some status"
      })
      |> HrDb.Leavedays.create_leaveday()

    leaveday
  end
end
