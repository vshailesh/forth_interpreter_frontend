defmodule ForthInterpreterFrontend.Repo.Migrations.CreateForthFile do
  use Ecto.Migration

  def change do
    create table(:forth_file) do
      add :file_name, :string
      add :output_stack, {:array, :integer}

      timestamps(type: :utc_datetime)
    end
  end
end
