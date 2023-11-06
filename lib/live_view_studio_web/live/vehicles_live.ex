defmodule LiveViewStudioWeb.VehiclesLive do
  alias LiveViewStudio.Vehicles
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        vehicles: [],
        loading?: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search">
        <input
          type="text"
          name="make_or_model"
          value=""
          placeholder="Make or model"
          autofocus
          autocomplete="off"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <div :if={@loading?} class="loader">Loading...</div>

      <div class="vehicles">
        <ul>
          <li :for={vehicle <- @vehicles}>
            <span class="make-model">
              <%= vehicle.make_model %>
            </span>
            <span class="color">
              <%= vehicle.color %>
            </span>
            <span class={"status #{vehicle.status}"}>
              <%= vehicle.status %>
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("search", %{"make_or_model" => make_or_model}, socket) do
    send(self(), {:run_search, make_or_model})

    socket =
      assign(socket,
        vehicles: [],
        loading?: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, make_or_model}, socket) do
    socket =
      assign(socket,
        vehicles: Vehicles.search(make_or_model),
        loading?: false
      )

    {:noreply, socket}
  end
end
