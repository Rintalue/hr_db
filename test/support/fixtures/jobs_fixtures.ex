defmodule HrDb.JobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HrDb.Jobs` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(%{
        active: "some active",
        department: "some department",
        job_id: "some job_id",
        title: "some title"
      })
      |> HrDb.Jobs.create_job()

    job
  end
end
