defmodule HrDb.SupervisorsTest do
  use HrDb.DataCase

  alias HrDb.Supervisors

  describe "supervisor" do
    alias HrDb.Supervisors.Supervisor

    import HrDb.SupervisorsFixtures

    @invalid_attrs %{active: nil, supervisor_id: nil, supervisor_name: nil, department: nil}

    test "list_supervisor/0 returns all supervisor" do
      supervisor = supervisor_fixture()
      assert Supervisors.list_supervisor() == [supervisor]
    end

    test "get_supervisor!/1 returns the supervisor with given id" do
      supervisor = supervisor_fixture()
      assert Supervisors.get_supervisor!(supervisor.id) == supervisor
    end

    test "create_supervisor/1 with valid data creates a supervisor" do
      valid_attrs = %{active: "some active", supervisor_id: "some supervisor_id", supervisor_name: "some supervisor_name", department: "some department"}

      assert {:ok, %Supervisor{} = supervisor} = Supervisors.create_supervisor(valid_attrs)
      assert supervisor.active == "some active"
      assert supervisor.supervisor_id == "some supervisor_id"
      assert supervisor.supervisor_name == "some supervisor_name"
      assert supervisor.department == "some department"
    end

    test "create_supervisor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Supervisors.create_supervisor(@invalid_attrs)
    end

    test "update_supervisor/2 with valid data updates the supervisor" do
      supervisor = supervisor_fixture()
      update_attrs = %{active: "some updated active", supervisor_id: "some updated supervisor_id", supervisor_name: "some updated supervisor_name", department: "some updated department"}

      assert {:ok, %Supervisor{} = supervisor} = Supervisors.update_supervisor(supervisor, update_attrs)
      assert supervisor.active == "some updated active"
      assert supervisor.supervisor_id == "some updated supervisor_id"
      assert supervisor.supervisor_name == "some updated supervisor_name"
      assert supervisor.department == "some updated department"
    end

    test "update_supervisor/2 with invalid data returns error changeset" do
      supervisor = supervisor_fixture()
      assert {:error, %Ecto.Changeset{}} = Supervisors.update_supervisor(supervisor, @invalid_attrs)
      assert supervisor == Supervisors.get_supervisor!(supervisor.id)
    end

    test "delete_supervisor/1 deletes the supervisor" do
      supervisor = supervisor_fixture()
      assert {:ok, %Supervisor{}} = Supervisors.delete_supervisor(supervisor)
      assert_raise Ecto.NoResultsError, fn -> Supervisors.get_supervisor!(supervisor.id) end
    end

    test "change_supervisor/1 returns a supervisor changeset" do
      supervisor = supervisor_fixture()
      assert %Ecto.Changeset{} = Supervisors.change_supervisor(supervisor)
    end
  end
end
