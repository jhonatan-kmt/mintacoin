defmodule Mintacoin.Accounts.AccountsTest do
  @moduledoc """
    This module is used to group common tests for Accounts functions
  """

  use Mintacoin.DataCase, async: false

  import Mintacoin.Factory, only: [insert: 1]

  alias Ecto.Adapters.SQL.Sandbox
  alias Mintacoin.{Account, Accounts, BlockchainTx, BlockchainTxs}

  setup do
    :ok = Sandbox.checkout(Mintacoin.Repo)

    %{
      invalid_address: "INVALID_ADDRESS"
    }
  end

  describe "create_account/1" do
    test "with valid params" do
      %{name: blockchain, network: network} = insert(:blockchain)

      {:ok, %Account{id: account_id}} =
        Accounts.create_account(%{blockchain: blockchain, network: network})

      {:ok, [%BlockchainTx{account_id: ^account_id}]} =
        BlockchainTxs.retrieve_by_account_id(account_id)
    end

    test "with invalid blockchain" do
      {:error, :invalid_blockchain} =
        Accounts.create_account(%{blockchain: "invalid_blockchain", network: "mainnet"})
    end
  end

  test "create/0" do
    {:ok, %Account{}} = Accounts.create()
  end

  describe "retrieve/1" do
    test "with valid address" do
      %Account{address: address} = insert(:account)
      {:ok, %Account{address: ^address}} = Accounts.retrieve(address)
    end

    test "with non existing address", %{invalid_address: invalid_address} do
      {:ok, nil} = Accounts.retrieve(invalid_address)
    end
  end

  describe "recover_signature/2" do
    test "should return signature" do
      %Account{address: address, seed_words: seed_words, signature: signature} = insert(:account)

      {:ok, ^signature} = Accounts.recover_signature(address, seed_words)
    end

    test "with invalid seed words" do
      %Account{address: address} = insert(:account)

      {:error, :invalid_seed_words} =
        Accounts.recover_signature(
          address,
          "these are twelve really bad seed words for the account retrieve by"
        )
    end
  end
end
