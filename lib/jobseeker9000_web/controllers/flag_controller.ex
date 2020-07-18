defmodule Jobseeker9000Web.FlagController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Jobs.Flag
  alias Jobseeker9000.Jobs.Flag.Schema

  def index(conn, _params) do
    flags = Flag.list()
    render(conn, "index.html", flags: flags)
  end

  def new(conn, _params) do
    changeset = Schema.changeset(%Schema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"flag" => params}) do
    case Flag.create(params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "#{flag.name} created!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def edit(conn, %{"id" => id}) do
  #   flag = Flag.get(:flag, id)
  #   changeset = Schema.changeset(flag, %{})
  #   render(conn, "edit.html", flag: flag, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "flag" => flag_params}) do
  #   flag = Jobs.get(:flag, id)

  #   case Jobs.change(flag, flag_params) do
  #     {:ok, flag} ->
  #       conn
  #       |> put_flash(:info, "Flag updated successfully.")
  #       |> redirect(to: Routes.flag_path(conn, :edit, id))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", flag: flag, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   flag = Flag.get(:flag, id)
  #   {:ok, _flag} = Jobseeker9000.Repo.delete(flag)

  #   conn
  #   |> put_flash(:info, "Flag deleted successfully.")
  #   |> redirect(to: Routes.flag_path(conn, :index))
  # end
end
