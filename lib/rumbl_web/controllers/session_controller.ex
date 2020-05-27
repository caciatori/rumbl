defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias RumblWeb.Authentication

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    username = String.trim(username)

    case Accounts.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> Authentication.login(user)
        |> put_flash(:info, "Welcome back")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Password or Username")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
