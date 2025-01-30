defmodule HrDbWeb.SupervisorLiveTest do
  use HrDbWeb.ConnCase

  import Phoenix.LiveViewTest
  import HrDb.SupervisorsFixtures

  @create_attrs %{active: "some active", supervisor_id: "some supervisor_id", supervisor_name: "some supervisor_name", department: "some department"}
  @update_attrs %{active: "some updated active", supervisor_id: "some updated supervisor_id", supervisor_name: "some updated supervisor_name", department: "some updated department"}
  @invalid_attrs %{active: nil, supervisor_id: nil, supervisor_name: nil, department: nil}

  defp create_supervisor(_) do
    supervisor = supervisor_fixture()
    %{supervisor: supervisor}
  end

  describe "Index" do
    setup [:create_supervisor]

    test "lists all supervisor", %{conn: conn, supervisor: supervisor} do
      {:ok, _index_live, html} = live(conn, ~p"/supervisor")

      assert html =~ "Listing Supervisor"
      assert html =~ supervisor.active
    end

    test "saves new supervisor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/supervisor")

      assert index_live |> element("a", "New Supervisor") |> render_click() =~
               "New Supervisor"

      assert_patch(index_live, ~p"/supervisor/new")

      assert index_live
             |> form("#supervisor-form", supervisor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#supervisor-form", supervisor: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/supervisor")

      html = render(index_live)
      assert html =~ "Supervisor created successfully"
      assert html =~ "some active"
    end

    test "updates supervisor in listing", %{conn: conn, supervisor: supervisor} do
      {:ok, index_live, _html} = live(conn, ~p"/supervisor")

      assert index_live |> element("#supervisor-#{supervisor.id} a", "Edit") |> render_click() =~
               "Edit Supervisor"

      assert_patch(index_live, ~p"/supervisor/#{supervisor}/edit")

      assert index_live
             |> form("#supervisor-form", supervisor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#supervisor-form", supervisor: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/supervisor")

      html = render(index_live)
      assert html =~ "Supervisor updated successfully"
      assert html =~ "some updated active"
    end

    test "deletes supervisor in listing", %{conn: conn, supervisor: supervisor} do
      {:ok, index_live, _html} = live(conn, ~p"/supervisor")

      assert index_live |> element("#supervisor-#{supervisor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#supervisor-#{supervisor.id}")
    end
  end

  describe "Show" do
    setup [:create_supervisor]

    test "displays supervisor", %{conn: conn, supervisor: supervisor} do
      {:ok, _show_live, html} = live(conn, ~p"/supervisor/#{supervisor}")

      assert html =~ "Show Supervisor"
      assert html =~ supervisor.active
    end

    test "updates supervisor within modal", %{conn: conn, supervisor: supervisor} do
      {:ok, show_live, _html} = live(conn, ~p"/supervisor/#{supervisor}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Supervisor"

      assert_patch(show_live, ~p"/supervisor/#{supervisor}/show/edit")

      assert show_live
             |> form("#supervisor-form", supervisor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#supervisor-form", supervisor: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/supervisor/#{supervisor}")

      html = render(show_live)
      assert html =~ "Supervisor updated successfully"
      assert html =~ "some updated active"
    end
  end
end
