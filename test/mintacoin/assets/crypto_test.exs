defmodule Mintacoin.Assets.CryptoTest do
  @moduledoc """
  This module is used to test the asset crypto calls for the different blockchains
  """
  use Mintacoin.DataCase, async: false

  alias Mintacoin.Assets.{Crypto, Crypto.AssetResponse}

  describe "create_asset/1" do
    test "with the stellar blockchain" do
      {:ok,
       %AssetResponse{
         tx_id: "cda25a0c343a411a3ca2927d48454abaff9ccbebd8a5c292695d0aec30b133ca",
         tx_hash: "cda25a0c343a411a3ca2927d48454abaff9ccbebd8a5c292695d0aec30b133ca"
       }} = Crypto.create_asset()
    end
  end
end
