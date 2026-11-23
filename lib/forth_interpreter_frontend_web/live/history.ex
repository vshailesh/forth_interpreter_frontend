defmodule ForthInterpreterFrontendWeb.History do
  use ForthInterpreterFrontendWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class="grid grid-cols-2 space-x-2">
        <div>
          <p class="font-bold m-2">Expression Eval History</p>
          <div class="relative overflow-x-auto bg-neutral-primary-soft shadow-xs border border-default">
            <table class="w-full text-sm text-left rtl:text-right text-body">
              <thead class="bg-neutral-secondary-soft border-b border-default">
                <tr>
                  <th scope="col" class="px-6 py-3 font-medium">Expression</th>
                  <th scope="col" class="px-6 py-3 font-medium">Result</th>
                </tr>
              </thead>
              <tbody>
                <%= for value <- @single_expr_history do %>
                  {ForthInterpreterFrontendWeb.ForthComponents.call_component(value)}
                <% end %>
              </tbody>
            </table>
          </div>
        </div>

        <div>
          <p class="font-bold m-2">File Eval History</p>
          <div class="relative overflow-x-auto bg-neutral-primary-soft shadow-xs border border-default">
            <table class="w-full text-sm text-left rtl:text-right text-body">
              <thead class="bg-neutral-secondary-soft border-b border-default">
                <tr>
                  <th scope="col" class="px-6 py-3 font-medium">File Name</th>
                  <th scope="col" class="px-6 py-3 font-medium">Output Stack</th>
                </tr>
              </thead>
              <tbody>
                <%= for value <- @file_eval_history do %>
                  {ForthInterpreterFrontendWeb.ForthComponents.call_component(value)}
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    """
  end

  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(_params, _session, socket) do

    forth_expr_history = ForthInterpreterFrontend.ForthHelper.get_db_data_forth_expr()
    forth_file_history = ForthInterpreterFrontend.ForthHelper.get_db_data_forth_file()

    socket =
      socket
      |> assign(:single_expr_history, forth_expr_history)
      |> assign(:file_eval_history, forth_file_history)
    {:ok, socket}
  end


end
