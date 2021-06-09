defmodule Account do
  defstruct user: User, balance: nil

  @accounts "accounts.txt"

  def register(user) do
    case search_by_email(user.email) do
      nil ->
        binary = [%__MODULE__{user: user}] ++ get_accounts()
        |> :erlang.term_to_binary()
        File.write(@accounts, binary)
      _ -> {:error, "Conta já cadastrada"}
    end
  end

  def get_accounts do
    {:ok, binary} = File.read(@accounts)
    :erlang.binary_to_term(binary)
  end

  defp search_by_email(email), do: Enum.find(get_accounts(), &(&1.user.email == email))

  def transfer(from, to, amount) do
    from = search_by_email(from.user.email)

    cond do
      balance_validation(from.balance, amount) -> {:error, "Saldo insuficiente!"}

      true ->
        to = search_by_email(to.user.email)

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
