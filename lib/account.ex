defmodule Account do
  defstruct user: User, balance: nil

  def register(user), do: %__MODULE__{user: user, balance: 1000}

  def transfer(accounts, from, to, amount) do
    from = Enum.find(accounts, fn account -> account.user.email == from.user.email end)

    cond do
      balance_validation(from.balance, amount) -> {:error, "Saldo insuficiente!"}

      true ->
        to = Enum.find(accounts, fn account -> account.user.email == to.user.email end)

        from = %Account{from | balance: from.balance - amount}
        to = %Account{to | balance: to.balance + amount}

      [from, to]
    end
  end

  def withdraw(account, amount) do
    cond do
      balance_validation(account.balance, amount) -> {:error, "Saldo insuficiente!"}
      true ->
        account = %Account{account | balance: account.balance - amount}
        {:ok, account, "mensagem de email encaminhada"}
    end
  end

  defp balance_validation(balance, amount), do: balance < amount
end
