defmodule ForthInterpreterFrontendWeb.ForthForm do
  use ForthInterpreterFrontendWeb, :live_view
  alias Forth.Forth

  def render(assigns) do
    ~H"""
      <div>
        We should handler this with a function component.
        <form
          phx-submit="evaluate_expression"
          id="expression"
          class="flex flex-col max-w-96 mx-auto p-24"
        >
          <h1>Enter you expression here</h1>
          <input type="text" name="input[expr]" placeholder="2 3 +" />

          <div>
            Start entering your initial stack here
            <input type="text" name="input[init_stack]" placeholder="[1,2,3]" />
          </div>

          <button type="submit">Evaluate</button>
        </form>
      </div>

    """
  end

  def mount(_params, _session, socket) do

    # form =
    #   ForthInterpreterFrontend.ForthExpr.changeset(%ForthInterpreterFrontend.ForthExpr{})
    #   |> to_form()

    # socket =
    #   socket
    #   |> assign(form: form)
    {:ok, socket}
  end


  def handle_event("validate", %{"expr" => params}, socket) do
    {:ok, socket}
  end

  def handle_event("evaluate", %{"expr" => params}, socket) do

    {:ok, socket}
  end

  def handle_event("evaluate_expression", %{"input" => %{"expr" => expr_str, "init_stack" => init_stack_str}}, socket) do
    # transform thigs to appropriate format and push them into the DB.

    init_stack_int = ForthInterpreterFrontend.ForthHelper.convert_string_input_to_list(init_stack_str)


    {:ok, ret_val} = Forth.eval(expr_str, init_stack_int)

    IO.inspect("#{ret_val}")
    data = %ForthInterpreterFrontend.ForthExpr{expr: expr_str, init_stack: ret_val}
    ForthInterpreterFrontend.ForthHelper.insert_data_into_db()

    {:noreply, socket}
  end

  def handle_event("evaluate_input_file", _params, socket) do

  end

end
