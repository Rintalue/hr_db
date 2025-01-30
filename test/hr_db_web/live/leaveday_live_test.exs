defmodule HrDbWeb.LeavedayLiveTest do
  use HrDbWeb.ConnCase

  import Phoenix.LiveViewTest
  import HrDb.LeavedaysFixtures

  @create_attrs %{reason: "some reason", status: "some status", employee_id: "some employee_id", first_name: "some first_name", last_name: "some last_name", email: "some email", phone_number: "some phone_number", leave_days: "some leave_days", start_date: "2025-01-27", end_date: "2025-01-27"}
  @update_attrs %{reason: "some updated reason", status: "some updated status", employee_id: "some updated employee_id", first_name: "some updated first_name", last_name: "some updated last_name", email: "some updated email", phone_number: "some updated phone_number", leave_days: "some updated leave_days", start_date: "2025-01-28", end_date: "2025-01-28"}
  @invalid_attrs %{reason: nil, status: nil, employee_id: nil, first_name: nil, last_name: nil, email: nil, phone_number: nil, leave_days: nil, start_date: nil, end_date: nil}

  defp create_leaveday(_) do
    leaveday = leaveday_fixture()
    %{leaveday: leaveday}
  end

  describe "Index" do
    setup [:create_leaveday]

    test "lists all leaveday", %{conn: conn, leaveday: leaveday} do
      {:ok, _index_live, html} = live(conn, ~p"/leaveday")

      assert html =~ "Listing Leaveday"
      assert html =~ leaveday.reason
    end

    test "saves new leaveday", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/leaveday")

      assert index_live |> element("a", "New Leaveday") |> render_click() =~
               "New Leaveday"

      assert_patch(index_live, ~p"/leaveday/new")

      assert index_live
             |> form("#leaveday-form", leaveday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leaveday-form", leaveday: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaveday")

      html = render(index_live)
      assert html =~ "Leaveday created successfully"
      assert html =~ "some reason"
    end

    test "updates leaveday in listing", %{conn: conn, leaveday: leaveday} do
      {:ok, index_live, _html} = live(conn, ~p"/leaveday")

      assert index_live |> element("#leaveday-#{leaveday.id} a", "Edit") |> render_click() =~
               "Edit Leaveday"

      assert_patch(index_live, ~p"/leaveday/#{leaveday}/edit")

      assert index_live
             |> form("#leaveday-form", leaveday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leaveday-form", leaveday: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaveday")

      html = render(index_live)
      assert html =~ "Leaveday updated successfully"
      assert html =~ "some updated reason"
    end

    test "deletes leaveday in listing", %{conn: conn, leaveday: leaveday} do
      {:ok, index_live, _html} = live(conn, ~p"/leaveday")

      assert index_live |> element("#leaveday-#{leaveday.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leaveday-#{leaveday.id}")
    end
  end

  describe "Show" do
    setup [:create_leaveday]

    test "displays leaveday", %{conn: conn, leaveday: leaveday} do
      {:ok, _show_live, html} = live(conn, ~p"/leaveday/#{leaveday}")

      assert html =~ "Show Leaveday"
      assert html =~ leaveday.reason
    end

    test "updates leaveday within modal", %{conn: conn, leaveday: leaveday} do
      {:ok, show_live, _html} = live(conn, ~p"/leaveday/#{leaveday}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Leaveday"

      assert_patch(show_live, ~p"/leaveday/#{leaveday}/show/edit")

      assert show_live
             |> form("#leaveday-form", leaveday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#leaveday-form", leaveday: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/leaveday/#{leaveday}")

      html = render(show_live)
      assert html =~ "Leaveday updated successfully"
      assert html =~ "some updated reason"
    end
  end
end
