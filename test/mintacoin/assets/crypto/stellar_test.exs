defmodule Mintacoin.Assets.StellarTest do
  @moduledoc """
  This module is used to test functionalities of the Stellar crypto implementation
  """
  use Mintacoin.DataCase, async: false

  alias Mintacoin.Assets.{Crypto.AssetResponse, StellarMock}

  describe "mock create_asset/1" do
    test "with an existing blockchain" do
      {:ok,
       %AssetResponse{
         tx_id: "cda25a0c343a411a3ca2927d48454abaff9ccbebd8a5c292695d0aec30b133ca",
         tx_hash: "cda25a0c343a411a3ca2927d48454abaff9ccbebd8a5c292695d0aec30b133ca"
       }} = StellarMock.create_asset([])
    end
  end
end
