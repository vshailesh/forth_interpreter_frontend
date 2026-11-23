defmodule ForthInterpreterFrontend.Repo.Migrations.CreateForthExpr do
  use Ecto.Migration

  def change do
    create table(:forth_expr) do
      add :expr, :string
      add :init_stack, {:array, :integer}

      timestamps(type: :utc_datetime)
    end
  end
end
