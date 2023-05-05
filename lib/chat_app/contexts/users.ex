defmodule ChatApp.Contexts.Users do
  alias ChatApp.Structs.User
  alias ChatApp.Repo

  def get_user(id), do: Repo.get(User, id)

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def insert_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def delete_user(%User{} = user), do: Repo.delete(user)
end
