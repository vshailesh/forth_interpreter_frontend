defmodule ForthInterpreterFrontend.ForthExpr do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forth_expr" do
    field :expr, :string
    field :init_stack, {:array, :integer}
    field :output, {:array, :integer}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(forth_expr, attrs \\ %{}) do
    forth_expr
    |> cast(attrs, [:expr, :init_stack])
    |> validate_required([:expr, :init_stack])
  end
end
