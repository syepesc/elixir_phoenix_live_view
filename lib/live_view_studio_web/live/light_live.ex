defmodule LiveViewStudioWeb.LightLive do
  # Use live view behaviour
  use LiveViewStudioWeb, :live_view

  # The live view behaviour implements 3 main callbacks
  # 1) mount
  # 2) render
  # 3) handle_event

  def mount(_params, _session, socket) do
    # params: contains the params from the request.
    # session: contains information about the session.
    # socket (struct): is where the live view state process is store.

    # To assign a state to the socket
    socket = assign(socket, brightness: 10, temp: "3000")

    # mount should return either 2 tuples
    {:ok, socket}
    # {:noreply, socket}
  end

  def render(assigns) do
    # To render live view state we use the render callback
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temp)}"}>
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="/images/light-off.svg" />
      </button>

      <button phx-click="down">
        <img src="/images/down.svg" />
      </button>

      <button phx-click="up">
        <img src="/images/up.svg" />
      </button>

      <button phx-click="on">
        <img src="/images/light-on.svg" />
      </button>

      <button phx-click="random">
        <img src="/images/fire.svg" />
      </button>

      <form phx-change="update">
        <input
          type="range"
          min="0"
          max="100"
          name="brightness"
          value={@brightness}
        />
      </form>

      <form phx-change="change-temp">
        <div class="temps">
          <%= for temp <- ["3000", "4000", "5000"] do %>
            <div>
              <input
                type="radio"
                id={temp}
                name="temp"
                value={temp}
                checked={temp == @temp}
              />
              <label for={temp}><%= temp %></label>
            </div>
          <% end %>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("on", _unsigned_params, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("down", _unsigned_params, socket) do
    brightness =
      if socket.assigns.brightness - 10 <= 0 do
        0
      else
        socket.assigns.brightness - 10
      end

    socket = assign(socket, brightness: brightness)

    {:noreply, socket}
  end

  def handle_event("up", _unsigned_params, socket) do
    brightness =
      if socket.assigns.brightness + 10 >= 100 do
        100
      else
        socket.assigns.brightness + 10
      end

    socket = assign(socket, brightness: brightness)

    {:noreply, socket}
  end

  def handle_event("off", _unsigned_params, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("random", _unsigned_params, socket) do
    socket = assign(socket, brightness: Enum.random(0..100))
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    socket = assign(socket, brightness: String.to_integer(brightness))
    {:noreply, socket}
  end

  def handle_event("change-temp", %{"temp" => temp}, socket) do
    socket = assign(socket, temp: temp)
    {:noreply, socket}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#46A11B"
  defp temp_color("5000"), do: "#99CCFF"
end
