defmodule User do
  defstruct name: nil, email: nil
  def createUser(name, email), do: %__MODULE__{name: name, email: email}
end
