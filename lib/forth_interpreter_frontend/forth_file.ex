defmodule ForthInterpreterFrontend.ForthFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forth_file" do
    field :file_name, :string
    field :output_stack, {:array, :integer}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(forth_file, attrs) do
    forth_file
    |> cast(attrs, [:file_name, :output_stack])
    |> validate_required([:file_name, :output_stack])
  end
end
