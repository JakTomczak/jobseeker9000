defmodule Jobseeker9000Web.OfferController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Jobs.Offer

  def index(conn, _params) do
    offers = Jobs.list(:offer)
    render(conn, "index.html", offers: offers)
  end

  def edit(conn, %{"id" => id}) do
    offer = Jobs.get(:offer, id)
    changeset = Offer.changeset(offer, %{})
    render(conn, "edit.html", offer: offer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "offer" => offer_params}) do
    offer = Jobs.get(:offer, id)

    case Jobs.change(offer, offer_params) do
      {:ok, offer} ->
        conn
        |> put_flash(:info, "Offer updated successfully.")
        |> redirect(to: Routes.offer_path(conn, :edit, id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", offer: offer, changeset: changeset)
    end
  end
end