defmodule Mintacoin.Assets.Crypto do
  @moduledoc """
  This module is responsible to handle the crypto calls for the different blockchains
  """

  @behaviour Mintacoin.Assets.Crypto.Spec

  alias Mintacoin.{Assets.Stellar, Blockchain}

  @type blockchain :: String.t()
  @type impl :: Stellar

  @impl true
  def create_asset(opts \\ []) do
    blockchain = Keyword.get(opts, :blockchain, Blockchain.default())

    impl(blockchain).create_asset(opts)
  end

  @spec impl(blockchain :: blockchain()) :: impl()
  defp impl("stellar") do
    case Application.get_env(:mintacoin, :environment, nil) do
      :test -> Mintacoin.Assets.StellarMock
      _other -> Mintacoin.Assets.Stellar
    end
  end
end
