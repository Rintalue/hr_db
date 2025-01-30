defmodule HrDb.LeavedaysTest do
  use HrDb.DataCase

  alias HrDb.Leavedays

  describe "leaveday" do
    alias HrDb.Leavedays.Leaveday

    import HrDb.LeavedaysFixtures

    @invalid_attrs %{reason: nil, status: nil, employee_id: nil, first_name: nil, last_name: nil, email: nil, phone_number: nil, leave_days: nil, start_date: nil, end_date: nil}

    test "list_leaveday/0 returns all leaveday" do
      leaveday = leaveday_fixture()
      assert Leavedays.list_leaveday() == [leaveday]
    end

    test "get_leaveday!/1 returns the leaveday with given id" do
      leaveday = leaveday_fixture()
      assert Leavedays.get_leaveday!(leaveday.id) == leaveday
    end

    test "create_leaveday/1 with valid data creates a leaveday" do
      valid_attrs = %{reason: "some reason", status: "some status", employee_id: "some employee_id", first_name: "some first_name", last_name: "some last_name", email: "some email", phone_number: "some phone_number", leave_days: "some leave_days", start_date: ~D[2025-01-27], end_date: ~D[2025-01-27]}

      assert {:ok, %Leaveday{} = leaveday} = Leavedays.create_leaveday(valid_attrs)
      assert leaveday.reason == "some reason"
      assert leaveday.status == "some status"
      assert leaveday.employee_id == "some employee_id"
      assert leaveday.first_name == "some first_name"
      assert leaveday.last_name == "some last_name"
      assert leaveday.email == "some email"
      assert leaveday.phone_number == "some phone_number"
      assert leaveday.leave_days == "some leave_days"
      assert leaveday.start_date == ~D[2025-01-27]
      assert leaveday.end_date == ~D[2025-01-27]
    end

    test "create_leaveday/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leavedays.create_leaveday(@invalid_attrs)
    end

    test "update_leaveday/2 with valid data updates the leaveday" do
      leaveday = leaveday_fixture()
      update_attrs = %{reason: "some updated reason", status: "some updated status", employee_id: "some updated employee_id", first_name: "some updated first_name", last_name: "some updated last_name", email: "some updated email", phone_number: "some updated phone_number", leave_days: "some updated leave_days", start_date: ~D[2025-01-28], end_date: ~D[2025-01-28]}

      assert {:ok, %Leaveday{} = leaveday} = Leavedays.update_leaveday(leaveday, update_attrs)
      assert leaveday.reason == "some updated reason"
      assert leaveday.status == "some updated status"
      assert leaveday.employee_id == "some updated employee_id"
      assert leaveday.first_name == "some updated first_name"
      assert leaveday.last_name == "some updated last_name"
      assert leaveday.email == "some updated email"
      assert leaveday.phone_number == "some updated phone_number"
      assert leaveday.leave_days == "some updated leave_days"
      assert leaveday.start_date == ~D[2025-01-28]
      assert leaveday.end_date == ~D[2025-01-28]
    end

    test "update_leaveday/2 with invalid data returns error changeset" do
      leaveday = leaveday_fixture()
      assert {:error, %Ecto.Changeset{}} = Leavedays.update_leaveday(leaveday, @invalid_attrs)
      assert leaveday == Leavedays.get_leaveday!(leaveday.id)
    end

    test "delete_leaveday/1 deletes the leaveday" do
      leaveday = leaveday_fixture()
      assert {:ok, %Leaveday{}} = Leavedays.delete_leaveday(leaveday)
      assert_raise Ecto.NoResultsError, fn -> Leavedays.get_leaveday!(leaveday.id) end
    end

    test "change_leaveday/1 returns a leaveday changeset" do
      leaveday = leaveday_fixture()
      assert %Ecto.Changeset{} = Leavedays.change_leaveday(leaveday)
    end
  end
end
