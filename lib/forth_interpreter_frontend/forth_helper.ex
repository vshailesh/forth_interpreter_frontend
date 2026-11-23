defmodule ForthInterpreterFrontend.ForthHelper do
  import Ecto.Query, only: [from: 2]
  def convert_string_input_to_list(list_str) do
    final_num_list =
      case list_str do
        "" ->
          []

        _ ->
          list_str2 = String.trim(list_str)
          split_list_str = String.split(list_str2, ",")

          num_list =
            Enum.map(split_list_str, fn x ->
              Regex.run(~r/\d+/, x)
            end)
            |> List.flatten()
            |> Enum.map(fn x ->
              String.to_integer(x, 10)
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

  def evaluate_file_helper([], acc), do: acc
  def evaluate_file_helper([head | tail], acc) do
    case head do
      "" -> evaluate_file_helper(tail, acc)
      _ ->
        {:ok, acc} = Forth.Forth.eval(head, acc)
        evaluate_file_helper(tail, acc)
    end
  end

  def insert_file_evaluation_data(data = %ForthInterpreterFrontend.ForthFile{}) do
    case ForthInterpreterFrontend.Repo.insert(data) do
      {:ok, inserted} -> {:ok, inserted}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_db_data_forth_expr() do
    query = from d in "forth_expr",
            select: [d.expr, d.output]
    all_evaluated_expr = ForthInterpreterFrontend.Repo.all(query)
    all_evaluated_expr
  end

  def get_db_data_forth_file() do
    query = from d in "forth_file",
            select: [d.file_name, d.output_stack]
    all_evaluated_files = ForthInterpreterFrontend.Repo.all(query)
    all_evaluated_files
  end
end
