defmodule ForthInterpreterFrontendWeb.ForthComponents do
  use Phoenix.Component

  def call_component(assigns) do

    [str_expr | rest] = assigns
    rest = List.flatten(rest)
    str_rest = ["[", rest |> Enum.join(","), "]"] |> Enum.join("")
    ~H"""
      <tr class="odd:bg-gray-800 even:bg-neutral-secondary-soft border-b border-default">
        <td class="px-6 py-4">{str_expr}</td>
        <td class="px-6 py-4">{str_rest}</td>
      </tr>
    """
  end
  
end
