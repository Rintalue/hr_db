defmodule HrDb.JobsTest do
  use HrDb.DataCase

  alias HrDb.Jobs

  describe "job" do
    alias HrDb.Jobs.Job

    import HrDb.JobsFixtures

    @invalid_attrs %{active: nil, title: nil, job_id: nil, department: nil}

    test "list_job/0 returns all job" do
      job = job_fixture()
      assert Jobs.list_job() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{active: "some active", title: "some title", job_id: "some job_id", department: "some department"}

      assert {:ok, %Job{} = job} = Jobs.create_job(valid_attrs)
      assert job.active == "some active"
      assert job.title == "some title"
      assert job.job_id == "some job_id"
      assert job.department == "some department"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      update_attrs = %{active: "some updated active", title: "some updated title", job_id: "some updated job_id", department: "some updated department"}

      assert {:ok, %Job{} = job} = Jobs.update_job(job, update_attrs)
      assert job.active == "some updated active"
      assert job.title == "some updated title"
      assert job.job_id == "some updated job_id"
      assert job.department == "some updated department"
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job == Jobs.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
