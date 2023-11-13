defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  attr :minutes, :integer
  attr :expiration, :integer, default: 24
  slot :legal, require: true
  slot :inner_block, require: true

  def promo(assigns) do
    assigns = assign_new(assigns, :minutes, fn -> assigns.expiration * 60 end)

    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @minutes %> hours
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def badge(assigns) do
    ~H"""
    <span
      {@rest}
      class={[
        "inline-flex items-center gap-0.5 rounded-full bg-gray-300 px-3 py-0.5 text-sm font-medium text-gray-800 hover:cursor-pointer",
        @class
      ]}
    >
      <%= @label %>
      <Heroicons.x_mark class="h-3 w-3 text-gray-600" />
    </span>
    """
  end
end
