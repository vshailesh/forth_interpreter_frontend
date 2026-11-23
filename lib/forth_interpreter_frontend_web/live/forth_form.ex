defmodule ForthInterpreterFrontendWeb.ForthForm do
  use ForthInterpreterFrontendWeb, :live_view
  alias Forth.Forth

  def render(assigns) do
    ~H"""
    <div class="flex-row p-4">


    <div class="absolute bottom-0 right-0 mr-2 mb-4">
          <.link navigate={~p"/history"} class="mt-10 ml-2.5 justify-center inline-flex items-center rounded-md bg-amber-400
                px-3 py-1.5 text-sm/6 font-semibold text-black hover:bg-amber-500
                focus:outline-2 focus:outline-offset-2 focus:outline-amber-500"> Check History</.link>
        </div>
      <div class="border-1 rounded-box grid grid-cols-2">
        <form
          phx-submit="evaluate_expression"
          id="expression"
          class="flex flex-col max-w-96 mx-auto p-24 space-y-1"
        >
          <div>
            <h1>Enter you expression here</h1>
            <input type="text" name="input[expr]" placeholder="2 3 +" class="bg-amber-100 text-black rounded-sm pl-1"/>
          </div>
          <div>
            Enter initial stack here
            <input type="text" name="input[init_stack]" placeholder="[1,2,3]" class="bg-amber-100 text-black rounded-sm pl-1"/>
          </div>

          <button type="submit" class="mt-10 ml-2.5 justify-center inline-flex items-center rounded-md bg-amber-400
            px-3 py-1.5 text-sm/6 font-semibold text-black hover:bg-amber-500
            focus:outline-2 focus:outline-offset-2 focus:outline-amber-500
          ">Evaluate</button>
        </form>

        <div class="mx-auto text-black flex flex-col max-w-96 p-24">
          <h1 class="text-white mb-1">Output</h1>
          <textarea class="bg-white rounded-lg text-xl rounded-base placeholder:text-body p-3.5" placeholder="Output will appear here....">
            <%= if @expr_answer != "" do %>
              {@expr_answer}
            <% else %>
              []
            <% end %>
          </textarea>
        </div>

        <button type=""></button>
      </div>

      <div class="pt-6 my-4 grid grid-cols-2">
        <form id="upload-form" phx-change="validate" phx-submit="save" class="ml-auto box-border size-64 border-4 p-4 flex flex-col items-center justify-center border-dotted rounded-lg">
          <.live_file_input upload={@uploads.file} class="hidden"/>
          <label
            for={@uploads.file.ref}
            class="justify-center inline-block cursor-pointer rounded bg-white px-2 py-1 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-100"
          >
            Choose a File to Evaluate
          </label>
          <div class="p-2">
            <button type="submit" class="inline-flex items-center gap-2 rounded-md bg-amber-400 px-3 py-1.5 text-sm/6 font-semibold text-black hover:bg-amber-500
            focus:outline-2 focus:outline-offset-2 focus:outline-amber-500">Upload</button>
          </div>
        </form>
        <div class="mx-auto text-black flex flex-col max-w-96 p-24">
          <h1 class="text-white mb-1">File Output</h1>
          <textarea class="bg-white rounded-lg border border-default-medium text-heading text-xl rounded-base focus:ring-brand
           focus:border-brand block w-full p-3.5 shadow-xs placeholder:text-body" placeholder="File Output will appear here....">
            <%= if @file_ans != "" do %>
              {@file_ans}
            <% else %>
              []
            <% end %>
          </textarea>
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :file, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    [[file_name | uploaded_files]] =
      consume_uploaded_entries(socket, :file, fn %{path: path}, entry ->
        # dest = Path.join([:code.priv_dir(:forth_interpreter_frontend), "static", "uploads", Path.basename(path)])
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        # File.cp!(path, dest)
        # {:ok, ~p"/uploads/#{Path.basename(dest)}"}
        cn = entry.client_name
        line_in_enum = File.read!(path) |> String.split("\n")
        {:ok, [cn | line_in_enum]}
      end)
      answer = ForthInterpreterFrontend.ForthHelper.evaluate_file_helper(uploaded_files,[])
      # fin = answer |> Enum.map(fn x -> Integer.to_string(x) end)
      fin = ["[", answer |> Enum.join(","), "]"] |> Enum.join("")

      data = %ForthInterpreterFrontend.ForthFile{
        file_name: file_name,
        output_stack: answer
      }

      case ForthInterpreterFrontend.ForthHelper.insert_file_evaluation_data(data) do
        {:ok, inserted} ->
          socket =
            socket
            |> assign(:file_ans, fin)
            |> assign(:file_name, file_name)
          {:noreply, socket}

        {:error, changeset} -> {:noreply, socket}
      end

  end

  @spec mount(any(), any(), map()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    # socket =
    #   socket
    #   |> assign(:uploaded_files, [])
    #   |> allow_upload(:file,
    #     accept: :any,
    #     max_entries: 1,
    #     max_file_size: 10_000_000,
    #     auto_upload: true
    #   )
    # {:ok, socket}

    {:ok,
      socket
      |> assign(:uploaded_files, [])
      |> assign(:expr_answer, "")
      |> assign(:file_ans, "")
      |> allow_upload(:file, accept: :any, max_entries: 1)}
  end

  def handle_event("validate", %{"expr" => params}, socket) do
    {:ok, socket}
  end

  def handle_event("evaluate", %{"expr" => params}, socket) do
    {:ok, socket}
  end

  def handle_event(
        "evaluate_expression",
        %{"input" => %{"expr" => expr_str, "init_stack" => init_stack_str}},
        socket
      ) do
    # transform things to appropriate format and push them into the DB.
    init_stack_int =
      ForthInterpreterFrontend.ForthHelper.convert_string_input_to_list(init_stack_str)

    {:ok, ret_val} = Forth.eval(expr_str, init_stack_int)

    data = %ForthInterpreterFrontend.ForthExpr{
      expr: expr_str,
      init_stack: init_stack_int,
      output: ret_val
    }

    case ForthInterpreterFrontend.ForthHelper.insert_data_into_db(data) do
      {:ok, inserted} ->

        ans_to_string = ["[", ret_val |> Enum.join(","), "]"] |> Enum.join("")

        socket =
          socket
          |> assign(:expr_answer, ans_to_string)
        {:ok, socket}
        {:noreply, socket}
      {:error, changeset} -> {:error, changeset}
    end
    # socket =
    #   socket
    #   |> assign(:expr_answer, )
    # {:ok, socket}
  end

  def handle_event("validate-upload", _params, socket) do
    {:noreply, socket}
  end
end
