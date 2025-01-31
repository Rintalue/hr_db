defmodule HrDbWeb.Router do
  alias HrDbWeb.Live.ApprovalLive
  use HrDbWeb, :router

  import HrDbWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HrDbWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HrDbWeb do
    pipe_through :browser


  end

  # Other scopes may use custom stacks.
  # scope "/api", HrDbWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hr_db, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HrDbWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", HrDbWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{HrDbWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", HrDbWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{HrDbWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email


      get "/", PageController, :home

      live "/job", JobLive.Index, :index
      live "/job/new", JobLive.Index, :new
      live "/job/:id/edit", JobLive.Index, :edit

      live "/job/:id", JobLive.Show, :show
      live "/job/:id/show/edit", JobLive.Show, :edit


    live "/supervisor", SupervisorLive.Index, :index
    live "/supervisor/new", SupervisorLive.Index, :new
    live "/supervisor/:id/edit", SupervisorLive.Index, :edit

    live "/supervisor/:id", SupervisorLive.Show, :show
    live "/supervisor/:id/show/edit", SupervisorLive.Show, :edit

    live "/employee", EmployeeLive.Index, :index
    live "/employee/new", EmployeeLive.Index, :new
    live "/employee/:id/edit", EmployeeLive.Index, :edit

    live "/employee/:id", EmployeeLive.Show, :show
    live "/employee/:id/show/edit", EmployeeLive.Show, :edit

    live "/leaveday", LeavedayLive.Index, :index
    live "/leaveday/new", LeavedayLive.Index, :new
    live "/leaveday/:id/edit", LeavedayLive.Index, :edit

    live "/leaveday/:id", LeavedayLive.Show, :show
    live "/leaveday/:id/show/edit", LeavedayLive.Show, :edit

    live "/approvals", ApprovalLive.Index, :index


    get "/downloadleavedays_report", ReportController, :download_leavedays_report

    get "/downloademployees_report", ReportController, :download_employees_report

    get "/downloadsupervisors_report", ReportController, :download_supervisors_report


    get "/downloadjobs_report", ReportController, :download_jobs_report

    end
  end

  scope "/", HrDbWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{HrDbWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
