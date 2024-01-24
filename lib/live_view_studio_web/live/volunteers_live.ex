defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Volunteers.subscribe()
    end

    volunteers = Volunteers.list_volunteers()

    # create empty changeset to pass to initial form values
    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:form, to_form(changeset))
      |> assign(:count, length(volunteers))

    {:ok, socket}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:ok, _volunteer} ->
        # the create_volunteer function will send a broadcast message to all the liveViews
        # the UI post-action is handle here (locally to this process): clean form and send a flash message
        # the Backend-UI post-action is handle in handle_info callback: add new volunteer and update count in all liveViews
        changeset = Volunteers.change_volunteer(%Volunteer{})

        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> put_flash(:info, "Volunteer successfully checked in!")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    # we need to change the action when validating a changeset
    # so the browser renders the new action.
    # action is a field in the changeset struct.
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} =
      Volunteers.update_volunteer(volunteer, %{checked_out: !volunteer.checked_out})

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)
    {:ok, _} = Volunteers.delete_volunteer(volunteer)

    {:noreply, stream_delete(socket, :volunteers, volunteer)}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket =
      socket
      |> stream_insert(:volunteers, volunteer, at: 0)
      |> update(:count, fn x -> x + 1 end)

    {:noreply, socket}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    {:noreply, stream_insert(socket, :volunteers, volunteer)}
  end

  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>

    <div id="volunteer-checkin">
      <.volunteer_form form={@form} count={@count} />

      <%!-- every stream must contain a wrapping div --%>
      <div id="volunteers" phx-update="stream">
        <.volunteer
          :for={{volunteer_id, volunteer} <- @streams.volunteers}
          id={volunteer_id}
          volunteer={volunteer}
        />
      </div>
    </div>
    """
  end

  def volunteer_form(assigns) do
    ~H"""
    <div>
      <div class="count">
        Go for it! You'll be volunteer #<%= @count + 1 %>
      </div>

      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input
          field={@form[:name]}
          placeholder="Name"
          autocomplete="off"
          phx-debounce="2000"
        />
        <.input
          field={@form[:phone]}
          type="tel"
          placeholder="Phone"
          autocomplete="off"
          phx-debounce="blur"
        />
        <.button phx-disable-with="Saving...">
          Check In
        </.button>
      </.form>
    </div>
    """
  end

  def volunteer(assigns) do
    ~H"""
    <div
      id={@id}
      class={"volunteer #{if @volunteer.checked_out, do: "out"}"}
    >
      <div class="name"><%= @volunteer.name %></div>
      <div class="phone"><%= @volunteer.phone %></div>

      <div class="status">
        <button phx-click="toggle-status" phx-value-id={@volunteer.id}>
          <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
        </button>
        <.link
          class="delete"
          phx-click="delete"
          phx-value-id={@volunteer.id}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash-solid" />
        </.link>
      </div>
    </div>
    """
  end
end
