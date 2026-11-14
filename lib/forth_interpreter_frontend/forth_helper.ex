defmodule ForthInterpreterFrontend.ForthHelper do

  def convert_string_input_to_list(list_str) do

    final_num_list = case list_str do
      "" ->
        []
      _ ->
        list_str2 = String.trim(list_str)
        split_list_str = String.split(list_str2, ",")
        # IO.puts#{split_list_str}")
        num_list = Enum.map(split_list_str, fn x ->
          # String.match(x, ~r/\d+/)
          Regex.run(~r/\d+/, x)
        end)
        |> List.flatten
        |> Enum.map(fn x ->
          String.to_integer(x,10)
        end)
        num_list
    end
    final_num_list
  end

  def insert_data_into_db(data = %ForthInterpreterFrontend.ForthExpr{}) do
    case ForthInterpreterFrontend.Repo.insert(data) do
      {:ok, inserted} -> {:ok, inserted}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
