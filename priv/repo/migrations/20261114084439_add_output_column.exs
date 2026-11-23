defmodule ForthInterpreterFrontend.Repo.Migrations.AddOutputColumn do
  use Ecto.Migration

  def change do
    alter table(:forth_expr) do
      add :output, {:array, :integer}
    end
  end
end
