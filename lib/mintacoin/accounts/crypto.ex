defmodule Mintacoin.Accounts.Crypto do
  @moduledoc """
  This module is responsible to handle the crypto calls for the different blockchains
  """

  @behaviour Mintacoin.Accounts.Crypto.Spec

  alias Mintacoin.{Accounts.Stellar, Blockchain}

  @type status :: :ok | :error
  @type blockchain :: String.t()
  @type impl :: Stellar

  @impl true
  def create_account(opts \\ []) do
    blockchain = Keyword.get(opts, :blockchain, Blockchain.default())
    impl(blockchain).create_account(opts)
  end

  @spec impl(blockchain :: blockchain()) :: impl()
  defp impl("stellar") do
    case Application.get_env(:mintacoin, :environment, nil) do
      :test -> Mintacoin.Accounts.StellarMock
      _other -> Mintacoin.Accounts.Stellar
    end
  end
end
